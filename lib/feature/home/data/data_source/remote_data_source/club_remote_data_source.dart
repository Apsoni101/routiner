import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/home/data/model/club_model.dart';

/// Abstract club remote data source
abstract class ClubRemoteDataSource {
  /// Get current user ID
  Future<Either<Failure, String>> getCurrentUserId();

  /// Create a new club
  Future<Either<Failure, ClubModel>> createClub({
    required final String name,
    required final String description,
    final String? imageUrl,
  });

  /// Get all clubs
  Future<Either<Failure, List<ClubModel>>> getAllClubs();

  /// Get clubs user is a member of
  Future<Either<Failure, List<ClubModel>>> getUserClubs();

  /// Request to join a club
  Future<Either<Failure, Unit>> requestToJoinClub(final String clubId);

  /// Accept join request (creator only)
  Future<Either<Failure, Unit>> acceptJoinRequest(
      final String clubId,
      final String userId,
      );

  /// Reject join request (creator only)
  Future<Either<Failure, Unit>> rejectJoinRequest(
      final String clubId,
      final String userId,
      );

  /// Add member to club (creator only)
  Future<Either<Failure, Unit>> addMember(
      final String clubId,
      final String userId,
      );

  /// Remove member from club (creator only)
  Future<Either<Failure, Unit>> removeMember(
      final String clubId,
      final String userId,
      );

  /// Get club by ID
  Future<Either<Failure, ClubModel>> getClubById(final String clubId);

  /// Leave club
  Future<Either<Failure, Unit>> leaveClub(final String clubId);
}

/// Implementation of club remote data source
class ClubRemoteDataSourceImpl implements ClubRemoteDataSource {
  ClubRemoteDataSourceImpl({
    required this.firestoreService,
    required this.authService,
  });

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, String>> getCurrentUserId() async {
    return await authService.getCurrentUserId();
  }

