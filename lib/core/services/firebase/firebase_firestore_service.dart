import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/network/failure.dart';

/// Firestore service similar to network  service
class FirebaseFirestoreService {
  FirebaseFirestoreService({final FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Adds a document to a collection
  Future<Either<Failure, String>> addDocument({
    required final String collectionPath,
    required final Map<String, dynamic> data,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> ref = await _firestore
          .collection(collectionPath)
          .add(data);
      return Right<Failure, String>(ref.id);
    } on FirebaseException catch (e) {
      return Left<Failure, String>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } catch (e) {
      return Left<Failure, String>(Failure(message: 'Unexpected error: $e'));
    }
  }

  /// Updates a document by ID
  Future<Either<Failure, Unit>> updateDocument({
    required final String collectionPath,
    required final String docId,
    required final Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      return const Right<Failure, Unit>(unit);
    } on FirebaseException catch (e) {
      return Left<Failure, Unit>(
        Failure(
          message: 'Firebase error: ${e.message} \n  errorCode: ${e.code}',
        ),
      );
    } catch (e) {
      return Left<Failure, Unit>(Failure(message: 'Unexpected error: $e'));
    }
  }

  /// Deletes a document
  Future<Either<Failure, Unit>> deleteDocument({
    required final String collectionPath,
    required final String docId,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      return const Right<Failure, Unit>(unit);
    } on FirebaseException catch (e) {
      return Left<Failure, Unit>(
        Failure(
          message: 'Firebase error: ${e.message} \n  errorCode: ${e.code}',
        ),
      );
    } catch (e) {
      return Left<Failure, Unit>(Failure(message: 'Unexpected error: $e'));
    }
  }

  /// Gets a document once
  Future<Either<Failure, Map<String, dynamic>>> getDocument({
    required final String collectionPath,
    required final String docId,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection(collectionPath)
          .doc(docId)
          .get();
      if (doc.exists && doc.data() != null) {
        return Right<Failure, Map<String, dynamic>>(doc.data()!);
      } else {
        return const Left<Failure, Map<String, dynamic>>(
          Failure(message: 'Document not found'),
        );
      }
    } on FirebaseException catch (e) {
      return Left<Failure, Map<String, dynamic>>(
        Failure(
          message: 'Firebase error: ${e.message} \n  errorCode: ${e.code} ',
        ),
      );
    } catch (e) {
      return Left<Failure, Map<String, dynamic>>(
        Failure(message: 'Unexpected error: $e'),
      );
    }
  }

  /// Listens to all documents in a collection in real-time
  Stream<Either<Failure, List<Map<String, dynamic>>>> listenToAllDocuments({
    required final String collectionPath,
  }) async* {
    try {
      await for (final QuerySnapshot<Map<String, dynamic>> snapshot
          in _firestore.collection(collectionPath).snapshots()) {
        final List<Map<String, dynamic>> docs = snapshot.docs.map((
          final QueryDocumentSnapshot<Map<String, dynamic>> doc,
        ) {
          final Map<String, dynamic> data = doc.data();
          return data;
        }).toList();

        yield Right<Failure, List<Map<String, dynamic>>>(docs);
      }
    } on FirebaseException catch (e) {
      yield Left<Failure, List<Map<String, dynamic>>>(
        Failure(message: 'Firestore error: ${e.message}'),
      );
    } catch (e) {
      yield Left<Failure, List<Map<String, dynamic>>>(
        Failure(message: 'Unexpected error: $e'),
      );
    }
  }

  /// Listens to a single document in real-time for updating reviews in realtime
  Stream<Either<Failure, Map<String, dynamic>>> listenToDocument({
    required final String collectionPath,
    required final String docId,
  }) async* {
    try {
      await for (final DocumentSnapshot<Map<String, dynamic>> docSnapshot
          in _firestore.collection(collectionPath).doc(docId).snapshots()) {
        if (docSnapshot.exists) {
          final Map<String, dynamic>? data = docSnapshot.data();
          if (data != null) {
            yield Right<Failure, Map<String, dynamic>>(data);
          } else {
            yield const Left<Failure, Map<String, dynamic>>(
              Failure(message: 'Document data is null'),
            );
          }
        } else {
          yield const Left<Failure, Map<String, dynamic>>(
            Failure(message: 'Document does not exist'),
          );
        }
      }
    } on FirebaseException catch (e) {
      yield Left<Failure, Map<String, dynamic>>(
        Failure(message: 'Firestore error: ${e.message}'),
      );
    } catch (e) {
      yield Left<Failure, Map<String, dynamic>>(
        Failure(message: 'Unexpected error: $e'),
      );
    }
  }

  /// sets my data  to a document
  Future<Either<Failure, Unit>> setData({
    required final String collectionPath,
    required final String docId,
    required final Map<String, dynamic> data,
  }) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).set(data);
      return const Right<Failure, Unit>(unit);
    } on FirebaseException catch (e) {
      return Left<Failure, Unit>(
        Failure(message: 'Failed to set data: ${e.message}'),
      );
    } catch (e) {
      return Left<Failure, Unit>(Failure(message: 'Unexpected error: $e'));
    }
  }

  /// checks my document existence
  Future<Either<Failure, bool>> documentExists({
    required final String collectionPath,
    required final String docId,
  }) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection(collectionPath)
          .doc(docId)
          .get();
      return Right<Failure, bool>(doc.exists);
    } catch (e) {
      return Left<Failure, bool>(
        Failure(message: 'Failed to check document existence: $e'),
      );
    }
  }
}
