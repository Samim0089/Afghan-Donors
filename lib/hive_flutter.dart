import 'package:hive_flutter/hive_flutter.dart';

class LocalStorage {
  static const String _boxName = 'localStorage';
  static const String _userPhoneKey = 'user_phone';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<void> saveUserPhone(String phone) async {
    var box = Hive.box(_boxName);
    await box.put(_userPhoneKey, phone);
  }

  static String? getUserPhone() {
    var box = Hive.box(_boxName);
    return box.get(_userPhoneKey);
  }

  // Delete user phone
  static Future<void> deleteUserPhone() async {
    var box = Hive.box(_boxName);
    await box.delete(_userPhoneKey);
  }
}
