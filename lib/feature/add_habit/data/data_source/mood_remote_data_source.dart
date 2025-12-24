// lib/feature/add_habit/data/data_source/mood_remote_data_source.dart

import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_model.dart';

/// Abstract mood remote data source
abstract class MoodRemoteDataSource {
  /// Save mood log to Firestore
  Future<Either<Failure, String>> saveMoodLog({
    required final MoodLogModel moodLog,
  });

  /// Get all mood logs for a user
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogs();

  /// Get mood logs for a specific date range
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });

  /// Delete a mood log
  Future<Either<Failure, Unit>> deleteMoodLog({
    required final String logId,
  });

  /// Get the most recent mood
  Future<Either<Failure, MoodLogModel?>> getLatestMood();
}

/// Implementation of mood remote data source using Firestore
class MoodRemoteDataSourceImpl implements MoodRemoteDataSource {
  MoodRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  /// Get collection path for current user
  Future<Either<Failure, String>> _getCollectionPath() async {
    final Either<Failure, String> userIdResult =
    await authService.getCurrentUserId();
    return userIdResult.fold(
      Left<Failure, String>.new,
          (final String userId) =>
          Right<Failure, String>('users/$userId/mood_logs'),
    );
  }

  @override
  Future<Either<Failure, String>> saveMoodLog({
    required final MoodLogModel moodLog,
  }) async {
    final Either<Failure, String> collectionPathResult =
    await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, String>.new,
          (final String collectionPath) async {
        if (moodLog.id != null && moodLog.id!.isNotEmpty) {
          // Update existing mood log
          final Either<Failure, Unit> result =
          await firestoreService.request<Unit>(
            collectionPath: collectionPath,
            method: FirestoreMethod.set,
            responseParser: (final dynamic _) => unit,
            docId: moodLog.id,
            data: moodLog.toJson(),
          );

          return result.fold(
            Left<Failure, String>.new,
                (final Unit _) => Right<Failure, String>(moodLog.id!),
          );
        } else {
          // Add new mood log
          return firestoreService.request<String>(
            collectionPath: collectionPath,
            method: FirestoreMethod.add,
            responseParser: (final dynamic id) => id as String,
            data: moodLog.toJson(),
          );
        }
      },
    );
  }

  @override
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogs() async {
    final Either<Failure, String> collectionPathResult =
    await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, List<MoodLogModel>>.new,
          (final String collectionPath) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: collectionPath,
          method: FirestoreMethod.getAll,
          responseParser: (final dynamic data) =>
          data as List<Map<String, dynamic>>,
        );

        return result.fold(
          Left<Failure, List<MoodLogModel>>.new,
              (final List<Map<String, dynamic>> data) {
            final List<MoodLogModel> moodLogs = data
                .map(MoodLogModel.fromJson)
                .toList();
            return Right<Failure, List<MoodLogModel>>(moodLogs);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final Either<Failure, String> collectionPathResult =
    await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, List<MoodLogModel>>.new,
          (final String collectionPath) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: collectionPath,
          method: FirestoreMethod.getAll,
          responseParser: (final dynamic data) =>
          data as List<Map<String, dynamic>>,
        );

        return result.fold(
          Left<Failure, List<MoodLogModel>>.new,
              (final List<Map<String, dynamic>> data) {
            final List<MoodLogModel> moodLogs = data
                .map(MoodLogModel.fromJson)
                .where((final MoodLogModel log) =>
            log.timestamp.isAfter(startDate) &&
                log.timestamp.isBefore(endDate))
                .toList();
            return Right<Failure, List<MoodLogModel>>(moodLogs);
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, Unit>> deleteMoodLog({
    required final String logId,
  }) async {
    final Either<Failure, String> collectionPathResult =
    await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, Unit>.new,
          (final String collectionPath) async {
        return firestoreService.request<Unit>(
          collectionPath: collectionPath,
          method: FirestoreMethod.delete,
          responseParser: (final dynamic _) => unit,
          docId: logId,
        );
      },
    );
  }

  @override
  Future<Either<Failure, MoodLogModel?>> getLatestMood() async {
    final Either<Failure, String> collectionPathResult =
    await _getCollectionPath();

    return collectionPathResult.fold(
      Left<Failure, MoodLogModel?>.new,
          (final String collectionPath) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: collectionPath,
          method: FirestoreMethod.getAll,
          responseParser: (final dynamic data) =>
          data as List<Map<String, dynamic>>,
        );

        return result.fold(
          Left<Failure, MoodLogModel?>.new,
              (final List<Map<String, dynamic>> data) {
            if (data.isEmpty) {
              return const Right<Failure, MoodLogModel?>(null);
            }

            final List<MoodLogModel> moodLogs = data
                .map(MoodLogModel.fromJson)
                .toList()
              ..sort((final MoodLogModel a, final MoodLogModel b) =>
                  b.timestamp.compareTo(a.timestamp));

            return Right<Failure, MoodLogModel?>(moodLogs.first);
          },
        );
      },
    );
  }
}