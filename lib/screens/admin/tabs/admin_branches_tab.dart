import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminBranchesTab extends StatefulWidget {
  const AdminBranchesTab({super.key});

  @override
  State<AdminBranchesTab> createState() => _AdminBranchesTabState();
}

class _AdminBranchesTabState extends State<AdminBranchesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _branches = [
    {
      'name': 'Ecstasy School - Main Campus',
      'address': '123 Education Lane, Hyderabad',
      'students': 450,
      'teachers': 32,
      'status': 'Active',
      'established': '2010',
      'principal': 'Dr. Ravi Shankar',
      'color': const Color(0xFF4361EE),
    },
    {
      'name': 'Ecstasy School - City Center',
      'address': '456 Knowledge Rd, Hyderabad',
      'students': 380,
      'teachers': 28,
      'status': 'Active',
      'established': '2013',
      'principal': 'Mrs. Lakshmi Devi',
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Ecstasy School - Tech Park',
      'address': '789 Innovation Blvd, Hyderabad',
      'students': 290,
      'teachers': 20,
      'status': 'Active',
      'established': '2016',
      'principal': 'Mr. Arun Mehta',
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Ecstasy School - Lake View',
      'address': '321 Serene Ave, Hyderabad',
      'students': 125,
      'teachers': 6,
      'status': 'Active',
      'established': '2020',
      'principal': 'Ms. Priya Reddy',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Ecstasy School - North Campus',
      'address': '654 Scholar St, Secunderabad',
      'students': 0,
      'teachers': 0,
      'status': 'Coming Soon',
      'established': '2026',
      'principal': 'TBD',
      'color': const Color(0xFFEC4899),
    },
  ];

  List<Map<String, dynamic>> get _filteredBranches {
    if (_searchQuery.isEmpty) return _branches;
    return _branches.where((b) {
      return b['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b['address'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalStudents =
        _branches.fold<int>(0, (sum, b) => sum + (b['students'] as int));
    final totalTeachers =
        _branches.fold<int>(0, (sum, b) => sum + (b['teachers'] as int));
    final activeBranches =
        _branches.where((b) => b['status'] == 'Active').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          _buildHeader(activeBranches, totalStudents, totalTeachers),
          Expanded(
            child: _filteredBranches.isEmpty
                ? const Center(
                    child: Text(
                      "No branches found",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredBranches.length,
                    itemBuilder: (context, index) {
                      return _buildBranchCard(_filteredBranches[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add Branch — Coming soon!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_business, color: Colors.white),
        label: const Text("Add Branch", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildHeader(int active, int students, int teachers) {
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
            "Branches",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Manage school branches and locations",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildMiniStat(
                  "Branches", "${_branches.length}", Icons.business),
              const SizedBox(width: 10),
              _buildMiniStat("Students", "$students", Icons.people),
              const SizedBox(width: 10),
              _buildMiniStat("Teachers", "$teachers", Icons.school),
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
                hintText: "Search branches...",
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

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    final isActive = branch['status'] == 'Active';
    final color = branch['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top accent bar
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.school, color: color, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E2875),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 12, color: Colors.grey.shade500),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  branch['address'],
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF10B981).withValues(alpha: 0.1)
                            : const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        branch['status'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Stats row
                Row(
                  children: [
                    _buildBranchStat(
                        Icons.people, "${branch['students']}", "Students"),
                    const SizedBox(width: 16),
                    _buildBranchStat(
                        Icons.school, "${branch['teachers']}", "Teachers"),
                    const SizedBox(width: 16),
                    _buildBranchStat(Icons.calendar_today,
                        "Est. ${branch['established']}", ""),
                    const Spacer(),
                    _buildBranchStat(
                        Icons.person, branch['principal'], "Principal"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchStat(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
          ],
        ),
      ],
    );
  }
}
