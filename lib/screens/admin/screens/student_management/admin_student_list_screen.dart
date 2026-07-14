import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/data/app_data_store.dart';
import '../../widgets/admin_app_bar.dart';
import 'admin_register_student_screen.dart';
import 'admin_student_details_screen.dart';

class AdminStudentListScreen extends StatefulWidget {
  const AdminStudentListScreen({super.key});

  @override
  State<AdminStudentListScreen> createState() => _AdminStudentListScreenState();
}

class _AdminStudentListScreenState extends State<AdminStudentListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedBranch = 'All';
  String _activeStatusFilter = 'All';

  final Map<String, String> _schoolBranchCodes = {
    'Ecstasy School 1': 'ECS001',
    'Ecstasy School 2': 'ECS002',
    'Ecstasy School 3': 'ECS003',
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _allStudents {
    return AppDataStore.instance.students.toList();
  }

  List<Map<String, dynamic>> get _filteredStudents {
    final filtered = _allStudents.where((student) {
      final matchesBranch = _selectedBranch == 'All' || student['school'] == _selectedBranch;
      final matchesStatus = _activeStatusFilter == 'All' || student['status'] == _activeStatusFilter;
      final name = student['name']?.toString() ?? '';
      final matchesSearch = _searchQuery.isEmpty ||
          name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (student['admission'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesBranch && matchesStatus && matchesSearch;
    }).toList();

    return filtered.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1), // Student is usually index 1
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
        title: "Student Management",
        subtitle: "View and manage all students",
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Branch",
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedBranch,
                              isExpanded: true,
                              style: const TextStyle(color: Color(0xFF1E2875), fontSize: 13, fontWeight: FontWeight.w500),
                              items: ['All', 'Ecstasy School 1', 'Ecstasy School 2', 'Ecstasy School 3']
                                  .map((b) => DropdownMenuItem(
                                        value: b,
                                        child: Text(b == 'All' ? 'All Branches' : "$b (${_schoolBranchCodes[b]})"),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedBranch = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen())
                      ).then((newStudent) {
                        if (newStudent != null && newStudent is Map<String, dynamic>) {
                          setState(() {
                            AppDataStore.instance.students.insert(0, newStudent);
                            AppDataStore.instance.saveStudents();
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text("Add New", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            // 3. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: "Search by name or admission no...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                    suffixIcon: Icon(Icons.search, color: Color(0xFF10B981), size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // New Section: Stats Cards
            _buildStatsCards(),

            const SizedBox(height: 16),

            // New Section: Status Filter Chips
            _buildStatusFilters(),

            const SizedBox(height: 16),

            // 4. Student Card List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _filteredStudents.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("No students found", style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredStudents.length,
                      itemBuilder: (context, index) {
                        return _buildStudentCard(_filteredStudents[index]);
                      },
                    ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isActive = student['status'] == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade100, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminStudentDetailsScreen(student: student),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: !kIsWeb && student['photoPath'] != null && File(student['photoPath']).existsSync()
                    ? FileImage(File(student['photoPath']))
                    : null,
                child: !kIsWeb && student['photoPath'] != null && File(student['photoPath']).existsSync()
                    ? null
                    : Text(
                        student['avatar'] ?? 'S',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1E2875),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            student['class'] ?? 'Class',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ),
                        Text(
                          'Sec ${student['section'] ?? 'A'}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${student['roll'] ?? 'Roll: -'}  |  ${student['phone'] ?? 'N/A'}",
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        student['status'] = isActive ? 'Inactive' : 'Active';
                        AppDataStore.instance.saveStudents();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF10B981) : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isActive ? 'Active' : 'Inactive',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz, size: 12, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _actionIcon(Icons.visibility, const Color(0xFF1E2875), size: 14, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminStudentDetailsScreen(student: student)));
                      }),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.edit, Colors.blue, size: 14, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminRegisterStudentScreen(student: student, isEditMode: true))).then((updatedData) {
                          if (updatedData != null && updatedData is Map<String, dynamic>) {
                            setState(() {
                              student.addAll(updatedData);
                              AppDataStore.instance.saveStudents();
                            });
                          }
                        });
                      }),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.delete, Colors.red, size: 14, onTap: () => _confirmDelete(student)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    final total = _allStudents.length;
    final active = _allStudents.where((e) => e['status'] == 'Active').length;
    final inactive = _allStudents.where((e) => e['status'] == 'Inactive').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard("Total", "$total", Icons.school, AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard("Active", "$active", Icons.check_circle, const Color(0xFF10B981))),
          const SizedBox(width: 8),
          Expanded(child: _buildStatCard("Inactive", "$inactive", Icons.calendar_today, Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'Active', 'Inactive'].map((status) {
          final isSelected = _activeStatusFilter == status;
          return GestureDetector(
            onTap: () => setState(() => _activeStatusFilter = status),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete", style: TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete ${student['name']}?", style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppDataStore.instance.students.remove(student);
                AppDataStore.instance.saveStudents();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${student['name']} deleted successfully"),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Yes, Delete", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color, {double size = 16, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
