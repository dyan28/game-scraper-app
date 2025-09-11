import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();


  // static Future<void> saveAppUser(AppUser? appUser) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final value = appUser?.toJson();
  //   if (value != null) {
  //     await prefs.setString(_keyAppUser, value);
  //   }
   
  // }

  /// Get - Save User Detail
  // static Future<AppUser?> getUserDetail() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final value = prefs.getString(_keyAppUser);

  //   if (value == null || value.isEmpty) {
  //     return null;
  //   }

  //   return AppUser.fromJson(value);
  // }
  /// clear User Detail
  

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

 

  

   
}
