import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminBranchesTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminBranchesTab({super.key, this.onOpenDrawer});

  @override
  State<AdminBranchesTab> createState() => _AdminBranchesTabState();
}

class _AdminBranchesTabState extends State<AdminBranchesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> get _branches => AppDataStore.instance.branches
      .where((b) => b['school'] == ProfileManager().selectedSchool.value)
      .toList();

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
    return ValueListenableBuilder<String>(
      valueListenable: ProfileManager().selectedSchool,
      builder: (context, school, _) {
        final totalStudents =
            _branches.fold<int>(0, (sum, b) => sum + (b['students'] as int));
        final totalTeachers =
            _branches.fold<int>(0, (sum, b) => sum + (b['teachers'] as int));
        final activeBranches =
            _branches.where((b) => b['status'] == 'Active').length;

        return Scaffold(
          backgroundColor: Color(0xFFF5F7FF),
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
                    ? Center(child: Text("No branches found".tr,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        physics: BouncingScrollPhysics(),
                        itemCount: _filteredBranches.length,
                        itemBuilder: (context, index) {
                          return _buildBranchCard(_filteredBranches[index]);
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: AiBotFab(),
        );
      },
    );
  }

  Widget _buildHeader(int active, int students, int teachers) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(16),
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
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddBranchSheet(context);
                },
                icon: Icon(Icons.add_business, size: 18),
                label: Text("Add Branch".tr, style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0038FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Stats cards
          Row(
            children: [
              _buildMiniStat("Branches", "${_branches.length}", Icons.business, Color(0xFF0038FF)),
              SizedBox(width: 10),
              _buildMiniStat("Students", "$students", Icons.people, Color(0xFF10B981)),
              SizedBox(width: 10),
              _buildMiniStat("Teachers", "$teachers", Icons.school, Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(color: Color(0xFF1E2875), fontSize: 16, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBranchSheet(BuildContext context) {
    final nameController = TextEditingController();
    final principalController = TextEditingController();
    final addressController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
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
              Text('Add New Branch'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Branch Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: principalController,
                decoration: InputDecoration(labelText: 'Principal Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Location/Address', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final principal = principalController.text.trim();
                  final address = addressController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter branch name'.tr)),
                    );
                    return;
                  }
                  final newBranch = {
                    'name': name,
                    'address': address.isEmpty ? 'N/A' : address,
                    'students': 0,
                    'teachers': 0,
                    'status': 'Active',
                    'established': DateTime.now().year.toString(),
                    'principal': principal.isEmpty ? 'TBD' : principal,
                    'color': Color(0xFF0038FF),
                    'icon': Icons.apartment,
                    'school': ProfileManager().selectedSchool.value,
                  };
                  setState(() {
                    AppDataStore.instance.addBranch(newBranch);
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name added successfully!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0038FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Save Branch'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
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
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(branch['icon'] ?? Icons.school, color: color, size: 22),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF1E2875),
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 12, color: Colors.grey.shade500),
                              SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  branch['address'],
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        branch['status'] = isActive ? 'Inactive' : 'Active';
                      }),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isActive ? Color(0xFF10B981) : Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              branch['status'],
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(width: 3),
                            Icon(Icons.swap_horiz, size: 11, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildBranchStat(Icons.people, "${branch['students']}", 'Students')),
                        Expanded(child: _buildBranchStat(Icons.school, "${branch['teachers']}", 'Teachers')),
                        Expanded(child: _buildBranchStat(Icons.calendar_today, 'Est. ${branch['established']}', '')),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildBranchStat(Icons.person, branch['principal'], 'Principal')),
                        GestureDetector(
                          onTap: () => _confirmDelete(branch),
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Color(0xFFEF4444).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                          ),
                        ),
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

  void _confirmDelete(Map<String, dynamic> branch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Delete Branch'.tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${branch['name']}"? This cannot be undone.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel'.tr, style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                AppDataStore.instance.deleteBranch(branch);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${branch['name']} deleted'),
                  backgroundColor: Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Delete'.tr),
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
        SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
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
