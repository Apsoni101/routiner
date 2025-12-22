import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

/// Abstract friend data source for remote operations
abstract class FriendRemoteDataSource {
  /// Search users by query
  Future<Either<Failure, List<UserModel>>> searchUsers(final String query);

  /// Add friend relationship (stores only friend ID)
  Future<Either<Failure, Unit>> addFriend(final String friendId);

  /// Remove friend relationship
  Future<Either<Failure, Unit>> removeFriend(final String friendId);

  /// Get list of friend IDs
  Future<Either<Failure, List<String>>> getFriendIds();

  /// Get user by ID
  Future<Either<Failure, UserModel>> getUserById(final String userId);
}

/// Implementation of friend remote data source
class FriendRemoteDataSourceImpl implements FriendRemoteDataSource {
  /// Creates an instance of FriendRemoteDataSourceImpl
  FriendRemoteDataSourceImpl({
    required this.firestoreService,
    required this.authService,
  });

  final FirebaseFirestoreService firestoreService;
  final FirebaseAuthService authService;

  @override
  Future<Either<Failure, List<UserModel>>> searchUsers(
    final String query,
  ) async {
    final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: 'users',
          method: FirestoreMethod.query,
          responseParser: (final data) => (data as List<dynamic>)
              .map((final e) => e as Map<String, dynamic>)
              .toList(),
          queryBuilder: (final Query<Map<String, dynamic>> queryRef) => queryRef
              .where('name', isGreaterThanOrEqualTo: query)
              .where('name', isLessThan: '${query}z')
              .orderBy('name')
              .limit(20),
        );

    return result.fold(
      Left.new,
      (final List<Map<String, dynamic>> data) => Right(
        data
            .map(
              (final Map<String, dynamic> json) =>
                  UserModel.fromFirestore(data: json),
            )
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> addFriend(final String friendId) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();

    return currentUserIdResult.fold(Left.new, (
      final String currentUserId,
    ) async {
      if (currentUserId.isEmpty) {
        return const Left(Failure(message: 'Current user ID is empty'));
      }

      final Either<Failure, Unit> addToCurrentUser = await firestoreService
          .request<Unit>(
            collectionPath: 'users/$currentUserId/friends',
            method: FirestoreMethod.set,
            responseParser: (_) => unit,
            docId: friendId,
            data: <String, dynamic>{'uid': friendId, 'addedAt': DateTime.now()},
          );

      return await addToCurrentUser.fold(Left.new, (_) async {
        final Either<Failure, Unit> addToFriend = await firestoreService
            .request<Unit>(
              collectionPath: 'users/$friendId/friends',
              method: FirestoreMethod.set,
              responseParser: (_) => unit,
              docId: currentUserId,
              data: <String, dynamic>{
                'uid': currentUserId,
                'addedAt': DateTime.now(),
              },
            );

        return addToFriend;
      });
    });
  }

  @override
  Future<Either<Failure, Unit>> removeFriend(final String friendId) async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();
    return currentUserIdResult.fold(Left.new, (final String currentUserId) {
      if (currentUserId.isEmpty) {
        return const Left(Failure(message: 'Current user ID is empty'));
      }
      return firestoreService.request<Unit>(
        collectionPath: 'users/$currentUserId/friends',
        method: FirestoreMethod.delete,
        responseParser: (_) => unit,
        docId: friendId,
      );
    });
  }

  @override
  Future<Either<Failure, List<String>>> getFriendIds() async {
    final Either<Failure, String> currentUserIdResult = await authService
        .getCurrentUserId();
    return currentUserIdResult.fold(
      (final Failure failure) {
        return Left(failure);
      },
      (final String currentUserId) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
            await firestoreService.request<List<Map<String, dynamic>>>(
              collectionPath: 'users/$currentUserId/friends',
              method: FirestoreMethod.query,
              responseParser: (final data) => (data as List<dynamic>)
                  .map((final e) => e as Map<String, dynamic>)
                  .toList(),
              queryBuilder: (final Query<Map<String, dynamic>> query) =>
                  query.orderBy('addedAt', descending: true),
            );

        return result.fold(
          (final Failure failure) {
            return Left(failure);
          },
          (final List<Map<String, dynamic>> data) {
            final List<String> ids = data
                .map((final Map<String, dynamic> json) => json['uid'] as String)
                .toList();

            return Right(ids);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(final String userId) async {
    final Either<Failure, Map<String, dynamic>> result = await firestoreService
        .request<Map<String, dynamic>>(
          collectionPath: 'users',
          method: FirestoreMethod.get,
          responseParser: (final data) => data as Map<String, dynamic>,
          docId: userId,
        );

    return result.fold(
      Left.new,
      (final Map<String, dynamic> data) =>
          Right(UserModel.fromFirestore(data: data)),
    );
  }
}
