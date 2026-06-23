import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  final ValueNotifier<String?> studentProfileImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> adminProfileImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String?> teacherProfileImagePath = ValueNotifier<String?>(null);
  final ValueNotifier<String> adminName = ValueNotifier<String>('Admin User');
  final ValueNotifier<String> teacherName = ValueNotifier<String>('Teacher Name');
  final ValueNotifier<String> selectedSchool = ValueNotifier<String>('Ecstasy School 1');
  final ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    studentProfileImagePath.value = prefs.getString('student_profile_image');
    adminProfileImagePath.value = prefs.getString('admin_profile_image');
    teacherProfileImagePath.value = prefs.getString('teacher_profile_image');
    adminName.value = prefs.getString('admin_name') ?? 'Admin User';
    teacherName.value = prefs.getString('teacher_name') ?? 'Teacher Name';
    
    final themeString = prefs.getString('theme_mode');
    if (themeString == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (themeString == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    String modeString = 'system';
    if (mode == ThemeMode.light) modeString = 'light';
    if (mode == ThemeMode.dark) modeString = 'dark';
    await prefs.setString('theme_mode', modeString);
    themeMode.value = mode;
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

  Future<void> setTeacherProfileImage(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove('teacher_profile_image');
    } else {
      await prefs.setString('teacher_profile_image', path);
    }
    teacherProfileImagePath.value = path;
  }

  Future<void> setAdminName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('admin_name', name);
    adminName.value = name;
  }

  Future<void> setTeacherName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('teacher_name', name);
    teacherName.value = name;
  }
}
