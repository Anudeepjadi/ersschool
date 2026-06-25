import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import '../../teacher/teacher_dashboard_screen.dart';
import '../../teacher/screens/students_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminStudentsTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  AdminStudentsTab({super.key, this.onOpenDrawer});

  @override
  State<AdminStudentsTab> createState() => AdminStudentsTabState();
}

class AdminStudentsTabState extends State<AdminStudentsTab> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _classes = [
    'Nursery', 'L.K.G', 'U.K.G', 'Class 1', 'Class 2', 'Class 3', 'Class 4',
    'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'
  ];

  final Map<String, GlobalKey> _classKeys = {};
  String? _expandedClass;

  // Use the shared store — any additions from admin are immediately reflected
  List<Map<String, dynamic>> get _students => AppDataStore.instance.students
      .where((s) => s['school'] == ProfileManager().selectedSchool.value)
      .map((s) {
        final classVal = s['class'] as String? ?? '';
        String normClass = classVal;
        if (classVal == 'LKG') normClass = 'L.K.G';
        if (classVal == 'UKG') normClass = 'U.K.G';
        return {
          ...s,
          'class': normClass,
        };
      })
      .toList();

  List<Map<String, dynamic>> get _filteredStudents {
    return _students.where((s) {
      final matchesFilter = _selectedFilter == 'All' || s['status'] == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          s['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s['class'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    for (var c in _classes) {
      _classKeys[c] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleStatus(Map<String, dynamic> student) {
    setState(() {
      student['status'] = student['status'] == 'Active' ? 'Inactive' : 'Active';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ProfileManager().selectedSchool,
      builder: (context, school, _) {
        final inactiveCount = _students.where((s) => s['status'] == 'Inactive').length;

        return Scaffold(
          backgroundColor: Color(0xFFF5F7FF),
          appBar: AdminAppBar(
            title: "Students",
            subtitle: "Manage 13 standard classes",
            onOpenDrawer: widget.onOpenDrawer,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar and Add Student Button
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
                      hintText: "Search students by name, roll no., admission no. or mobile...",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: showAddStudentBottomSheet,
                  icon: Icon(Icons.add, size: 18),
                  label: Text("Add Student".tr, style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0038FF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All', _selectedFilter == 'All'),
                  SizedBox(width: 8),
                  _buildFilterChip('Active', _selectedFilter == 'Active'),
                  SizedBox(width: 8),
                  _buildFilterChip('Inactive', _selectedFilter == 'Inactive'),
                  SizedBox(width: 8),
                  _buildFilterChip('Passed Out', _selectedFilter == 'Passed Out'),
                  SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, size: 16, color: Colors.grey),
                    label: Text("More Filters".tr, style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Stats Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 140, child: _buildStatCard("Total Students", "${_students.length}", Icons.people, Color(0xFF0038FF), true, "12 this month")),
                  SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Boys", "642", Icons.boy, Color(0xFF10B981), true, "8 this month")),
                  SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Girls", "603", Icons.girl, Color(0xFFEC4899), true, "4 this month")),
                  SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Absent/Inactive", "$inactiveCount", Icons.person_off, Color(0xFFF59E0B), false, "2 this month")),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Classes Expansion List
            Text("Classes Overview (13)".tr,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                final className = _classes[index];
                final classStudents = _filteredStudents.where((s) => s['class'] == className).toList();
                
                return _buildClassExpansionTile(className, classStudents);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: AiBotFab(),
    );
      },
    );
  }

  Widget _buildClassExpansionTile(String className, List<Map<String, dynamic>> students) {
    final isExpanded = _expandedClass == className;

    return Container(
      key: _classKeys[className],
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey('${className}_$isExpanded'),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              if (expanded) {
                _expandedClass = className;
              } else if (_expandedClass == className) {
                _expandedClass = null;
              }
            });
          },
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF0038FF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.class_, color: Color(0xFF0038FF), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                className,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1E2875),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${students.length} Students",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          children: [
            if (students.isEmpty)
              Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: Text("No students found in this class.".tr, style: TextStyle(color: Colors.grey)),
                ),
              )
            else
              Column(
                children: [
                  Divider(height: 1),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: students.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _buildStudentRow(students[index]);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentRow(Map<String, dynamic> student) {
    final isActive = student['status'] == 'Active';
    final avatarColor = student['gender'] == 'Male' ? Color(0xFF0038FF) : Color(0xFFEC4899);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor.withValues(alpha: 0.1),
            child: Text(student['avatar'], style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)), overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.phone, size: 10, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(student['phone'], style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    SizedBox(width: 12),
                    Icon(Icons.tag, size: 10, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(student['roll'].replaceAll("Roll No: ", ""), style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.badge_outlined, size: 10, color: Colors.grey.shade500),
                    SizedBox(width: 4),
                    Text(student['admission'] ?? "ECS000", style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: () => _toggleStatus(student),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFF10B981).withValues(alpha: 0.1) : Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isActive ? Color(0xFF10B981).withValues(alpha: 0.3) : Color(0xFFEF4444).withValues(alpha: 0.3)),
              ),
              child: Text(
                isActive ? "Present" : "Absent",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Color(0xFF10B981) : Color(0xFFEF4444),
                ),
              ),
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF0038FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Color(0xFF0038FF) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Color(0xFF1E2875),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isPositiveTrend, String trendText) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward, size: 10, color: isPositiveTrend ? Colors.green : Colors.red),
              SizedBox(width: 2),
              Text(trendText, style: TextStyle(fontSize: 10, color: isPositiveTrend ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void showAddStudentBottomSheet() {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final phoneController = TextEditingController();
    final admissionController = TextEditingController(text: AppDataStore.instance.getNextAdmissionNo(ProfileManager().selectedSchool.value));
    String selectedClass = 'Class 10';
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
                        Text("Add New Student".tr,
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
                        labelText: "Student Name",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedClass,
                      decoration: InputDecoration(
                        labelText: "Class",
                        prefixIcon: Icon(Icons.class_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedClass = val);
                        }
                      },
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: rollController,
                      decoration: InputDecoration(
                        labelText: "Roll Number (e.g. 05)",
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: admissionController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Admission Number",
                        prefixIcon: Icon(Icons.badge_outlined),
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
                        labelText: "Parent Mobile Number",
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
                            SnackBar(content: Text("Please enter student name".tr)),
                          );
                          return;
                        }
                        final nameWords = nameController.text.trim().split(' ');
                        String avatarStr = 'ST';
                        if (nameWords.isNotEmpty) {
                          if (nameWords.length > 1) {
                            avatarStr = '${nameWords[0][0]}${nameWords[1][0]}'.toUpperCase();
                          } else if (nameWords[0].isNotEmpty) {
                            avatarStr = nameWords[0].substring(0, nameWords[0].length >= 2 ? 2 : 1).toUpperCase();
                          }
                        }
                        
                        final newStudent = {
                          'name': nameController.text.trim(),
                          'class': selectedClass,
                          'roll': 'Roll No: ${rollController.text.trim().isEmpty ? "00" : rollController.text.trim()}',
                          'admission': admissionController.text.trim().isEmpty ? "ECSNEW" : admissionController.text.trim(),
                          'password': admissionController.text.trim().isEmpty ? 'ECSNEW' : admissionController.text.trim(),
                          'status': selectedStatus,
                          'avatar': avatarStr,
                          'phone': phoneController.text.trim().isEmpty ? "N/A" : phoneController.text.trim(),
                          'gender': selectedGender,
                          'school': ProfileManager().selectedSchool.value,
                        };

                        setState(() {
                          AppDataStore.instance.addStudent(newStudent);
                          _expandedClass = selectedClass;
                        });

                        Navigator.pop(modalCtx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Student ${newStudent['name']} added successfully! Redirecting to Teacher Portal..."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Automatically redirect to teachers portal students screen
                        AppDataStore.instance.currentRole = 'teacher';
                        AppDataStore.instance.currentUser = AppDataStore.instance.teachers.first;
                        StudentsScreen.selectedClassOverride = selectedClass;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherDashboardScreen(initialIndex: 2),
                          ),
                        );
                      },
                      child: Text("Save Student".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
