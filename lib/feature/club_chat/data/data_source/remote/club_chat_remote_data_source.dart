import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/club_chat/data/model/club_message_model.dart';

/// Abstract club chat remote data source
abstract class ClubChatRemoteDataSource {
  /// Send a message to club chat
  Future<Either<Failure, Unit>> sendMessage({
    required final String clubId,
    required final String message,
  });

  /// Get messages stream for a club
  Stream<Either<Failure, List<ClubMessageModel>>> getMessagesStream(
    final String clubId,
  );

  /// Get club members
  Future<Either<Failure, List<UserModel>>> getClubMembers(final String clubId);

  /// Get pending join requests
  Future<Either<Failure, List<UserModel>>> getPendingRequests(
    final String clubId,
  );

  /// Accept join request
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  );

  /// Reject join request
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  );
}

class ClubChatRemoteDataSourceImpl implements ClubChatRemoteDataSource {
  ClubChatRemoteDataSourceImpl({
    required this.firestoreService,
    required this.authService,
  });

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, Unit>> sendMessage({
    required final String clubId,
    required final String message,
  }) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
      final String currentUserId,
    ) async {
      final Either<Failure, Map<String, dynamic>> userResult =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'users',
            docId: currentUserId,
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
          );

      return userResult.fold(Left.new, (
        final Map<String, dynamic> userData,
      ) async {
        final String messageId = DateTime.now().millisecondsSinceEpoch
            .toString();

        final ClubMessageModel clubMessage = ClubMessageModel(
          id: messageId,
          clubId: clubId,
          senderId: currentUserId,
          senderName: userData['name']?.toString() ?? 'Unknown',
          message: message,
          timestamp: DateTime.now(),
        );

        return firestoreService.request<Unit>(
          collectionPath: 'clubs/$clubId/messages',
          docId: messageId,
          method: FirestoreMethod.set,
          data: clubMessage.toJson(),
          responseParser: (_) => unit,
        );
      });
    });
  }

  @override
  Stream<Either<Failure, List<ClubMessageModel>>> getMessagesStream(
    final String clubId,
  ) {
    return firestoreService
        .listenToCollection(
          collectionPath: 'clubs/$clubId/messages',
          queryBuilder: (final Query<Map<String, dynamic>> query) =>
              query.orderBy('timestamp', descending: true).limit(100),
        )
        .map(
          (final Either<Failure, List<Map<String, dynamic>>> either) =>
              either.map(
                (final List<Map<String, dynamic>> docs) => docs
                    .map(
                      (final Map<String, dynamic> data) =>
                          ClubMessageModel.fromFirestore(data: data),
                    )
                    .toList(),
              ),
        );
  }

  @override
  Future<Either<Failure, List<UserModel>>> getClubMembers(
    final String clubId,
  ) async {
    final Either<Failure, Map<String, dynamic>> clubResult =
        await firestoreService.request<Map<String, dynamic>>(
          collectionPath: 'clubs',
          docId: clubId,
          method: FirestoreMethod.get,
          responseParser: (final data) => data as Map<String, dynamic>,
        );

    return clubResult.fold(Left.new, (
      final Map<String, dynamic> clubData,
    ) async {
      final List<String> memberIds =
          (clubData['memberIds'] as List<dynamic>?)
              ?.map((final e) => e.toString())
              .toList() ??
          <String>[];

      if (memberIds.isEmpty) {
        return const Right(<UserModel>[]);
      }

      final List<UserModel> members = <UserModel>[];

      for (final String memberId in memberIds) {
        final Either<Failure, Map<String, dynamic>> userResult =
            await firestoreService.request<Map<String, dynamic>>(
              collectionPath: 'users',
              docId: memberId,
              method: FirestoreMethod.get,
              responseParser: (final data) => data as Map<String, dynamic>,
            );

        userResult.fold((_) {}, (final Map<String, dynamic> userData) {
          members.add(UserModel.fromFirestore(data: userData));
        });
      }

      return Right(members);
    });
  }

  @override
  Future<Either<Failure, List<UserModel>>> getPendingRequests(
    final String clubId,
  ) async {
    final Either<Failure, Map<String, dynamic>> clubResult =
        await firestoreService.request<Map<String, dynamic>>(
          collectionPath: 'clubs',
          docId: clubId,
          method: FirestoreMethod.get,
          responseParser: (final data) => data as Map<String, dynamic>,
        );

    return clubResult.fold(Left.new, (
      final Map<String, dynamic> clubData,
    ) async {
      final List<String> pendingRequestIds =
          (clubData['pendingRequestIds'] as List<dynamic>?)
              ?.map((final e) => e.toString())
              .toList() ??
          <String>[];

      if (pendingRequestIds.isEmpty) {
        return const Right(<UserModel>[]);
      }

      final List<UserModel> pendingUsers = <UserModel>[];

      for (final String userId in pendingRequestIds) {
        final Either<Failure, Map<String, dynamic>> userResult =
            await firestoreService.request<Map<String, dynamic>>(
              collectionPath: 'users',
              docId: userId,
              method: FirestoreMethod.get,
              responseParser: (final data) => data as Map<String, dynamic>,
            );

        userResult.fold((_) {}, (final Map<String, dynamic> userData) {
          pendingUsers.add(UserModel.fromFirestore(data: userData));
        });
      }

      return Right(pendingUsers);
    });
  }

  @override
  Future<Either<Failure, Unit>> acceptJoinRequest(
    final String clubId,
    final String userId,
  ) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
      final String currentUserId,
    ) async {
      final Either<Failure, Map<String, dynamic>> clubResult =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'clubs',
            docId: clubId,
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
          );

      return clubResult.fold(Left.new, (
        final Map<String, dynamic> clubData,
      ) async {
        final String? creatorId = clubData['creatorId'] as String?;

        if (creatorId != currentUserId) {
          return const Left(
            Failure(message: 'Only creator can accept requests'),
          );
        }

        final List<String> memberIds =
            (clubData['memberIds'] as List<dynamic>?)
                ?.map((final e) => e.toString())
                .toList() ??
            <String>[];
        final List<String> pendingRequestIds =
            (clubData['pendingRequestIds'] as List<dynamic>?)
                ?.map((final e) => e.toString())
                .toList() ??
            <String>[];

        if (!pendingRequestIds.contains(userId)) {
          return const Left(
            Failure(message: 'No pending request from this user'),
          );
        }

        final List<String> updatedMembers = <String>[...memberIds, userId];
        final List<String> updatedRequests = pendingRequestIds
            .where((final String id) => id != userId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          docId: clubId,
          method: FirestoreMethod.set,
          data: <String, dynamic>{
            'memberIds': updatedMembers,
            'pendingRequestIds': updatedRequests,
          },
          merge: true,
          responseParser: (_) => unit,
        );
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> rejectJoinRequest(
    final String clubId,
    final String userId,
  ) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
      final String currentUserId,
    ) async {
      final Either<Failure, Map<String, dynamic>> clubResult =
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'clubs',
            docId: clubId,
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
          );

      return clubResult.fold(Left.new, (
        final Map<String, dynamic> clubData,
      ) async {
        final String? creatorId = clubData['creatorId'] as String?;

        if (creatorId != currentUserId) {
          return const Left(
            Failure(message: 'Only creator can reject requests'),
          );
        }

        final List<String> pendingRequestIds =
            (clubData['pendingRequestIds'] as List<dynamic>?)
                ?.map((final e) => e.toString())
                .toList() ??
            <String>[];

        if (!pendingRequestIds.contains(userId)) {
          return const Left(
            Failure(message: 'No pending request from this user'),
          );
        }

        final List<String> updatedRequests = pendingRequestIds
            .where((final String id) => id != userId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          docId: clubId,
          method: FirestoreMethod.set,
          data: <String, dynamic>{'pendingRequestIds': updatedRequests},
          merge: true,
          responseParser: (_) => unit,
        );
      });
    });
  }
}
