import 'package:routiner/feature/add_habit/domain/repo/mood_local_repository.dart';
import 'package:routiner/feature/auth/domain/entities/user_entity.dart';
import 'package:routiner/feature/home/domain/repo/home_local_repo.dart';

class HomeLocalUsecase {
  HomeLocalUsecase(this._repository);

  final HomeLocalRepo _repository;

  String? getMood() {
    return _repository.getMood();
  }

  UserEntity? getSavedUserCredentials() {
    return _repository.getSavedUserCredentials();
  }

  Future<void> clearMood() {
    return _repository.clearMood();
  }
}
