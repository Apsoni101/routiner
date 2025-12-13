import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routiner/core/services/network/failure.dart';

///firebase service similar to network service
class FirebaseAuthService {
  FirebaseAuthService({final FirebaseAuth? auth})
    : auth = auth ?? FirebaseAuth.instance;

  ///firebase auth instance
  final FirebaseAuth auth;

  ///used for signIn with email and password
  Future<Either<Failure, User>> signUpWithEmail(
    final String email,
    final String password,
  ) async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right<Failure, User>(result.user!);
    } on FirebaseAuthException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on FirebaseException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, User>(Failure(message: 'Unexpected error: $e'));
    }
  }

  ///used for signIn with email and password
  Future<Either<Failure, User>> signInWithEmail(
    final String email,
    final String password,
  ) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right<Failure, User>(result.user!);
    } on FirebaseAuthException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on FirebaseException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, User>(Failure(message: 'Unexpected error: $e'));
    }
  }

  ///used for signingOut User
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await auth.signOut();
      return const Right<Failure, Unit>(unit);
    } on FirebaseAuthException catch (e) {
      return Left<Failure, Unit>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on FirebaseException catch (e) {
      return Left<Failure, Unit>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, Unit>(Failure(message: 'Unexpected error: $e'));
    }
  }

  ///used for signIn with Google
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential result = await auth.signInWithCredential(credential);
      return Right<Failure, User>(result.user!);
    } on FirebaseAuthException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on FirebaseException catch (e) {
      return Left<Failure, User>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, User>(Failure(message: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      return Right<Failure, bool>(auth.currentUser != null);
    } on FirebaseAuthException catch (e) {
      return Left<Failure, bool>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on FirebaseException catch (e) {
      return Left<Failure, bool>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } on Exception catch (e) {
      return Left<Failure, bool>(Failure(message: 'Unexpected error: $e'));
    }
  }
}
