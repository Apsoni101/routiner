
abstract class MoodRepository {
  Future<void> saveMood(final String mood);
  String? getMood();
  Future<void> clearMood();
}
