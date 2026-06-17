import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminTeachersTab extends StatefulWidget {
  const AdminTeachersTab({super.key});

  @override
  State<AdminTeachersTab> createState() => _AdminTeachersTabState();
}

class _AdminTeachersTabState extends State<AdminTeachersTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _teachers = [
    {
      'name': 'Dr. Ramesh Kumar',
      'subject': 'Mathematics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'RK',
      'phone': '9876543301',
      'experience': '15 years',
      'gender': 'Male',
    },
    {
      'name': 'Mrs. Sunita Devi',
      'subject': 'English',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'SD',
      'phone': '9876543302',
      'experience': '12 years',
      'gender': 'Female',
    },
    {
      'name': 'Mr. Anil Mishra',
      'subject': 'Physics',
      'department': 'Science',
      'status': 'Active',
      'avatar': 'AM',
      'phone': '9876543303',
      'experience': '10 years',
      'gender': 'Male',
    },
    {
      'name': 'Ms. Deepa Nair',
      'subject': 'Chemistry',
      'department': 'Science',
      'status': 'On Leave',
      'avatar': 'DN',
      'phone': '9876543304',
      'experience': '8 years',
      'gender': 'Female',
    },
    {
      'name': 'Mr. Suresh Rao',
      'subject': 'Computer Science',
      'department': 'Technology',
      'status': 'Active',
      'avatar': 'SR',
      'phone': '9876543305',
      'experience': '6 years',
      'gender': 'Male',
    },
    {
      'name': 'Mrs. Latha Iyer',
      'subject': 'Hindi',
      'department': 'Languages',
      'status': 'Active',
      'avatar': 'LI',
      'phone': '9876543306',
      'experience': '14 years',
      'gender': 'Female',
    },
    {
      'name': 'Mr. Prakash Jha',
      'subject': 'Social Studies',
      'department': 'Humanities',
      'status': 'Active',
      'avatar': 'PJ',
      'phone': '9876543307',
      'experience': '9 years',
      'gender': 'Male',
    },
    {
      'name': 'Mrs. Geeta Sharma',
      'subject': 'Biology',
      'department': 'Science',
      'status': 'On Leave',
      'avatar': 'GS',
      'phone': '9876543308',
      'experience': '11 years',
      'gender': 'Female',
    },
    {
      'name': 'Mr. Vijay Patil',
      'subject': 'Physical Education',
      'department': 'Sports',
      'status': 'Active',
      'avatar': 'VP',
      'phone': '9876543309',
      'experience': '7 years',
      'gender': 'Male',
    },
    {
      'name': 'Ms. Anjali Chopra',
      'subject': 'Art & Craft',
      'department': 'Creative Arts',
      'status': 'Active',
      'avatar': 'AC',
      'phone': '9876543310',
      'experience': '5 years',
      'gender': 'Female',
    },
  ];

  List<Map<String, dynamic>> get _filteredTeachers {
    return _teachers.where((t) {
      final matchesFilter =
          _selectedFilter == 'All' || t['status'] == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          t['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t['subject'].toLowerCase().contains(_searchQuery.toLowerCase());
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
    final activeCount = _teachers.where((t) => t['status'] == 'Active').length;
    final onLeaveCount = _teachers.length - activeCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          _buildHeader(activeCount, onLeaveCount),
          _buildFilterRow(),
          Expanded(
            child: _filteredTeachers.isEmpty
                ? const Center(
                    child: Text(
                      "No teachers found",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (context, index) {
                      return _buildTeacherCard(_filteredTeachers[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add Teacher — Coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label:
            const Text("Add Teacher", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(int active, int onLeave) {
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
            "Teachers",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Manage all teaching staff",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat("Total", "${_teachers.length}", Icons.school),
              const SizedBox(width: 10),
              _buildMiniStat("Active", "$active", Icons.check_circle),
              const SizedBox(width: 10),
              _buildMiniStat("On Leave", "$onLeave", Icons.event_busy),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search teachers...",
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
          _buildFilterButton('On Leave'),
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

  Widget _buildTeacherCard(Map<String, dynamic> teacher) {
    final isActive = teacher['status'] == 'Active';
    final avatarColor = teacher['gender'] == 'Male'
        ? const Color(0xFF4361EE)
        : const Color(0xFFEC4899);

    // Color-code subjects
    final subjectColors = {
      'Mathematics': const Color(0xFF8B5CF6),
      'English': const Color(0xFF3B82F6),
      'Physics': const Color(0xFFF59E0B),
      'Chemistry': const Color(0xFF10B981),
      'Computer Science': const Color(0xFFEF4444),
      'Hindi': const Color(0xFFEC4899),
      'Social Studies': const Color(0xFF6366F1),
      'Biology': const Color(0xFF14B8A6),
      'Physical Education': const Color(0xFFF97316),
      'Art & Craft': const Color(0xFFD946EF),
    };
    final subjectColor = subjectColors[teacher['subject']] ?? AppColors.primary;

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
            teacher['avatar'],
            style: TextStyle(
              color: avatarColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          teacher['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E2875),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: subjectColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    teacher['subject'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: subjectColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  teacher['department'],
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              "${teacher['experience']}  •  ${teacher['phone']}",
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
                    : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                teacher['status'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
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