  @override
  Future<Either<Failure, ClubModel>> createClub({
    required final String name,
    required final String description,
    final String? imageUrl,
  }) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
        final String currentUserId,
        ) async {
      final Either<Failure, String> docIdResult = await firestoreService
          .request<String>(
        collectionPath: 'clubs',
        method: FirestoreMethod.add,
        responseParser: (final data) => data as String,
        data: <String, dynamic>{},
      );

      return await docIdResult.fold(Left.new, (final String clubId) async {
        final ClubModel club = ClubModel(
          id: clubId,
          name: name,
          description: description,
          creatorId: currentUserId,
          createdAt: DateTime.now(),
          memberIds: <String>[currentUserId],
          pendingRequestIds: const <String>[],
          imageUrl: imageUrl,
        );

        final Either<Failure, Unit> result = await firestoreService
            .request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: club.toJson(),
        );

        return result.fold(Left.new, (_) => Right(club));
      });
    });
  }

  @override
  Future<Either<Failure, List<ClubModel>>> getAllClubs() async {
    final Either<Failure, List<Map<String, dynamic>>> result =
    await firestoreService.request<List<Map<String, dynamic>>>(
      collectionPath: 'clubs',
      method: FirestoreMethod.query,
      responseParser: (final data) => (data as List<dynamic>)
          .map((final e) => e as Map<String, dynamic>)
          .toList(),
      queryBuilder: (final Query<Map<String, dynamic>> query) =>
          query.orderBy('createdAt', descending: true),
    );

    return result.fold(
      Left.new,
          (final List<Map<String, dynamic>> data) => Right(
        data
            .map(
              (final Map<String, dynamic> json) =>
              ClubModel.fromFirestore(data: json),
        )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<ClubModel>>> getUserClubs() async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
        final String currentUserId,
        ) async {
      final Either<Failure, List<Map<String, dynamic>>> result =
      await firestoreService.request<List<Map<String, dynamic>>>(
        collectionPath: 'clubs',
        method: FirestoreMethod.query,
        responseParser: (final data) => (data as List<dynamic>)
            .map((final e) => e as Map<String, dynamic>)
            .toList(),
        queryBuilder: (final Query<Map<String, dynamic>> query) => query
            .where('memberIds', arrayContains: currentUserId)
            .orderBy('createdAt', descending: true),
      );

      return result.fold(
        Left.new,
            (final List<Map<String, dynamic>> data) => Right(
          data
              .map(
                (final Map<String, dynamic> json) =>
                ClubModel.fromFirestore(data: json),
          )
              .toList(),
        ),
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> requestToJoinClub(final String clubId) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
        final String currentUserId,
        ) async {
      final Either<Failure, Map<String, dynamic>> clubResult =
      await firestoreService.request<Map<String, dynamic>>(
        collectionPath: 'clubs',
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (club.isMember(currentUserId)) {
          return const Left(Failure(message: 'Already a member'));
        }

        if (club.hasPendingRequest(currentUserId)) {
          return const Left(Failure(message: 'Request already pending'));
        }

        final List<String> updatedRequests = <String>[
          ...club.pendingRequestIds,
          currentUserId,
        ];

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{'pendingRequestIds': updatedRequests},
          merge: true,
        );
      });
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
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (!club.isCreator(currentUserId)) {
          return const Left(
            Failure(message: 'Only creator can accept requests'),
          );
        }

        final List<String> updatedMembers = <String>[...club.memberIds, userId];
        final List<String> updatedRequests = club.pendingRequestIds
            .where((final String id) => id != userId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{
            'memberIds': updatedMembers,
            'pendingRequestIds': updatedRequests,
          },
          merge: true,
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
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (!club.isCreator(currentUserId)) {
          return const Left(
            Failure(message: 'Only creator can reject requests'),
          );
        }

        final List<String> updatedRequests = club.pendingRequestIds
            .where((final String id) => id != userId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{'pendingRequestIds': updatedRequests},
          merge: true,
        );
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> addMember(
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
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (!club.isCreator(currentUserId)) {
          return const Left(Failure(message: 'Only creator can add members'));
        }

        if (club.isMember(userId)) {
          return const Left(Failure(message: 'User is already a member'));
        }

        final List<String> updatedMembers = <String>[...club.memberIds, userId];

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{'memberIds': updatedMembers},
          merge: true,
        );
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> removeMember(
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
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (!club.isCreator(currentUserId)) {
          return const Left(
            Failure(message: 'Only creator can remove members'),
          );
        }

        if (userId == currentUserId) {
          return const Left(
            Failure(message: 'Creator cannot remove themselves'),
          );
        }

        final List<String> updatedMembers = club.memberIds
            .where((final String id) => id != userId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{'memberIds': updatedMembers},
          merge: true,
        );
      });
    });
  }

  @override
  Future<Either<Failure, ClubModel>> getClubById(final String clubId) async {
    final Either<Failure, Map<String, dynamic>> result = await firestoreService
        .request<Map<String, dynamic>>(
      collectionPath: 'clubs',
      method: FirestoreMethod.get,
      responseParser: (final data) => data as Map<String, dynamic>,
      docId: clubId,
    );

    return result.fold(
      Left.new,
          (final Map<String, dynamic> data) =>
          Right(ClubModel.fromFirestore(data: data)),
    );
  }

  @override
  Future<Either<Failure, Unit>> leaveClub(final String clubId) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
        final String currentUserId,
        ) async {
      final Either<Failure, Map<String, dynamic>> clubResult =
      await firestoreService.request<Map<String, dynamic>>(
        collectionPath: 'clubs',
        method: FirestoreMethod.get,
        responseParser: (final data) => data as Map<String, dynamic>,
        docId: clubId,
      );

      return clubResult.fold(Left.new, (
          final Map<String, dynamic> clubData,
          ) async {
        final ClubModel club = ClubModel.fromFirestore(data: clubData);

        if (club.isCreator(currentUserId)) {
          return const Left(
            Failure(message: 'Creator cannot leave their own club'),
          );
        }

        final List<String> updatedMembers = club.memberIds
            .where((final String id) => id != currentUserId)
            .toList();

        return firestoreService.request<Unit>(
          collectionPath: 'clubs',
          method: FirestoreMethod.set,
          responseParser: (_) => unit,
          docId: clubId,
          data: <String, dynamic>{'memberIds': updatedMembers},
          merge: true,
        );
      });
    });
  }
}