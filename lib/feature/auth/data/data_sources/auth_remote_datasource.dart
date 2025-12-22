import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

/// Abstract auth data source calling firebaseAuth service
abstract class AuthRemoteDataSource {
  /// Used for sign up with email, password, and additional user data
  Future<Either<Failure, UserModel>> signUpWithEmailAndData(
    final String email,
    final String password,
    final String name,
    final String surname,
    final String birthdate,
  );

  /// Used for sign in with email and password
  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  );

  /// Used for signing out User
  Future<Either<Failure, Unit>> signOut();

  /// Used for sign in with Google
  Future<Either<Failure, UserModel>> signInWithGoogle();

  /// Used for checking sign in
  bool isSignedIn();
}

/// Auth data source implementation for calling firebaseAuth service
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Creates an instance of auth datasource impl
  AuthRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  /// Calls auth service
  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailAndData(
    final String email,
    final String password,
    final String name,
    final String surname,
    final String birthdate,
  ) async {
    final Either<Failure, User> authResult = await authService.signUpWithEmail(
      email,
      password,
    );

    return authResult.fold(Left.new, (final User user) async {
      final UserModel userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        surname: surname,
        birthdate: birthdate,
      );

      final Either<Failure, Unit> saveResult = await firestoreService
          .request<Unit>(
            collectionPath: 'users',
            method: FirestoreMethod.set,
            responseParser: (final _) => unit,
            docId: user.uid,
            data: userModel.toJson(),
          );

      return saveResult.fold(
        Left<Failure, UserModel>.new,
        (final Unit _) => Right<Failure, UserModel>(userModel),
      );
    });
  }

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
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'users',
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
            docId: user.uid,
          );

      return userData.fold(
        (final Failure failure) {
          try {
            final UserModel fallbackUser = UserModel.fromFirebaseUser(user);
            return Right<Failure, UserModel>(fallbackUser);
          } catch (e) {
            return Left<Failure, UserModel>(
              Failure(message: 'Failed to parse Firebase user: $e'),
            );
          }
        },
        (final Map<String, dynamic> data) {
          try {
            final UserModel userModel = UserModel.fromFirestore(data: data);
            return Right<Failure, UserModel>(userModel);
          } catch (e) {
            return Left<Failure, UserModel>(
              Failure(message: 'Failed to parse Firestore user: $e'),
            );
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
          await firestoreService.request<Map<String, dynamic>>(
            collectionPath: 'users',
            method: FirestoreMethod.get,
            responseParser: (final data) => data as Map<String, dynamic>,
            docId: user.uid,
          );

      return userData.fold(
        (final Failure failure) {
          try {
            final UserModel fallbackUser = UserModel.fromFirebaseUser(user);
            return Right<Failure, UserModel>(fallbackUser);
          } catch (e) {
            return Left<Failure, UserModel>(
              Failure(message: 'Failed to parse Firebase user: $e'),
            );
          }
        },
        (final Map<String, dynamic> data) {
          try {
            final UserModel userModel = UserModel.fromFirestore(data: data);
            return Right<Failure, UserModel>(userModel);
          } catch (e) {
            return Left<Failure, UserModel>(
              Failure(message: 'Failed to parse Firestore user: $e'),
            );
          }
        },
      );
    });
  }

  @override
  Future<Either<Failure, Unit>> signOut() => authService.signOut();

  @override
  bool isSignedIn() => authService.auth.currentUser != null;
}
