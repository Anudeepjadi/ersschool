import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
class AdminBranchesTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminBranchesTab({super.key, this.onOpenDrawer});

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
      'color': const Color(0xFF0038FF),
      'icon': Icons.apartment,
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
      'icon': Icons.location_city,
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
      'icon': Icons.computer,
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
      'icon': Icons.water,
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
      'icon': Icons.account_balance,
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
      appBar: AdminAppBar(
        title: "Branches",
        subtitle: "Manage school branches and locations",
        onOpenDrawer: widget.onOpenDrawer,
      ),
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
      floatingActionButton: const AiBotFab(),
    );
  }

  Widget _buildHeader(int active, int students, int teachers) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: "Search branches...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddBranchSheet(context);
                },
                icon: const Icon(Icons.add_business, size: 18),
                label: const Text("Add Branch", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0038FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats cards
          Row(
            children: [
              _buildMiniStat("Branches", "${_branches.length}", Icons.business, const Color(0xFF0038FF)),
              const SizedBox(width: 10),
              _buildMiniStat("Students", "$students", Icons.people, const Color(0xFF10B981)),
              const SizedBox(width: 10),
              _buildMiniStat("Teachers", "$teachers", Icons.school, const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Color(0xFF1E2875), fontSize: 16, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBranchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add New Branch',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(labelText: 'Branch Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Principal Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(labelText: 'Location/Address', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Branch added successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0038FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save Branch', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
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
                      child: Icon(branch['icon'] ?? Icons.school, color: color, size: 22),
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
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _buildBranchStat(Icons.people,
                                "${branch['students']}", "Students")),
                        Expanded(
                            child: _buildBranchStat(Icons.school,
                                "${branch['teachers']}", "Teachers")),
                        Expanded(
                            child: _buildBranchStat(Icons.calendar_today,
                                "Est. ${branch['established']}", "")),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: _buildBranchStat(Icons.person,
                                branch['principal'], "Principal")),
                      ],
                    ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
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
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
