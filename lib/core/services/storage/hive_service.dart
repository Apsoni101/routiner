import 'package:hive/hive.dart';
import 'package:routiner/feature/auth/data/models/user_model.dart';
import 'package:routiner/feature/create_custom_habit/data/model/custom_habit_hive_model.dart';
import 'package:routiner/feature/home/data/model/habit_log_hive_model.dart';

class HiveService {
  late Box _box;

  /// Initialize Hive and open a box
  static void registerAdapters() {
    // Check if already registered to avoid errors on hot restart
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CustomHabitHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(HabitLogHiveModelAdapter());
    }
    print('[HiveService] Adapters registered');
  }

  Future<void> init({required final String boxName}) async {
    // Close box if already open (handles hot restart)
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
      print('[HiveService] Closed existing box "$boxName"');
    }

    _box = await Hive.openBox(boxName);
    print('[HiveService] Box "$boxName" opened');
  }

  // String
  Future<void> setString(final String key, final String value) async {
    await _box.put(key, value);
    print('[HiveService] setString -> Key: $key, Value: $value');
  }

  String? getString(final String key) {
    final value = _box.get(key) as String?;
    print('[HiveService] getString -> Key: $key, Value: $value');
    return value;
  }

  // Bool
  Future<void> setBool({
    required final String key,
    required final bool value,
  }) async {
    await _box.put(key, value);
    print('[HiveService] setBool -> Key: $key, Value: $value');
  }

  bool? getBool(final String key) {
    final value = _box.get(key) as bool?;
    print('[HiveService] getBool -> Key: $key, Value: $value');
    return value;
  }

  // Int
  Future<void> setInt(final String key, final int value) async {
    await _box.put(key, value);
    print('[HiveService] setInt -> Key: $key, Value: $value');
  }

  int? getInt(final String key) {
    final value = _box.get(key) as int?;
    print('[HiveService] getInt -> Key: $key, Value: $value');
    return value;
  }

  // Double
  Future<void> setDouble(final String key, final double value) async {
    await _box.put(key, value);
    print('[HiveService] setDouble -> Key: $key, Value: $value');
  }

  double? getDouble(final String key) {
    final value = _box.get(key) as double?;
    print('[HiveService] getDouble -> Key: $key, Value: $value');
    return value;
  }

  // List<String>
  Future<void> setStringList(final String key, final List<String> value) async {
    await _box.put(key, value);
    print('[HiveService] setStringList -> Key: $key, Value: $value');
  }

  List<String>? getStringList(final String key) {
    final value = (_box.get(key) as List<dynamic>?)?.cast<String>();
    print('[HiveService] getStringList -> Key: $key, Value: $value');
    return value;
  }

  // Remove key
  Future<void> remove(final String key) async {
    await _box.delete(key);
    print('[HiveService] remove -> Key: $key');
  }

  // Save object
  Future<void> setObject<T>(final String key, final T object) async {
    await _box.put(key, object);
    print('[HiveService] setObject -> Key: $key, Object: $object');
  }

  // Get object
  T? getObject<T>(final String key) {
    final object = _box.get(key) as T?;
    print('[HiveService] getObject -> Key: $key, Object: $object');
    return object;
  }

  // Save list of objects
  Future<void> setObjectList<T>(final String key, final List<T> objects) async {
    await _box.put(key, objects);
    print('[HiveService] setObjectList -> Key: $key, Objects: $objects');
  }

  // Get list of objects
  List<T>? getObjectList<T>(final String key) {
    final objects = (_box.get(key) as List<dynamic>?)?.cast<T>();
    print('[HiveService] getObjectList -> Key: $key, Objects: $objects');
    return objects;
  }
// Delete object by key
  Future<void> deleteObject(String key) async {
    await _box.delete(key);
    print('[HiveService] deleteObject -> Key: $key');
  }

  // Clear box
  Future<void> clear() async {
    await _box.clear();
    print('[HiveService] clear -> All data cleared');
  }

  // Check key exists
  bool containsKey(final String key) {
    final exists = _box.containsKey(key);
    print('[HiveService] containsKey -> Key: $key, Exists: $exists');
    return exists;
  }
}
