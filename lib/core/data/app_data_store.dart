import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Central in-memory data store — single source of truth for the entire app.
/// All screens read/write through this singleton so data stays consistent.
class AppDataStore {
  AppDataStore._();
  static final AppDataStore instance = AppDataStore._();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? feeData = prefs.getString('feeStructureItems');
    if (feeData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(feeData);
        feeStructureItems.clear();
        for (var item in decoded) {
          feeStructureItems.add(Map<String, dynamic>.from(item));
        }
      } catch (e) {
        debugPrint("Error loading fee structure: $e");
      }
    }
    final String? feeTypesData = prefs.getString('feeTypes');
    if (feeTypesData != null) {
      try {
        final List<dynamic> decoded = jsonDecode(feeTypesData);
        feeTypes.clear();
        for (var item in decoded) {
          feeTypes.add(Map<String, dynamic>.from(item));
        }
      } catch (e) {
        debugPrint("Error loading fee types: $e");
      }
    }
  }

  Future<void> _saveFeeTypes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('feeTypes', jsonEncode(feeTypes));
  }

  Future<void> _saveFeeStructure() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('feeStructureItems', jsonEncode(feeStructureItems));
  }

  // ─── Students ────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> students = [
    // --- Ecstasy School 1 ---
    {
      'name': 'Aarav Sharma',
      'father': 'Mr. Sharma',
      'class': 'Class 10',
      'roll': 'Roll No: 01',
      'admission': 'ECS00001',
      'password': 'ECS00001',
      'status': 'Active',
      'avatar': 'AS',
      'phone': '9876543210',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
      'hasIdCard': true,
    },
    {
      'name': 'Priya Patel',
      'father': 'Mr. Patel',
      'class': 'Class 10',
      'roll': 'Roll No: 15',
      'admission': 'ECS00002',
      'password': 'ECS00002',
      'status': 'Active',
      'avatar': 'PP',
      'phone': '9876543211',
      'gender': 'Female',
      'school': 'Ecstasy School 1',
      'hasIdCard': false,
    },
    {
      'name': 'Rohan Gupta',
      'father': 'Mr. Gupta',
      'class': 'Class 9',
      'roll': 'Roll No: 08',
      'admission': 'ECS00003',
      'password': 'ECS00003',
      'status': 'Active',
      'avatar': 'RG',
      'phone': '9876543212',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
      'hasIdCard': true,
    },
    {
      'name': 'Ananya Singh',
      'father': 'Mr. Singh',
      'class': 'Class 8',
      'roll': 'Roll No: 22',
      'admission': 'ECS00004',
      'password': 'ECS00004',
      'status': 'Active',
      'avatar': 'AS',
      'phone': '9876543213',
      'gender': 'Female',
      'school': 'Ecstasy School 1',
      'hasIdCard': true,
    },
    {
      'name': 'Vikram Reddy',
      'father': 'Mr. Reddy',
      'class': 'Class 10',
      'roll': 'Roll No: 03',
      'admission': 'ECS00005',
      'password': 'ECS00005',
      'status': 'Inactive',
      'avatar': 'VR',
      'phone': '9876543214',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
      'hasIdCard': false,
    },
    {
      'name': 'Sneha Joshi',
      'father': 'Mr. Joshi',
      'class': 'Class 9',
      'roll': 'Roll No: 11',
      'admission': 'ECS00006',
      'password': 'ECS00006',
      'status': 'Active',
      'avatar': 'SJ',
      'phone': '9876543215',
      'gender': 'Female',
      'school': 'Ecstasy School 1',
      'hasIdCard': true,
    },
    {
      'name': 'Arjun Nair',
      'father': 'Mr. Nair',
      'class': 'Class 8',
      'roll': 'Roll No: 05',
      'admission': 'ECS00007',
      'password': 'ECS00007',
      'status': 'Active',
      'avatar': 'AN',
      'phone': '9876543216',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Kavya Menon',
      'father': 'Mr. Menon',
      'class': 'Class 7',
      'roll': 'Roll No: 19',
      'admission': 'ECS00008',
      'password': 'ECS00008',
      'status': 'Active',
      'avatar': 'KM',
      'phone': '9876543217',
      'gender': 'Female',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Rahul Verma',
      'father': 'Mr. Verma',
      'class': 'Class 7',
      'roll': 'Roll No: 02',
      'admission': 'ECS00009',
      'password': 'ECS00009',
      'status': 'Inactive',
      'avatar': 'RV',
      'phone': '9876543218',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Meera Das',
      'father': 'Mr. Das',
      'class': 'Class 6',
      'roll': 'Roll No: 14',
      'admission': 'ECS00010',
      'password': 'ECS00010',
      'status': 'Active',
      'avatar': 'MD',
      'phone': '9876543219',
      'gender': 'Female',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Little Timmy',
      'father': 'Mr. Timmy',
      'class': 'LKG',
      'roll': 'Roll No: 01',
      'admission': 'ECS00011',
      'password': 'ECS00011',
      'status': 'Active',
      'avatar': 'LT',
      'phone': '9876543220',
      'gender': 'Male',
      'school': 'Ecstasy School 1',
    },

    // --- Ecstasy School 2 ---
    {
      'name': 'Kabir Malhotra',
      'father': 'Mr. Malhotra',
      'class': 'Class 10',
      'roll': 'Roll No: 01',
      'admission': 'ECS00201',
      'password': 'ECS00201',
      'status': 'Active',
      'avatar': 'KM',
      'phone': '9876542201',
      'gender': 'Male',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Dia Sen',
      'father': 'Mr. Sen',
      'class': 'Class 10',
      'roll': 'Roll No: 12',
      'admission': 'ECS00202',
      'password': 'ECS00202',
      'status': 'Active',
      'avatar': 'DS',
      'phone': '9876542202',
      'gender': 'Female',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Aarush Nair',
      'father': 'Mr. Nair',
      'class': 'Class 9',
      'roll': 'Roll No: 04',
      'admission': 'ECS00203',
      'password': 'ECS00203',
      'status': 'Active',
      'avatar': 'AN',
      'phone': '9876542203',
      'gender': 'Male',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Myra Mehta',
      'father': 'Mr. Mehta',
      'class': 'Class 8',
      'roll': 'Roll No: 18',
      'admission': 'ECS00204',
      'password': 'ECS00204',
      'status': 'Active',
      'avatar': 'MM',
      'phone': '9876542204',
      'gender': 'Female',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Devansh Goel',
      'father': 'Mr. Goel',
      'class': 'Class 10',
      'roll': 'Roll No: 02',
      'admission': 'ECS00205',
      'password': 'ECS00205',
      'status': 'Inactive',
      'avatar': 'DG',
      'phone': '9876542205',
      'gender': 'Male',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Tanvi Bhatia',
      'father': 'Mr. Bhatia',
      'class': 'Class 9',
      'roll': 'Roll No: 07',
      'admission': 'ECS00206',
      'password': 'ECS00206',
      'status': 'Active',
      'avatar': 'TB',
      'phone': '9876542206',
      'gender': 'Female',
      'school': 'Ecstasy School 2',
    },


    // --- Ecstasy School 3 ---
    {
      'name': 'Vivaan Kapoor',
      'father': 'Mr. Kapoor',
      'class': 'Class 10',
      'roll': 'Roll No: 01',
      'admission': 'ECS00301',
      'password': 'ECS00301',
      'status': 'Active',
      'avatar': 'VK',
      'phone': '9876543301',
      'gender': 'Male',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Isha Patil',
      'father': 'Mr. Patil',
      'class': 'Class 10',
      'roll': 'Roll No: 10',
      'admission': 'ECS00302',
      'password': 'ECS00302',
      'status': 'Active',
      'avatar': 'IP',
      'phone': '9876543302',
      'gender': 'Female',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Parth Rawat',
      'father': 'Mr. Rawat',
      'class': 'Class 9',
      'roll': 'Roll No: 03',
      'admission': 'ECS00303',
      'password': 'ECS00303',
      'status': 'Active',
      'avatar': 'PR',
      'phone': '9876543303',
      'gender': 'Male',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Tara Dsouza',
      'father': 'Mr. Dsouza',
      'class': 'Class 8',
      'roll': 'Roll No: 15',
      'admission': 'ECS00304',
      'password': 'ECS00304',
      'status': 'Active',
      'avatar': 'TD',
      'phone': '9876543304',
      'gender': 'Female',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Neil Fernandes',
      'father': 'Mr. Fernandes',
      'class': 'Class 10',
      'roll': 'Roll No: 05',
      'admission': 'ECS00305',
      'password': 'ECS00305',
      'status': 'Inactive',
      'avatar': 'NF',
      'phone': '9876543305',
      'gender': 'Male',
      'school': 'Ecstasy School 3',
    },

  ];

  // ─── Teachers ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> teachers = [
    // --- Ecstasy School 1 ---
    {
      'name': 'Dr. Ramesh Kumar',
      'father': 'Mr. Kumar',
      'subject': 'Mathematics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'RK',
      'phone': '9876543301',
      'experience': '15 years',
      'gender': 'Male',
      'employeeCode': 'ECS00E01',
      'password': 'ECS00E01',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mrs. Sunita Devi',
      'father': 'Mr. Devi',
      'subject': 'English',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'SD',
      'phone': '9876543302',
      'experience': '12 years',
      'gender': 'Female',
      'employeeCode': 'ECS00E02',
      'password': 'ECS00E02',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mr. Anil Mishra',
      'father': 'Mr. Mishra',
      'subject': 'Physics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'AM',
      'phone': '9876543303',
      'experience': '10 years',
      'gender': 'Male',
      'employeeCode': 'ECS00E03',
      'password': 'ECS00E03',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ms. Deepa Nair',
      'father': 'Mr. Nair',
      'subject': 'Chemistry',
      'department': 'Science',
      'status': 'Inactive',
      'avatar': 'DN',
      'phone': '9876543304',
      'experience': '8 years',
      'gender': 'Female',
      'employeeCode': 'ECS00E04',
      'password': 'ECS00E04',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mr. Suresh Rao',
      'father': 'Mr. Rao',
      'subject': 'Computer Science',
      'department': 'Technology',
      'status': 'Active',
      'avatar': 'SR',
      'phone': '9876543305',
      'experience': '6 years',
      'gender': 'Male',
      'employeeCode': 'ECS00E05',
      'password': 'ECS00E05',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mrs. Latha Iyer',
      'father': 'Mr. Iyer',
      'subject': 'Hindi',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'LI',
      'phone': '9876543306',
      'experience': '14 years',
      'gender': 'Female',
      'employeeCode': 'ECS00E06',
      'password': 'ECS00E06',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mr. Prakash Jha',
      'father': 'Mr. Jha',
      'subject': 'Social Studies',
      'department': 'Humanities',
      'status': 'Active',
      'avatar': 'PJ',
      'phone': '9876543307',
      'experience': '9 years',
      'gender': 'Male',
      'employeeCode': 'ECS00E07',
      'password': 'ECS00E07',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mrs. Geeta Sharma',
      'father': 'Mr. Sharma',
      'subject': 'Biology',
      'department': 'Science',
      'status': 'Inactive',
      'avatar': 'GS',
      'phone': '9876543308',
      'experience': '11 years',
      'gender': 'Female',
      'employeeCode': 'ECS00E08',
      'password': 'ECS00E08',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Mr. Vijay Patil',
      'father': 'Mr. Patil',
      'subject': 'Physical Education',
      'department': 'Sports',
      'status': 'Active',
      'avatar': 'VP',
      'phone': '9876543309',
      'experience': '7 years',
      'gender': 'Male',
      'employeeCode': 'ECS00E09',
      'password': 'ECS00E09',
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ms. Anjali Chopra',
      'father': 'Mr. Chopra',
      'subject': 'Art & Craft',
      'department': 'Creative Arts',
      'status': 'Active',
      'avatar': 'AC',
      'phone': '9876543310',
      'experience': '5 years',
      'gender': 'Female',
      'employeeCode': 'ECS00E10',
      'password': 'ECS00E10',
      'school': 'Ecstasy School 1',
    },

    // --- Ecstasy School 2 ---
    {
      'name': 'Dr. Sanjay Dutt',
      'father': 'Mr. Dutt',
      'subject': 'Mathematics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'SD',
      'phone': '9876544401',
      'experience': '10 years',
      'gender': 'Male',
      'employeeCode': 'ECS02E01',
      'password': 'ECS02E01',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Mrs. Kiran Bedi',
      'father': 'Mr. Bedi',
      'subject': 'English',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'KB',
      'phone': '9876544402',
      'experience': '15 years',
      'gender': 'Female',
      'employeeCode': 'ECS02E02',
      'password': 'ECS02E02',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Mr. Rohit Sharma',
      'father': 'Mr. Sharma',
      'subject': 'Physics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'RS',
      'phone': '9876544403',
      'experience': '9 years',
      'gender': 'Male',
      'employeeCode': 'ECS02E03',
      'password': 'ECS02E03',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Ms. Kiara Advani',
      'father': 'Mr. Advani',
      'subject': 'Art & Craft',
      'department': 'Creative Arts',
      'status': 'Active',
      'avatar': 'KA',
      'phone': '9876544404',
      'experience': '4 years',
      'gender': 'Female',
      'employeeCode': 'ECS02E04',
      'password': 'ECS02E04',
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Mr. MS Dhoni',
      'father': 'Mr. Dhoni',
      'subject': 'Physical Education',
      'department': 'Sports',
      'status': 'Active',
      'avatar': 'MD',
      'phone': '9876544405',
      'experience': '16 years',
      'gender': 'Male',
      'employeeCode': 'ECS02E05',
      'password': 'ECS02E05',
      'school': 'Ecstasy School 2',
    },


    // --- Ecstasy School 3 ---
    {
      'name': 'Dr. APJ Kalam',
      'father': 'Mr. Kalam',
      'subject': 'Mathematics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'AK',
      'phone': '9876545501',
      'experience': '20 years',
      'gender': 'Male',
      'employeeCode': 'ECS03E01',
      'password': 'ECS03E01',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Mrs. Sudha Murthy',
      'father': 'Mr. Murthy',
      'subject': 'English',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'SM',
      'phone': '9876545502',
      'experience': '18 years',
      'gender': 'Female',
      'employeeCode': 'ECS03E02',
      'password': 'ECS03E02',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Mr. Sachin Tendulkar',
      'father': 'Mr. Tendulkar',
      'subject': 'Sports',
      'department': 'Sports',
      'status': 'Active',
      'avatar': 'ST',
      'phone': '9876545503',
      'experience': '15 years',
      'gender': 'Male',
      'employeeCode': 'ECS03E03',
      'password': 'ECS03E03',
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Ms. Lata Mangeshkar',
      'father': 'Mr. Mangeshkar',
      'subject': 'Music',
      'department': 'Creative Arts',
      'status': 'Active',
      'avatar': 'LM',
      'phone': '9876545504',
      'experience': '25 years',
      'gender': 'Female',
      'employeeCode': 'ECS03E04',
      'password': 'ECS03E04',
      'school': 'Ecstasy School 3',
    },

  ];

  // ─── Branches ─────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> branches = [
    // --- Ecstasy School 1 Branches ---
    {
      'name': 'Ecstasy School - Main Campus',
      'father': 'Mr. Campus',
      'address': '123 Education Lane, Hyderabad',
      'students': 450,
      'teachers': 32,
      'status': 'Active',
      'established': '2010',
      'principal': 'Dr. Ravi Shankar',
      'color': const Color(0xFF0038FF),
      'icon': Icons.apartment,
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ecstasy School - City Center',
      'father': 'Mr. Center',
      'address': '456 Knowledge Rd, Hyderabad',
      'students': 380,
      'teachers': 28,
      'status': 'Active',
      'established': '2013',
      'principal': 'Mrs. Lakshmi Devi',
      'color': const Color(0xFF10B981),
      'icon': Icons.location_city,
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ecstasy School - Tech Park',
      'father': 'Mr. Park',
      'address': '789 Innovation Blvd, Hyderabad',
      'students': 290,
      'teachers': 20,
      'status': 'Active',
      'established': '2016',
      'principal': 'Mr. Arun Mehta',
      'color': const Color(0xFFF59E0B),
      'icon': Icons.computer,
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ecstasy School - Lake View',
      'father': 'Mr. View',
      'address': '321 Serene Ave, Hyderabad',
      'students': 125,
      'teachers': 6,
      'status': 'Active',
      'established': '2020',
      'principal': 'Ms. Priya Reddy',
      'color': const Color(0xFF8B5CF6),
      'icon': Icons.water,
      'school': 'Ecstasy School 1',
    },
    {
      'name': 'Ecstasy School - North Campus',
      'father': 'Mr. Campus',
      'address': '654 Scholar St, Secunderabad',
      'students': 0,
      'teachers': 0,
      'status': 'Coming Soon',
      'established': '2026',
      'principal': 'TBD',
      'color': const Color(0xFFEC4899),
      'icon': Icons.account_balance,
      'school': 'Ecstasy School 1',
    },

    // --- Ecstasy School 2 Branches ---
    {
      'name': 'Ecstasy School 2 - West Campus',
      'father': 'Mr. Campus',
      'address': '77 West High St, Gachibowli',
      'students': 310,
      'teachers': 22,
      'status': 'Active',
      'established': '2018',
      'principal': 'Mr. Rahul Dravid',
      'color': const Color(0xFF0038FF),
      'icon': Icons.apartment,
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Ecstasy School 2 - East Campus',
      'father': 'Mr. Campus',
      'address': '88 East Ring Rd, Uppal',
      'students': 240,
      'teachers': 15,
      'status': 'Active',
      'established': '2020',
      'principal': 'Mrs. Smriti Mandhana',
      'color': const Color(0xFF10B981),
      'icon': Icons.location_city,
      'school': 'Ecstasy School 2',
    },
    {
      'name': 'Ecstasy School 2 - Hilltop Branch',
      'father': 'Mr. Branch',
      'address': '12 Hill View, Jubilee Hills',
      'students': 110,
      'teachers': 8,
      'status': 'Active',
      'established': '2022',
      'principal': 'Dr. Harsha Bhogle',
      'color': const Color(0xFFF59E0B),
      'icon': Icons.terrain,
      'school': 'Ecstasy School 2',
    },

    // --- Ecstasy School 3 Branches ---
    {
      'name': 'Ecstasy School 3 - South Campus',
      'father': 'Mr. Campus',
      'address': '55 Southern Rd, Begumpet',
      'students': 180,
      'teachers': 14,
      'status': 'Active',
      'established': '2019',
      'principal': 'Mr. Anil Kumble',
      'color': const Color(0xFF0038FF),
      'icon': Icons.apartment,
      'school': 'Ecstasy School 3',
    },
    {
      'name': 'Ecstasy School 3 - Coastal Branch',
      'father': 'Mr. Branch',
      'address': '99 Beach Dr, Vizag',
      'students': 150,
      'teachers': 10,
      'status': 'Active',
      'established': '2021',
      'principal': 'Mrs. Mithali Raj',
      'color': const Color(0xFF10B981),
      'icon': Icons.beach_access,
      'school': 'Ecstasy School 3',
    },
  ];

  // ─── Auth ─────────────────────────────────────────────────────────────────

  /// Returns 'admin' | 'student' | 'teacher' | null
  String? authenticate(String userId, String password) {
    final id = userId.trim();
    final pw = password.trim();

    // Admin
    if (id.toLowerCase() == 'admin' && pw == 'admin@123') return 'admin';

    // Student — match by admission number (case-insensitive)
    final student = students.firstWhere(
      (s) =>
          (s['admission'] as String).toUpperCase() == id.toUpperCase() &&
          (s['password'] as String) == pw,
      orElse: () => {},
    );
    if (student.isNotEmpty) return 'student';

    // Teacher — match by employee code (case-insensitive)
    final teacher = teachers.firstWhere(
      (t) =>
          (t['employeeCode'] as String).toUpperCase() == id.toUpperCase() &&
          (t['password'] as String) == pw,
      orElse: () => {},
    );
    if (teacher.isNotEmpty) return 'teacher';

    return null;
  }

  String getNextAdmissionNo(String school) {
    int maxNum = 0;
    final regExp = RegExp(r'^ECS(\d+)$', caseSensitive: false);
    for (final student in students) {
      if (student['school'] == school) {
        final admission = student['admission'];
        if (admission is String) {
          final match = regExp.firstMatch(admission);
          if (match != null) {
            final numStr = match.group(1);
            if (numStr != null) {
              final val = int.tryParse(numStr) ?? 0;
              if (val > maxNum) {
                maxNum = val;
              }
            }
          }
        }
      }
    }
    final nextNum = maxNum + 1;
    return "ECS${nextNum.toString().padLeft(5, '0')}";
  }

  /// Central data mod functions called from Admin tabs
  void addStudent(Map<String, dynamic> student) {
    final admission = student['admission'];
    student['password'] ??= (admission is String ? admission : 'ECS00000');
    students.insert(0, student);
    notifyConfigChange();
  }

  void updateStudent(int index, Map<String, dynamic> student) {
    students[index] = student;
    notifyConfigChange();
  }

  void addTeacher(Map<String, dynamic> teacher) {
    final code = teacher['employeeCode'];
    teacher['password'] ??= (code is String ? code : 'ECS00E00');
    teachers.insert(0, teacher);
  }

  void addBranch(Map<String, dynamic> branch) {
    branches.insert(0, branch);
  }

  void deleteBranch(Map<String, dynamic> branch) {
    branches.removeWhere((b) => b['name'] == branch['name'] && b['school'] == branch['school']);
  }

  // ─── Logged-in user profile (set on login) ────────────────────────────────
  Map<String, dynamic>? currentUser;
  String currentRole = '';

  // ─── School-Specific Metrics Lookup ───────────────────────────────────────
  Map<String, dynamic> getSchoolMetrics(String school) {
    if (school == 'Ecstasy School 2') {
      return {
        'totalCollected': '₹ 1,85,000',
        'totalPending': '₹ 12,40,000',
        'overdueAmount': '₹ 3,20,000',
        'collectedPercent': 13.0,
        'presentPercent': 88,
        'presentCount': '580',
        'absentCount': '60',
        'leaveCount': '20',
        'attendanceChange': '↑ 2% from yesterday',
        'attendanceChangeColor': Colors.green,
        'tuitionPaidPercent': 25.0,
        'tuitionPendingPercent': 75.0,
        'transportPaidPercent': 30.0,
        'transportPendingPercent': 70.0,
        // Chart spots
        'chartCollected': const [
          FlSpot(0, 15), FlSpot(1, 10), FlSpot(2, 18), FlSpot(3, 20),
          FlSpot(4, 15.5), FlSpot(5, 22), FlSpot(6, 25), FlSpot(7, 19),
          FlSpot(8, 17), FlSpot(9, 21), FlSpot(10, 24), FlSpot(11, 26),
        ],
        'chartPending': const [
          FlSpot(0, 5), FlSpot(1, 12), FlSpot(2, 8), FlSpot(3, 11),
        ],
      };
    } else if (school == 'Ecstasy School 3') {
      return {
        'totalCollected': '₹ 3,10,000',
        'totalPending': '₹ 9,50,000',
        'overdueAmount': '₹ 1,80,000',
        'collectedPercent': 25.0,
        'presentPercent': 95,
        'presentCount': '315',
        'absentCount': '12',
        'leaveCount': '5',
        'attendanceChange': '↓ 1% from yesterday',
        'attendanceChangeColor': Colors.red,
        'tuitionPaidPercent': 45.0,
        'tuitionPendingPercent': 55.0,
        'transportPaidPercent': 50.0,
        'transportPendingPercent': 50.0,
        // Chart spots
        'chartCollected': const [
          FlSpot(0, 12), FlSpot(1, 15), FlSpot(2, 14), FlSpot(3, 22),
          FlSpot(4, 28.0), FlSpot(5, 30), FlSpot(6, 22), FlSpot(7, 24),
          FlSpot(8, 20), FlSpot(9, 18), FlSpot(10, 19), FlSpot(11, 23),
        ],
        'chartPending': const [
          FlSpot(0, 10), FlSpot(1, 8), FlSpot(2, 11), FlSpot(3, 9),
        ],
      };
    } else {
      // Default (Ecstasy School 1)
      return {
        'totalCollected': '₹ 2,45,000',
        'totalPending': '₹ 18,75,000',
        'overdueAmount': '₹ 5,60,000',
        'collectedPercent': 24.0,
        'presentPercent': 92,
        'presentCount': '1,145',
        'absentCount': '78',
        'leaveCount': '22',
        'attendanceChange': '↑ 4% from yesterday',
        'attendanceChangeColor': Colors.green,
        'tuitionPaidPercent': 8.0,
        'tuitionPendingPercent': 92.0,
        'transportPaidPercent': 12.0,
        'transportPendingPercent': 88.0,
        // Chart spots
        'chartCollected': const [
          FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 15), FlSpot(3, 18),
          FlSpot(4, 24.5), FlSpot(5, 20), FlSpot(6, 18), FlSpot(7, 15),
          FlSpot(8, 22), FlSpot(9, 25), FlSpot(10, 20), FlSpot(11, 18),
        ],
        'chartPending': const [
          FlSpot(0, 8), FlSpot(1, 10), FlSpot(2, 12), FlSpot(3, 14),
        ],
      };
    }
  }

  // ─── Daily Attendance Records ─────────────────────────────────────────────
  // Map structure: school -> date -> admission -> status ('Present', 'Absent', 'Late', 'Leave')
  final Map<String, Map<String, Map<String, String>>> attendanceRecords = {};

  void initAttendanceIfNeeded() {
    if (attendanceRecords.isNotEmpty) return;
    
    final dates = ['20 May 2026', '21 May 2026', '22 May 2026', '23 May 2026', '24 May 2026'];
    for (final school in ['Ecstasy School 1', 'Ecstasy School 2', 'Ecstasy School 3']) {
      attendanceRecords[school] = {};
      for (final date in dates) {
        attendanceRecords[school]![date] = {};
        // Seed student status for this date
        final schoolStudents = students.where((s) => s['school'] == school).toList();
        for (int i = 0; i < schoolStudents.length; i++) {
          final student = schoolStudents[i];
          final admission = student['admission'] as String;
          
          // Seed varying statuses for different dates to make the data change
          String status = 'Present';
          final defaultActive = student['status'] == 'Active';
          
          if (!defaultActive) {
            status = 'Absent';
          } else {
            // Active student - vary status by date
            final dateHash = date.hashCode;
            final studentHash = admission.hashCode;
            final val = (dateHash + studentHash + i) % 10;
            if (val == 0) {
              status = 'Absent';
            } else if (val == 1) {
              status = 'Late';
            } else if (val == 2) {
              status = 'Leave';
            } else {
              status = 'Present';
            }
          }
          attendanceRecords[school]![date]![admission] = status;
        }
      }
    }
  }

  String getStudentAttendance(String school, String date, String admission, String defaultStatus) {
    initAttendanceIfNeeded();
    final schoolRecords = attendanceRecords[school];
    if (schoolRecords != null) {
      final dateRecords = schoolRecords[date];
      if (dateRecords != null) {
        final status = dateRecords[admission];
        if (status != null) {
          return status;
        }
      }
    }
    // Fallback if not seeded
    return defaultStatus == 'Active' || defaultStatus == 'Present' ? 'Present' : 'Absent';
  }

  void setStudentAttendance(String school, String date, String admission, String status) {
    initAttendanceIfNeeded();
    if (!attendanceRecords.containsKey(school)) {
      attendanceRecords[school] = {};
    }
    if (!attendanceRecords[school]!.containsKey(date)) {
      attendanceRecords[school]![date] = {};
    }
    attendanceRecords[school]![date]![admission] = status;
  }

  // ─── Fee Structures ────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> feeStructures = [
    {
      'school': 'Ecstasy School 1',
      'branchCode': 'ECS001',
      'tuition': 45000,
      'transport': 12000,
      'exam': 3000,
      'total': 60000,
    },
    {
      'school': 'Ecstasy School 2',
      'branchCode': 'ECS002',
      'tuition': 38000,
      'transport': 10000,
      'exam': 2500,
      'total': 50500,
    },
    {
      'school': 'Ecstasy School 3',
      'branchCode': 'ECS003',
      'tuition': 32000,
      'transport': 8000,
      'exam': 2000,
      'total': 42000,
    },
  ];

  // ─── Config Change Notifier ─────────────────────────────────────────────────
  /// Increment this whenever ANY config data changes.
  // ─── Settings ───────────────────────────────────────────────────────────
  bool showIdCardPhoto = true;
  void toggleIdCardPhoto(bool value) {
    showIdCardPhoto = value;
    notifyConfigChange();
  }

  // ─── Utilities ────────────────────────────────────────────────────────────
  final ValueNotifier<int> configVersion = ValueNotifier<int>(0);
  void notifyConfigChange() => configVersion.value++;

  // ─── Holidays ───────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> holidays = [
    {'date': '2/10/2026', 'description': 'Gandhi Jayanti'},
    {'date': '25/12/2026', 'description': 'Christmas Day'},
    {'date': '20/5/2026', 'description': 'Krishna Birthday'},
    {'date': '23/5/2026', 'description': 'Birthday'},
    {'date': '27/5/2026', 'description': 'Bakrid'},
    {'date': '30/5/2026', 'description': 'Second Saturday'},
  ];

  void addHoliday(Map<String, dynamic> h) { holidays.add(h); notifyConfigChange(); }
  void updateHoliday(int i, Map<String, dynamic> h) { holidays[i] = h; notifyConfigChange(); }
  void deleteHoliday(int i) { holidays.removeAt(i); notifyConfigChange(); }

  // ─── Academic Years ──────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> academicYears = [
    {'year': '2025-26', 'isActive': true},
    {'year': '2026-27', 'isActive': true},
    {'year': '2027-28', 'isActive': true},
  ];
  String currentAcademicYear = '2025-26';

  void addAcademicYear(Map<String, dynamic> y) { academicYears.add(y); notifyConfigChange(); }
  void updateAcademicYear(int i, Map<String, dynamic> y) { academicYears[i] = y; notifyConfigChange(); }
  void deleteAcademicYear(int i) { academicYears.removeAt(i); notifyConfigChange(); }
  void setCurrentAcademicYear(String year) { currentAcademicYear = year; notifyConfigChange(); }

  // ─── Fee Types ───────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> feeTypes = [
    {'type': 'Registration Fee', 'isActive': true},
    {'type': 'Tuition Fee', 'isActive': true},
    {'type': 'Books fee', 'isActive': true},
    {'type': 'Cultural activity fee', 'isActive': true},
    {'type': "I'd card fee", 'isActive': true},
    {'type': 'Hostel', 'isActive': true},
    {'type': 'Transport fee', 'isActive': true},
  ];

  void addFeeType(Map<String, dynamic> f) { feeTypes.add(f); _saveFeeTypes(); notifyConfigChange(); }
  void updateFeeType(int i, Map<String, dynamic> f) { feeTypes[i] = f; _saveFeeTypes(); notifyConfigChange(); }
  void deleteFeeType(int i) { feeTypes.removeAt(i); _saveFeeTypes(); notifyConfigChange(); }

  // ─── Payment Types ───────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> paymentTypes = [
    {'name': 'Online Payment',
      'father': 'Mr. Payment', 'isActive': true},
    {'name': 'Cash',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'UPI',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Credit/Debit Card',
      'father': 'Mr. Card', 'isActive': true},
    {'name': 'Cheque',
      'father': 'Mr. Kumar', 'isActive': true},
  ];

  // ─── Study Classes ───────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> studyClasses = [
    {'name': 'Nursery',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'L.K.G',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'U.K.G',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Class 1',
      'father': 'Mr. 1', 'isActive': true},
    {'name': 'Class 2',
      'father': 'Mr. 2', 'isActive': true},
    {'name': 'Class 3',
      'father': 'Mr. 3', 'isActive': true},
    {'name': 'Class 4',
      'father': 'Mr. 4', 'isActive': true},
    {'name': 'Class 5',
      'father': 'Mr. 5', 'isActive': true},
    {'name': 'Class 6',
      'father': 'Mr. 6', 'isActive': true},
    {'name': 'Class 7',
      'father': 'Mr. 7', 'isActive': true},
    {'name': 'Class 8',
      'father': 'Mr. 8', 'isActive': true},
    {'name': 'Class 9',
      'father': 'Mr. 9', 'isActive': true},
    {'name': 'Class 10',
      'father': 'Mr. 10', 'isActive': true},
  ];

  // ─── Class Sections ──────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> classSections = [
    {'name': 'Section A',
      'father': 'Mr. A', 'isActive': true},
    {'name': 'Section B',
      'father': 'Mr. B', 'isActive': true},
    {'name': 'Section C',
      'father': 'Mr. C', 'isActive': true},
    {'name': 'Section D',
      'father': 'Mr. D', 'isActive': true},
  ];

  // ─── Subjects ────────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'English',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Science',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Hindi',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Social Studies',
      'father': 'Mr. Studies', 'isActive': true},
    {'name': 'Computer Science',
      'father': 'Mr. Science', 'isActive': true},
    {'name': 'Physics',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Chemistry',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Biology',
      'father': 'Mr. Kumar', 'isActive': true},
  ];

  // ─── Exam Types ──────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> examTypes = [
    {'name': 'Unit Test',
      'father': 'Mr. Test', 'isActive': true},
    {'name': 'Mid Term',
      'father': 'Mr. Term', 'isActive': true},
    {'name': 'Final Exam',
      'father': 'Mr. Exam', 'isActive': true},
    {'name': 'Quarterly',
      'father': 'Mr. Kumar', 'isActive': true},
    {'name': 'Annual',
      'father': 'Mr. Kumar', 'isActive': true},
  ];

  // ─── Grade System ────────────────────────────────────────────────────────────
  final List<Map<String, dynamic>> gradeSystem = [
    {'name': 'A+ (90-100)',
      'father': 'Mr. (90-100)', 'isActive': true},
    {'name': 'A (80-89)',
      'father': 'Mr. (80-89)', 'isActive': true},
    {'name': 'B+ (70-79)',
      'father': 'Mr. (70-79)', 'isActive': true},
    {'name': 'B (60-69)',
      'father': 'Mr. (60-69)', 'isActive': true},
    {'name': 'C (50-59)',
      'father': 'Mr. (50-59)', 'isActive': true},
    {'name': 'D (40-49)',
      'father': 'Mr. (40-49)', 'isActive': true},
    {'name': 'F (Below 40)',
      'father': 'Mr. 40)', 'isActive': true},
  ];

  // ─── Grade Report Designs ─────────────────────────────────────────────────────
  final List<Map<String, dynamic>> gradeReportDesigns = [
    {'name': 'Standard Template',
      'father': 'Mr. Template', 'isActive': true},
    {'name': 'Modern Template',
      'father': 'Mr. Template', 'isActive': true},
    {'name': 'Classic Template',
      'father': 'Mr. Template', 'isActive': true},
  ];

  // ─── Student/Parent User Types ────────────────────────────────────────────────
  final List<Map<String, dynamic>> studentParentUsers = [
    {'name': 'Student Portal',
      'father': 'Mr. Portal', 'isActive': true},
    {'name': 'Parent App',
      'father': 'Mr. App', 'isActive': true},
    {'name': 'Guardian Access',
      'father': 'Mr. Access', 'isActive': true},
  ];

  // ─── Class Subjects Mapping ───────────────────────────────────────────────────
  final List<Map<String, String>> classSubjectsMapping = [
    {'class': 'Class 1', 'subject': 'Mathematics', 'teacher': 'Dr. Ramesh Kumar'},
    {'class': 'Class 1', 'subject': 'English', 'teacher': 'Mrs. Sunita Devi'},
    {'class': 'Class 2', 'subject': 'Science', 'teacher': 'Mr. Anil Mishra'},
    {'class': 'Class 3', 'subject': 'Hindi', 'teacher': 'Mrs. Latha Iyer'},
    {'class': 'Class 4', 'subject': 'Social Studies', 'teacher': 'Mr. Prakash Jha'},
  ];

  void addClassSubjectMapping(Map<String, String> m) { classSubjectsMapping.add(m); notifyConfigChange(); }
  void updateClassSubjectMapping(int i, Map<String, String> m) { classSubjectsMapping[i] = m; notifyConfigChange(); }
  void deleteClassSubjectMapping(int i) { classSubjectsMapping.removeAt(i); notifyConfigChange(); }

  // ─── Fee Structure Items (per class) ─────────────────────────────────────────
  final List<Map<String, dynamic>> feeStructureItems = [
    {'branch': 'Ecstasy School 1', 'year': '2025-26', 'class': 'Class 1', 'feeType': 'Registration Fee', 'amount': 3000.0},
    {'branch': 'Ecstasy School 1', 'year': '2025-26', 'class': 'Class 1', 'feeType': 'Activity Fee', 'amount': 6000.0},
    {'branch': 'Ecstasy School 1', 'year': '2025-26', 'class': 'Class 1', 'feeType': 'Tuition Fee', 'amount': 38000.0},
    {'branch': 'Ecstasy School 1', 'year': '2025-26', 'class': 'Class 1', 'feeType': 'books fee', 'amount': 11000.0},
    {'branch': 'Ecstasy School 1', 'year': '2025-26', 'class': 'Class 1', 'feeType': 'cultural activity fee', 'amount': 4000.0},
  ];

  void addFeeStructureItem(Map<String, dynamic> item) { feeStructureItems.add(item); _saveFeeStructure(); notifyConfigChange(); }
  void updateFeeStructureItem(int i, Map<String, dynamic> item) { feeStructureItems[i] = item; _saveFeeStructure(); notifyConfigChange(); }
  void deleteFeeStructureItem(int i) { feeStructureItems.removeAt(i); _saveFeeStructure(); notifyConfigChange(); }

  List<Map<String, dynamic>> getFeeStructureItems(String branch, String year, String cls) {
    var existing = feeStructureItems
        .where((r) => r['branch'] == branch && r['year'] == year && r['class'] == cls)
        .toList();

    final activeFeeTypes = feeTypes.where((f) => f['isActive'] == true).toList();
    final activeTypeNames = activeFeeTypes.map((f) => f['type']).toSet();
    
    // Parse class level
    int level = 0;
    String clsLower = cls.toLowerCase();
    if (clsLower.contains('class')) {
      level = int.tryParse(clsLower.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
    
    bool newlyAdded = false;
    for (int i = 0; i < activeFeeTypes.length; i++) {
        String typeName = activeFeeTypes[i]['type'];
        if (!existing.any((e) => e['feeType'] == typeName)) {
            String lowerType = typeName.toLowerCase();
            double amount = 1000.0; // default
            
            if (lowerType.contains('registration') || lowerType.contains('id') || lowerType.contains('transport')) {
                if (lowerType.contains('registration')) {
                  amount = 3000.0;
                } else if (lowerType.contains('id')) {
                  amount = 500.0;
                } else if (lowerType.contains('transport')) {
                  amount = 15000.0;
                } else {
                  amount = 2000.0;
                }
            } else if (lowerType.contains('tuition')) {
                amount = 20000.0 + (level * 8000.0);
                if (amount > 100000.0) amount = 100000.0;
            } else if (lowerType.contains('books') || lowerType.contains('cultural') || lowerType.contains('hostel')) {
                double base = lowerType.contains('hostel') ? 40000.0 : 5000.0;
                if (level >= 6) {
                    amount = base + 10000.0;
                } else {
                    amount = base;
                }
            } else {
                amount = (10 + ((level + i) % 50)) * 100.0;
            }

            var newItem = {
                'branch': branch,
                'year': year,
                'class': cls,
                'feeType': typeName,
                'amount': amount,
            };
            feeStructureItems.add(newItem);
            newlyAdded = true;
        }
    }
    
    if (newlyAdded) _saveFeeStructure();
    
    return feeStructureItems
        .where((r) => r['branch'] == branch && r['year'] == year && r['class'] == cls && activeTypeNames.contains(r['feeType']))
        .toList();
  }

  // ─── Generic config list CRUD (for lists stored directly in AppDataStore) ─────
  void addConfigItem(List<Map<String, dynamic>> list, Map<String, dynamic> item) {
    list.add(item); notifyConfigChange();
  }
  void updateConfigItem(List<Map<String, dynamic>> list, int index, Map<String, dynamic> item) {
    list[index] = item; notifyConfigChange();
  }
  void deleteConfigItem(List<Map<String, dynamic>> list, int index) {
    list.removeAt(index); notifyConfigChange();
  }
}
