import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../widgets/admin_app_bar.dart';
import 'admin_register_employee_screen.dart';
import 'admin_employee_details_screen.dart';

class AdminEmployeeListScreen extends StatefulWidget {
  final String staffType; // 'Employee' | 'Teacher' | 'Attender'
  const AdminEmployeeListScreen({super.key, this.staffType = 'Employee'});

  @override
  State<AdminEmployeeListScreen> createState() => _AdminEmployeeListScreenState();
}

class _AdminEmployeeListScreenState extends State<AdminEmployeeListScreen> {
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

  List<Map<String, dynamic>> get _allEmployees {
    final list = AppDataStore.instance.teachers.toList();
    if (widget.staffType == 'Teacher') {
      return list.where((e) {
        final dept = (e['department'] ?? '').toString().toLowerCase();
        return dept.contains('teacher') || 
               (['science', 'languages', 'technology', 'sports', 'creative arts', 'humanities'].contains(dept));
      }).toList();
    } else if (widget.staffType == 'Attender') {
      return list.where((e) {
        final dept = (e['department'] ?? '').toString().toLowerCase();
        return dept.contains('attender') || dept.contains('aaya');
      }).toList();
    } else {
      return list.where((e) {
        final dept = (e['department'] ?? '').toString().toLowerCase();
        return dept.contains('admin') || dept.contains('accountant') || dept.contains('employee');
      }).toList();
    }
  }

  List<Map<String, dynamic>> get _filteredEmployees {
    final filtered = _allEmployees.where((emp) {
      final matchesBranch = _selectedBranch == 'All' || emp['school'] == _selectedBranch;
      final matchesStatus = _activeStatusFilter == 'All' || emp['status'] == _activeStatusFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          emp['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (emp['employeeCode'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesBranch && matchesStatus && matchesSearch;
    }).toList();

    // Limit to 10 employees as requested
    return filtered.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
        title: "Employee Management",
        subtitle: "View and manage all staff members",
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. Centered Title (Layout from image, Theme from App)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              color: Colors.white,
              child: Center(
                child: Text(
                  widget.staffType == 'Attender' ? "Attender/Aaya List" : "${widget.staffType} List",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875), // Using app's primary text color
                  ),
                ),
              ),
            ),

            // 2. Control Row (Branch Dropdown & Add New Button)
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
                        MaterialPageRoute(builder: (_) => AdminRegisterEmployeeScreen(staffType: widget.staffType))
                      );
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
                    hintText: "Search by name or code...",
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

            // 4. Employee Card List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _filteredEmployees.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text("No employees found", style: TextStyle(color: Colors.grey)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredEmployees.length,
                      itemBuilder: (context, index) {
                        return _buildEmployeeCard(_filteredEmployees[index]);
                      },
                    ),
            ),

            // 5. Pagination Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const Text("Items per page: ", style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("25", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      Text("1 - ${_filteredEmployees.length} of ${_filteredEmployees.length}", 
                           style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.first_page, size: 18, color: Colors.grey),
                      const Icon(Icons.chevron_left, size: 18, color: Colors.grey),
                      const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                      const Icon(Icons.last_page, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(Map<String, dynamic> emp) {
    final isActive = emp['status'] == 'Active';

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
        onTap: () => _showEmployeeDetailsDialog(emp),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  emp['avatar'] ?? 'E',
                  style: const TextStyle(
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
                      emp['name'] ?? 'N/A',
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
                            emp['subject'] ?? 'Staff',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ),
                        Text(
                          emp['department'] ?? 'Employee',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "15 years  |  ${emp['phone'] ?? 'N/A'}",
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
                        emp['status'] = isActive ? 'Inactive' : 'Active';
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
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeDetailsScreen(employee: emp)));
                      }),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.edit, Colors.blue, size: 14, onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AdminRegisterEmployeeScreen(employee: emp))).then((_) => setState(() {}));
                      }),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.delete, Colors.red, size: 14, onTap: () => _confirmDelete(emp)),
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
    final total = _allEmployees.length;
    final active = _allEmployees.where((e) => e['status'] == 'Active').length;
    final inactive = _allEmployees.where((e) => e['status'] == 'Inactive').length;

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

  void _confirmDelete(Map<String, dynamic> emp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete", style: TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete ${emp['name']}?", style: const TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                AppDataStore.instance.teachers.remove(emp);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${emp['name']} deleted successfully"),
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

  void _showEmployeeDetailsDialog(Map<String, dynamic> emp) {
    final isActive = emp['status'] == 'Active';
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E2843),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Teacher Profile", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white24),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  emp['avatar'] ?? 'E',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                emp['name'] ?? 'N/A',
                style: const TextStyle(color: AppColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isActive ? const Color(0xFF10B981) : Colors.orange).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    fontSize: 10, 
                    fontWeight: FontWeight.bold, 
                    color: isActive ? const Color(0xFF10B981) : Colors.orange
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileRow(Icons.menu_book_outlined, "Subject", emp['subject'] ?? 'N/A'),
              const Divider(color: Colors.white12, height: 24),
              _buildProfileRow(Icons.apartment, "Department", emp['department'] ?? 'N/A'),
              const Divider(color: Colors.white12, height: 24),
              _buildProfileRow(Icons.timeline, "Experience", "15 years"),
              const Divider(color: Colors.white12, height: 24),
              _buildProfileRow(Icons.phone_outlined, "Phone", emp['phone'] ?? 'N/A'),
              const Divider(color: Colors.white12, height: 24),
              _buildProfileRow(Icons.face_outlined, "Gender", emp['gender'] ?? 'Male'),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
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
