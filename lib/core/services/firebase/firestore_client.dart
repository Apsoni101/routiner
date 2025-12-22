import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';

import 'package:routiner/core/services/network/failure.dart';

/// Use [FirestoreClient] for Firestore operations with additional configuration
class FirestoreClient extends FirebaseFirestoreService {
  FirestoreClient({
    super.firestore,
    this.enablePersistence = true,
    this.cacheSizeBytes = Settings.CACHE_SIZE_UNLIMITED,
  }) {
    _initializeSettings();
  }

  final bool enablePersistence;
  final int cacheSizeBytes;

  void _initializeSettings() {
    // Configure Firestore settings if needed
    // Note: Settings must be configured before any Firestore operations
  }

  @override
  Future<Either<Failure, T>> request<T>({
    required final String collectionPath,
    required final FirestoreMethod method,
    required final T Function(dynamic data) responseParser,
    final String? docId,
    final Map<String, dynamic>? data,
    final Map<String, dynamic>? query,
    final Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
    final bool merge = false,

  }) {
    return super.request(
      collectionPath: collectionPath,
      method: method,
      responseParser: responseParser,
      docId: docId,
      data: data,
      query: query,
      queryBuilder: queryBuilder,
      merge: merge
    );
  }
  @override
  Stream<Either<Failure, List<Map<String, dynamic>>>> listenToCollection({
    required final String collectionPath,
    final Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
    queryBuilder,
  }) {
    return super.listenToCollection(
      collectionPath: collectionPath,
      queryBuilder: queryBuilder,
    );
  }
}
