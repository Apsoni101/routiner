import 'package:routiner/feature/auth/domain/entities/user_entity.dart';

abstract class HomeLocalRepo {
  String? getMood();

  Future<void> clearMood();

  UserEntity? getSavedUserCredentials();
}
