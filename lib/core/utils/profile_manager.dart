import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  final ValueNotifier<String?> studentProfileImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> adminProfileImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String> selectedSchool = ValueNotifier<String>('Ecstasy School 1');

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    studentProfileImagePath.value = prefs.getString('student_profile_image');
    adminProfileImagePath.value = prefs.getString('admin_profile_image');
  }

  Future<void> setStudentProfileImage(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove('student_profile_image');
    } else {
      await prefs.setString('student_profile_image', path);
    }
    studentProfileImagePath.value = path;
  }

  Future<void> setAdminProfileImage(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove('admin_profile_image');
    } else {
      await prefs.setString('admin_profile_image', path);
    }
    adminProfileImagePath.value = path;
  }
}
