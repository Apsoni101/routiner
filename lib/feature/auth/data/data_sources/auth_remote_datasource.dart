import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, UserModel>> signUpWithEmailAndData(
    final String email,
    final String password,
    final String name,
    final String surname,
    final String birthdate,
  );

  Future<Either<Failure, UserModel>> signInWithEmail(
    final String email,
    final String password,
  );

  Future<Either<Failure, Unit>> signOut();

  Future<Either<Failure, UserModel>> signInWithGoogle();

  bool isSignedIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

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
        isNewUser: true,
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

    return result.fold(
      (final Failure failure) async {
        return Left<Failure, UserModel>(failure);
      },
      (final User user) async {
        final Either<Failure, Map<String, dynamic>> userData =
            await firestoreService.request<Map<String, dynamic>>(
              collectionPath: 'users',
              method: FirestoreMethod.get,
              responseParser: (final data) => data as Map<String, dynamic>,
              docId: user.uid,
            );

        if (userData.isRight()) {
          final Map<String, dynamic>? data = userData.fold(
            (final Failure l) => null,
            (final Map<String, dynamic> r) => r,
          );
          if (data != null) {
            final UserModel userModel = UserModel.fromFirestore(
              data: data,
            ).copyWith(isNewUser: false);
            return Right<Failure, UserModel>(userModel);
          }
        }

        final UserModel newUser = UserModel.fromFirebaseUser(
          user,
        ).copyWith(isNewUser: true);

        final Either<Failure, Unit> saveResult = await firestoreService
            .request<Unit>(
              collectionPath: 'users',
              method: FirestoreMethod.set,
              docId: user.uid,
              responseParser: (final _) => unit,
              data: newUser.toJson(),
            );

        return saveResult.fold(
          (final Failure saveFailure) {
            return Left<Failure, UserModel>(saveFailure);
          },
          (final Unit _) {
            return Right<Failure, UserModel>(newUser);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> signOut() => authService.signOut();

  @override
  bool isSignedIn() => authService.auth.currentUser != null;
}
