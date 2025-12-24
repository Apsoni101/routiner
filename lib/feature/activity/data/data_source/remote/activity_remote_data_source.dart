import 'package:dartz/dartz.dart';
import 'package:routiner/core/services/firebase/firebase_auth_service.dart';
import 'package:routiner/core/services/firebase/firebase_firestore_service.dart';
import 'package:routiner/core/services/firebase/firestore_method.dart';
import 'package:routiner/core/services/network/failure.dart';
import 'package:routiner/feature/add_habit/data/model/mood_log_model.dart';

/// Abstract activity remote data source
abstract class ActivityRemoteDataSource {
  /// Get all logs for a date range across all habits
  Future<Either<Failure, List<Map<String, dynamic>>>> getLogsForDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });

  /// Get mood logs for a date range
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  });
}

/// Implementation using Firestore
class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  ActivityRemoteDataSourceImpl({
    required this.authService,
    required this.firestoreService,
  });

  final FirebaseAuthService authService;
  final FirebaseFirestoreService firestoreService;

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getLogsForDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final Either<Failure, String> userIdResult =
    await authService.getCurrentUserId();

    return userIdResult.fold(Left.new, (final String userId) async {
      // Get all habit IDs first
      final Either<Failure, List<Map<String, dynamic>>> habitsResult =
      await firestoreService.request<List<Map<String, dynamic>>>(
        collectionPath: 'users/$userId/custom_habits',
        method: FirestoreMethod.getAll,
        responseParser: (final data) => data as List<Map<String, dynamic>>,
      );

      return await habitsResult.fold(Left.new, (
          final List<Map<String, dynamic>> habits,
          ) async {
        if (habits.isEmpty) {
          return const Right(<Map<String, dynamic>>[]);
        }

        final List<Map<String, dynamic>> allLogs = <Map<String, dynamic>>[];

        // Fetch logs for each habit
        for (final Map<String, dynamic> habit in habits) {
          final String? habitId = habit['id']?.toString();
          if (habitId == null || habitId.isEmpty) {
            continue;
          }

          final Either<Failure, List<Map<String, dynamic>>> logsResult =
          await firestoreService.request<List<Map<String, dynamic>>>(
            collectionPath: 'users/$userId/custom_habits/$habitId/logs',
            method: FirestoreMethod.getAll,
            responseParser: (final data) => data as List<Map<String, dynamic>>,
          );

          await logsResult.fold(
                (final Failure _) async {
              // Skip this habit if we can't fetch logs
            },
                (final List<Map<String, dynamic>> logs) async {
              // Filter logs within date range
              final List<Map<String, dynamic>> filteredLogs = logs.where((
                  final Map<String, dynamic> log,
                  ) {
                final String? dateStr = log['date']?.toString();
                if (dateStr == null || dateStr.isEmpty) {
                  return false;
                }

                try {
                  final DateTime logDate = DateTime.parse(dateStr);
                  return logDate.isAfter(
                    startDate.subtract(const Duration(days: 1)),
                  ) &&
                      logDate.isBefore(endDate.add(const Duration(days: 1)));
                } catch (e) {
                  return false;
                }
              }).toList();

              allLogs.addAll(filteredLogs);
            },
          );
        }

        return Right(allLogs);
      });
    });
  }

  @override
  Future<Either<Failure, List<MoodLogModel>>> getMoodLogsByDateRange({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    final Either<Failure, String> userIdResult =
    await authService.getCurrentUserId();

    return userIdResult.fold(
      Left.new,
          (final String userId) async {
        final Either<Failure, List<Map<String, dynamic>>> result =
        await firestoreService.request<List<Map<String, dynamic>>>(
          collectionPath: 'users/$userId/mood_logs',
          method: FirestoreMethod.getAll,
          responseParser: (final data) => data as List<Map<String, dynamic>>,
        );

        return result.fold(
          Left.new,
              (final List<Map<String, dynamic>> data) {
            final List<MoodLogModel> moodLogs = data
                .map(MoodLogModel.fromJson)
                .where((log) =>
            log.timestamp.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
                log.timestamp
                    .isBefore(endDate.add(const Duration(days: 1))))
                .toList();
            return Right(moodLogs);
          },
        );
      },
    );
  }
}