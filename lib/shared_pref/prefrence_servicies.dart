import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefrenceServicies {
  static const isLoginKey = "isLogin";
  static const isVisited = "isVisited";

  static SharedPreferences? preferences;

  static Future<void> onInit() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setData(String key, dynamic value) async {
    if (value is int) {
      await preferences!.setInt(key, value);
    } else if (value is bool) {
      await preferences!.setBool(key, value);
    } else if (value is double) {
      await preferences!.setDouble(key, value);
    } else if (value is String) {
      await preferences!.setString(key, value);
    } else if (value is List<String>) {
      await preferences!.setStringList(key, value);
    } else {
      if (kDebugMode) {
        print("THIS IS NOT VALID DATA FOR STORED IN MEMORY.");
      }
    }
  }

  static bool getBool(String key) {
    return preferences!.getBool(key) ?? false;
  }
}
