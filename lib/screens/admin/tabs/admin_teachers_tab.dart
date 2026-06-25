import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import 'package:ersschool/core/localization/language_manager.dart';
class AdminTeachersTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  AdminTeachersTab({super.key, this.onOpenDrawer});

  @override
  State<AdminTeachersTab> createState() => AdminTeachersTabState();
}

class AdminTeachersTabState extends State<AdminTeachersTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Use the shared store
  List<Map<String, dynamic>> get _teachers => AppDataStore.instance.teachers
      .where((t) => t['school'] == ProfileManager().selectedSchool.value)
      .toList();

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
    return ValueListenableBuilder<String>(
      valueListenable: ProfileManager().selectedSchool,
      builder: (context, school, _) {
        final activeCount = _teachers.where((t) => t['status'] == 'Active').length;
        final inactiveCount = _teachers.where((t) => t['status'] == 'Inactive').length;

        return Scaffold(
          backgroundColor: Color(0xFFF5F7FF),
          appBar: AdminAppBar(
            title: "Teachers",
            subtitle: "Manage all teaching staff",
            onOpenDrawer: widget.onOpenDrawer,
          ),
          body: Column(
            children: [
          _buildHeader(activeCount, inactiveCount),
          _buildFilterRow(),
          Expanded(
            child: _filteredTeachers.isEmpty
                ? Center(child: Text("No teachers found".tr,
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: BouncingScrollPhysics(),
                    itemCount: _filteredTeachers.length,
                    itemBuilder: (context, index) {
                      return _buildTeacherCard(_filteredTeachers[index]);
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

  Widget _buildHeader(int active, int inactive) {
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
                    hintText: "Search teachers by name or subject...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: showAddTeacherBottomSheet,
                icon: Icon(Icons.person_add, size: 18),
                label: Text("Add Teacher".tr, style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildMiniStat("Total", "${_teachers.length}", Icons.school, Color(0xFF0038FF)),
              SizedBox(width: 10),
              _buildMiniStat("Active", "$active", Icons.check_circle, Color(0xFF10B981)),
              SizedBox(width: 10),
              _buildMiniStat("Inactive", "$inactive", Icons.event_busy, Color(0xFFF59E0B)),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(color: Color(0xFF1E2875), fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 10), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterButton('All'),
          SizedBox(width: 8),
          _buildFilterButton('Active'),
          SizedBox(width: 8),
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        ? Color(0xFF0038FF)
        : Color(0xFFEC4899);

    // Color-code subjects
    final subjectColors = {
      'Mathematics': Color(0xFF8B5CF6),
      'English': Color(0xFF3B82F6),
      'Physics': Color(0xFFF59E0B),
      'Chemistry': Color(0xFF10B981),
      'Computer Science': Color(0xFFEF4444),
      'Hindi': Color(0xFFEC4899),
      'Social Studies': Color(0xFF6366F1),
      'Biology': Color(0xFF14B8A6),
      'Physical Education': Color(0xFFF97316),
      'Art & Craft': Color(0xFFD946EF),
    };
    final subjectColor = subjectColors[teacher['subject']] ?? AppColors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showTeacherDetailsDialog(teacher),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
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
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1E2875),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: subjectColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              teacher['subject'],
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: subjectColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            teacher['department'],
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      "${teacher['experience']}  |  ${teacher['phone']}",
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => teacher['status'] = isActive ? 'Inactive' : 'Active'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.swap_horiz, size: 12, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTeacherDetailsDialog(Map<String, dynamic> teacher) {
    final isActive = teacher['status'] == 'Active';
    final themeColor = teacher['gender'] == 'Male'
        ? Color(0xFF0038FF)
        : Color(0xFFEC4899);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Teacher Profile".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 36,
                  backgroundColor: themeColor.withValues(alpha: 0.1),
                  child: Text(
                    teacher['avatar'],
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  teacher['name'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Color(0xFF10B981).withValues(alpha: 0.1)
                        : Color(0xFFF59E0B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    teacher['status'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Color(0xFF10B981) : Color(0xFFF59E0B),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow(Icons.menu_book_outlined, "Subject", teacher['subject']),
                Divider(height: 14),
                _buildDetailRow(Icons.apartment, "Department", teacher['department']),
                Divider(height: 14),
                _buildDetailRow(Icons.timeline, "Experience", teacher['experience']),
                Divider(height: 14),
                _buildDetailRow(Icons.phone_outlined, "Phone", teacher['phone']),
                Divider(height: 14),
                _buildDetailRow(Icons.face_outlined, "Gender", teacher['gender']),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Color(0xFF0038FF)),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
      ],
    );
  }

  void showAddTeacherBottomSheet() {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    final subjectController = TextEditingController();
    final experienceController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedDept = 'Science';
    String selectedGender = 'Male';
    String selectedStatus = 'Active';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Add New Teacher".tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(modalCtx),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Teacher Name",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: "Employee Code (e.g. ECS00E11)",
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: subjectController,
                      decoration: InputDecoration(
                        labelText: "Subject (e.g. Mathematics)",
                        prefixIcon: Icon(Icons.menu_book_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedDept,
                      decoration: InputDecoration(
                        labelText: "Department",
                        prefixIcon: Icon(Icons.apartment),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: ['Science', 'Languages', 'Technology', 'Sports', 'Creative Arts', 'Humanities']
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedDept = val);
                        }
                      },
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: experienceController,
                      decoration: InputDecoration(
                        labelText: "Experience (e.g. 8 years)",
                        prefixIcon: Icon(Icons.timeline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Gender".tr,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text("Male".tr)),
                            selected: selectedGender == 'Male',
                            onSelected: (val) {
                              if (val) setModalState(() => selectedGender = 'Male');
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text("Female".tr)),
                            selected: selectedGender == 'Female',
                            onSelected: (val) {
                              if (val) setModalState(() => selectedGender = 'Female');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: InputDecoration(
                        labelText: "Status",
                        prefixIcon: Icon(Icons.info_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: ['Active', 'Inactive']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedStatus = val);
                        }
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter teacher name".tr)),
                          );
                          return;
                        }
                        if (subjectController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please enter subject".tr)),
                          );
                          return;
                        }
                        
                        final nameWords = nameController.text.trim().split(' ');
                        String avatarStr = 'TR';
                        if (nameWords.isNotEmpty) {
                          if (nameWords.length > 1) {
                            avatarStr = '${nameWords[0][0]}${nameWords[1][0]}'.toUpperCase();
                          } else if (nameWords[0].isNotEmpty) {
                            avatarStr = nameWords[0].substring(0, nameWords[0].length >= 2 ? 2 : 1).toUpperCase();
                          }
                        }

                        final code = codeController.text.trim().isEmpty
                            ? 'ECS00E${(AppDataStore.instance.teachers.length + 1).toString().padLeft(2, '0')}'
                            : codeController.text.trim();

                        final newTeacher = {
                          'name': nameController.text.trim(),
                          'subject': subjectController.text.trim(),
                          'department': selectedDept,
                          'status': selectedStatus,
                          'avatar': avatarStr,
                          'phone': phoneController.text.trim().isEmpty ? "N/A" : phoneController.text.trim(),
                          'experience': experienceController.text.trim().isEmpty ? "1 year" : experienceController.text.trim(),
                          'gender': selectedGender,
                          'employeeCode': code,
                          'password': code,
                          'school': ProfileManager().selectedSchool.value,
                        };

                        setState(() {
                          AppDataStore.instance.addTeacher(newTeacher);
                        });

                        Navigator.pop(modalCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Teacher ${newTeacher['name']} added! Login with: $code"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text("Save Teacher".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

