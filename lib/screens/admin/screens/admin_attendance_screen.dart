import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:ersschool/core/data/app_data_store.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';

class AdminAttendanceScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  
  static List<Map<String, dynamic>> students = [
    {'id': '1', 'name': 'Deepthi', 'isPresent': false},
    {'id': '2', 'name': 'Priya', 'isPresent': true},
    {'id': '3', 'name': 'Deepthi', 'isPresent': true},
    {'id': '4', 'name': 'suresh', 'isPresent': true},
    {'id': '5', 'name': 'Rimsa', 'isPresent': true},
    {'id': '6', 'name': 'tony', 'isPresent': true},
    {'id': '7', 'name': 'lakshmi', 'isPresent': true},
    {'id': '8', 'name': 'Vijaya', 'isPresent': true},
  ];

  static Future<void> loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('attendance_students');
    List<Map<String, dynamic>> savedList = [];
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      savedList = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    students = AppDataStore.instance.students.map((masterStudent) {
      final saved = savedList.firstWhere(
        (s) => s['name'] == masterStudent['name'] || s['admission'] == masterStudent['admission'],
        orElse: () => <String, dynamic>{},
      );

      return {
        ...masterStudent,
        'isPresent': saved.isNotEmpty ? (saved['isPresent'] ?? true) : true,
      };
    }).toList();
  }

  static Future<void> saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('attendance_students', jsonEncode(students));
  }

  const AdminAttendanceScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'LKG';
  String _selectedSection = 'A';
  String _selectedDate = '30/6/2026';
  bool _showData = false;

  final List<String> branches = ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)'];
  final List<String> classesList = ['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
  final List<String> sections = ['A', 'B', 'C'];

  @override
  void initState() {
    super.initState();
    AdminAttendanceScreen.loadStudents().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Class Attendance",
        subtitle: "Track and manage student attendance...",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownLabel("Branch"),
            _buildDropdown(_selectedBranch, branches, (v) => setState(() => _selectedBranch = v!)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownLabel("Class"),
                      _buildDropdown(_selectedClass, classesList, (v) => setState(() => _selectedClass = v!)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDropdownLabel("Section"),
                      _buildDropdown(_selectedSection, sections, (v) => setState(() => _selectedSection = v!)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownLabel("Date"),
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = "${date.day}/${date.month}/${date.year}";
                  });
                }
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                    const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showData = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Get Data", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            if (_showData) ...[
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      AdminAttendanceScreen.saveStudents();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Attendance saved successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Save", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Class: $_selectedClass - $_selectedSection",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildDataTable(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1E2875),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                SizedBox(width: 40, child: Text("#", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Expanded(child: Text("Student Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Text("Present", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AdminAttendanceScreen.students.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = AdminAttendanceScreen.students[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        student['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Transform.scale(
                        scale: 1.0,
                        child: Checkbox(
                          value: student['isPresent'],
                          onChanged: (val) {
                            setState(() {
                              student['isPresent'] = val;
                            });
                          },
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
