import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminStudentsTab extends StatefulWidget {
  const AdminStudentsTab({super.key});

  @override
  State<AdminStudentsTab> createState() => _AdminStudentsTabState();
}

class _AdminStudentsTabState extends State<AdminStudentsTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Aarav Sharma',
      'class': 'Class 10-A',
      'roll': 'Roll No: 01',
      'status': 'Active',
      'avatar': 'AS',
      'phone': '9876543210',
      'gender': 'Male',
    },
    {
      'name': 'Priya Patel',
      'class': 'Class 10-B',
      'roll': 'Roll No: 15',
      'status': 'Active',
      'avatar': 'PP',
      'phone': '9876543211',
      'gender': 'Female',
    },
    {
      'name': 'Rohan Gupta',
      'class': 'Class 9-A',
      'roll': 'Roll No: 08',
      'status': 'Active',
      'avatar': 'RG',
      'phone': '9876543212',
      'gender': 'Male',
    },
    {
      'name': 'Ananya Singh',
      'class': 'Class 8-A',
      'roll': 'Roll No: 22',
      'status': 'Active',
      'avatar': 'AS',
      'phone': '9876543213',
      'gender': 'Female',
    },
    {
      'name': 'Vikram Reddy',
      'class': 'Class 10-A',
      'roll': 'Roll No: 03',
      'status': 'Inactive',
      'avatar': 'VR',
      'phone': '9876543214',
      'gender': 'Male',
    },
    {
      'name': 'Sneha Joshi',
      'class': 'Class 9-B',
      'roll': 'Roll No: 11',
      'status': 'Active',
      'avatar': 'SJ',
      'phone': '9876543215',
      'gender': 'Female',
    },
    {
      'name': 'Arjun Nair',
      'class': 'Class 8-B',
      'roll': 'Roll No: 05',
      'status': 'Active',
      'avatar': 'AN',
      'phone': '9876543216',
      'gender': 'Male',
    },
    {
      'name': 'Kavya Menon',
      'class': 'Class 7-A',
      'roll': 'Roll No: 19',
      'status': 'Active',
      'avatar': 'KM',
      'phone': '9876543217',
      'gender': 'Female',
    },
    {
      'name': 'Rahul Verma',
      'class': 'Class 7-B',
      'roll': 'Roll No: 02',
      'status': 'Inactive',
      'avatar': 'RV',
      'phone': '9876543218',
      'gender': 'Male',
    },
    {
      'name': 'Meera Das',
      'class': 'Class 6-A',
      'roll': 'Roll No: 14',
      'status': 'Active',
      'avatar': 'MD',
      'phone': '9876543219',
      'gender': 'Female',
    },
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    return _students.where((s) {
      final matchesFilter =
          _selectedFilter == 'All' || s['status'] == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          s['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['class'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _students.where((s) => s['status'] == 'Active').length;
    final inactiveCount = _students.length - activeCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          // Header
          _buildHeader(activeCount, inactiveCount),
          // Filter chips
          _buildFilterRow(),
          // Student list
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      "No students found",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      return _buildStudentCard(_filteredStudents[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add Student — Coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label:
            const Text("Add Student", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(int active, int inactive) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Students",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Manage all students across branches",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Stats cards
          Row(
            children: [
              _buildMiniStat("Total", "${_students.length}", Icons.people),
              const SizedBox(width: 10),
              _buildMiniStat("Active", "$active", Icons.check_circle),
              const SizedBox(width: 10),
              _buildMiniStat("Inactive", "$inactive", Icons.cancel),
            ],
          ),
          const SizedBox(height: 16),
          // Search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search students...",
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterButton('All'),
          const SizedBox(width: 8),
          _buildFilterButton('Active'),
          const SizedBox(width: 8),
          _buildFilterButton('Inactive'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isActive = student['status'] == 'Active';
    final avatarColor = student['gender'] == 'Male'
        ? const Color(0xFF4361EE)
        : const Color(0xFFEC4899);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: avatarColor.withValues(alpha: 0.1),
          child: Text(
            student['avatar'],
            style: TextStyle(
              color: avatarColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          student['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E2875),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              "${student['class']}  •  ${student['roll']}",
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 2),
            Text(
              student['phone'],
              style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                student['status'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Icon(Icons.arrow_forward_ios,
                size: 12, color: Colors.grey.shade400),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
