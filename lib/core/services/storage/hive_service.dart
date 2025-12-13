import 'package:hive/hive.dart';

class HiveService {
  late Box _box;

  /// Initialize Hive and open a box
  Future<void> init({required final String boxName}) async {
    _box = await Hive.openBox(boxName);
  }

  // String
  Future<void> setString(final String key, final String value) async =>
      _box.put(key, value);

  String? getString(final String key) => _box.get(key) as String?;

  // Bool
  Future<void> setBool({
    required final String key,
    required final bool value,
  }) async => _box.put(key, value);

  bool? getBool(final String key) => _box.get(key) as bool?;

  // Int
  Future<void> setInt(final String key, final int value) async =>
      _box.put(key, value);

  int? getInt(final String key) => _box.get(key) as int?;

  // Double
  Future<void> setDouble(final String key, final double value) async =>
      _box.put(key, value);

  double? getDouble(final String key) => _box.get(key) as double?;

  // List<String>
  Future<void> setStringList(
    final String key,
    final List<String> value,
  ) async => _box.put(key, value);

  List<String>? getStringList(final String key) =>
      (_box.get(key) as List<dynamic>?)?.cast<String>();

  // Remove key
  Future<void> remove(final String key) async => _box.delete(key);

  // Save object
  Future<void> setObject<T>(final String key, final T object) async {
    await _box.put(key, object);
  }

  // Get object
  T? getObject<T>(final String key) => _box.get(key) as T?;

  // Save list of objects
  Future<void> setObjectList<T>(final String key, final List<T> objects) async {
    await _box.put(key, objects);
  }

  // Get list of objects
  List<T>? getObjectList<T>(final String key) =>
      (_box.get(key) as List<dynamic>?)?.cast<T>();

  // Clear box
  Future<void> clear() async => _box.clear();

  // Check key exists
  bool containsKey(final String key) => _box.containsKey(key);
}
