import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';

/// Firestore service similar to network service
class FirebaseFirestoreService {
  FirebaseFirestoreService({final FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Generic request method similar to HttpNetworkService
  Future<Either<Failure, T>> request<T>({
    required final String collectionPath,
    required final FirestoreMethod method,
    required final T Function(dynamic data) responseParser,
    final String? docId,
    final Map<String, dynamic>? data,
    final Map<String, dynamic>? query,
    final Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    @Deprecated('Use FirestoreMethod.merge instead')
    final bool merge = false, // Kept for backward compatibility
  }) async {
    try {
      switch (method) {
        case FirestoreMethod.add:
          final DocumentReference<Map<String, dynamic>> ref =
          await _firestore.collection(collectionPath).add(data!);
          return Right<Failure, T>(responseParser(ref.id));

        case FirestoreMethod.update:
          await _firestore.collection(collectionPath).doc(docId).update(data!);
          return Right<Failure, T>(responseParser(unit));

        case FirestoreMethod.delete:
          await _firestore.collection(collectionPath).doc(docId).delete();
          return Right<Failure, T>(responseParser(unit));

        case FirestoreMethod.get:
          final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection(collectionPath).doc(docId).get();
          if (doc.exists && doc.data() != null) {
            return Right<Failure, T>(responseParser(doc.data()));
          } else {
            return Left<Failure, T>(
              const Failure(message: 'Document not found'),
            );
          }

        case FirestoreMethod.set:
          await _firestore
              .collection(collectionPath)
              .doc(docId)
              .set(data!, SetOptions(merge: merge));
          return Right<Failure, T>(responseParser(unit));

        case FirestoreMethod.merge:
        // New merge method - always sets with merge: true
          await _firestore
              .collection(collectionPath)
              .doc(docId)
              .set(data!, SetOptions(merge: true));
          return Right<Failure, T>(responseParser(unit));

        case FirestoreMethod.getAll:
          final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection(collectionPath).get();
          final List<Map<String, dynamic>> docs = snapshot.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                doc.data(),
          )
              .toList();
          return Right<Failure, T>(responseParser(docs));

        case FirestoreMethod.exists:
          final DocumentSnapshot<Map<String, dynamic>> doc =
          await _firestore.collection(collectionPath).doc(docId).get();
          return Right<Failure, T>(responseParser(doc.exists));

        case FirestoreMethod.query:
          Query<Map<String, dynamic>> ref =
          _firestore.collection(collectionPath);

          // Apply queryBuilder if provided (preferred)
          if (queryBuilder != null) {
            ref = queryBuilder(ref);
          } else if (query != null) {
            // Fallback to simple query map
            for (final MapEntry<String, dynamic> entry in query.entries) {
              ref = ref.where(entry.key, isEqualTo: entry.value);
            }
          }

          final QuerySnapshot<Map<String, dynamic>> snapshot = await ref.get();

          final List<Map<String, dynamic>> docs = snapshot.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                doc.data(),
          )
              .toList();

          return Right<Failure, T>(responseParser(docs));

        case FirestoreMethod.listenToDocument:
        case FirestoreMethod.listenToCollection:
          return Left<Failure, T>(
            const Failure(
              message: 'Use stream methods for listening operations',
            ),
          );
      }
    } on FirebaseException catch (e) {
      return Left<Failure, T>(
        Failure(
          message: 'Firebase error: ${e.message} \n errorCode: ${e.code}',
        ),
      );
    } catch (e) {
      return Left<Failure, T>(Failure(message: 'Unexpected error: $e'));
    }
  }

  /// Listens to a single document in real-time
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

  /// Listens to all documents in a collection in real-time
  Stream<Either<Failure, List<Map<String, dynamic>>>> listenToCollection({
    required final String collectionPath,
    final Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
  }) async* {
    try {
      Query<Map<String, dynamic>> ref = _firestore.collection(collectionPath);

      // Apply queryBuilder if provided
      if (queryBuilder != null) {
        ref = queryBuilder(ref);
      }

      await for (final QuerySnapshot<Map<String, dynamic>> snapshot
      in ref.snapshots()) {
        final List<Map<String, dynamic>> docs = snapshot.docs
            .map(
              (final QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              doc.data(),
        )
            .toList();
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
}