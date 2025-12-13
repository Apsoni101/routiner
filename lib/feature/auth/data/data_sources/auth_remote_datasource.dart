import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

/// abstract auth data source calling firebaseAuth service
abstract class AuthRemoteDataSource {
  ///used for signIn with email and password
  Future<Either<Failure, UserModel>> signUpWithEmail(
    final String email,
    final String password,
  );

  ///used for signIn with email and password
  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  );

  ///used for signingOut User
  Future<Either<Failure, Unit>> signOut();

  ///used for signIn with Google
  Future<Either<Failure, UserModel>> signInWithGoogle();

  ///used for checking signIn
  bool isSignedIn();
}

/// auth data source implementation for calling firebaseAuth service
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  ///creates an instance of auth datasource impl
  AuthRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  ///calls auth service
  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  @override
  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  ) async {
    final Either<Failure, User> result = await authService.signInWithEmail(
      email,
      password,
    );
    return result.fold(Left.new, (final User user) async {
      final Either<Failure, Map<String, dynamic>> userData =
          await firestoreService.getDocument(
            collectionPath: 'users',
            docId: user.uid,
          );

      return userData.fold(
        (final Failure failure) {
          try {
            final UserModel fallbackUser = UserModel.fromFirebaseUser(user);
            return Right(fallbackUser);
          } catch (e) {
            return Left(Failure(message: 'Failed to parse Firebase user: $e'));
          }
        },
        (final Map<String, dynamic> data) {
          try {
            final UserModel userModel = UserModel.fromFirestore(data: data);
            return Right(userModel);
          } catch (e) {
            return Left(Failure(message: 'Failed to parse Firestore user: $e'));
          }
        },
      );
    });
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    final Either<Failure, User> result = await authService.signInWithGoogle();
    return result.fold(Left.new, (final User user) async {
      final Either<Failure, Map<String, dynamic>> userData =
          await firestoreService.getDocument(
            collectionPath: 'users',
            docId: user.uid,
          );

      return userData.fold(
        (final Failure failure) {
          try {
            final UserModel fallbackUser = UserModel.fromFirebaseUser(user);
            return Right(fallbackUser);
          } catch (e) {
            return Left(Failure(message: 'Failed to parse Firebase user: $e'));
          }
        },
        (final Map<String, dynamic> data) {
          try {
            final UserModel userModel = UserModel.fromFirestore(data: data);
            return Right(userModel);
          } catch (e) {
            return Left(Failure(message: 'Failed to parse Firestore user: $e'));
          }
        },
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() => authService.signOut();

  @override
  Future<Either<Failure, UserModel>> signUpWithEmail(
    final String email,
    final String password,
  ) async {
    final Either<Failure, User> result = await authService.signUpWithEmail(
      email,
      password,
    );
    return result.fold(Left.new, (final User user) async {
      try {
        final UserModel userModel = UserModel.fromFirebaseUser(user);
        await firestoreService.setData(
          collectionPath: 'users',
          docId: user.uid,
          data: userModel.toJson(),
        );
        return Right<Failure, UserModel>(userModel);
      } catch (e) {
        return Left<Failure, UserModel>(
          Failure(message: "User mapping failed: $e"),
        );
      }
    });
  }

  @override
  bool isSignedIn() => authService.auth.currentUser != null;
}
