import 'package:routiner/feature/add_habit/domain/repo/mood_repository.dart';

class MoodUsecase {
  MoodUsecase(this._repository);

  final MoodRepository _repository;

  Future<void> saveMood(final String mood) {
    return _repository.saveMood(mood);
  }

  String? getMood() {
    return _repository.getMood();
  }

  Future<void> clearMood() {
    return _repository.clearMood();
  }
}
