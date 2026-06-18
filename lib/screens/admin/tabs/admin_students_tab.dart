import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../screens/admin_chat_support_screen.dart';

class AdminStudentsTab extends StatefulWidget {
  const AdminStudentsTab({super.key});

  @override
  State<AdminStudentsTab> createState() => AdminStudentsTabState();
}

class AdminStudentsTabState extends State<AdminStudentsTab> {
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
    final inactiveCount = _students.where((s) => s['status'] == 'Inactive').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
        title: "Students",
        subtitle: "",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: showAddStudentBottomSheet,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Add Student", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0038FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Filter Chips Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('All', _selectedFilter == 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', _selectedFilter == 'Active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Inactive', _selectedFilter == 'Inactive'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Passed Out', _selectedFilter == 'Passed Out'),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list, size: 16, color: Colors.grey),
                    label: const Text("More Filters", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  SizedBox(width: 140, child: _buildStatCard("Total Students", "${_students.length}", Icons.people, const Color(0xFF0038FF), true, "12 this month")),
                  const SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Boys", "642", Icons.boy, const Color(0xFF10B981), true, "8 this month")),
                  const SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Girls", "603", Icons.girl, const Color(0xFFEC4899), true, "4 this month")),
                  const SizedBox(width: 12),
                  SizedBox(width: 140, child: _buildStatCard("Inactive", "$inactiveCount", Icons.person_off, const Color(0xFFF59E0B), false, "2 this month")),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Student List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student List (${_students.length})",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16, color: Colors.grey),
                      label: const Text("Export", style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Sort By',
                        icon: const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        items: ['Sort By'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Data Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: 800, // Fixed width to enable horizontal scrolling and prevent overflow
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // Table Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          const Expanded(flex: 3, child: Text("Student", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const Expanded(flex: 2, child: Text("Class", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const Expanded(flex: 2, child: Text("Roll No.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const Expanded(flex: 2, child: Text("Admission No.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const Expanded(flex: 2, child: Text("Status", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                          const Expanded(flex: 1, child: Text("Action", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey))),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    // Table Rows
                    ..._filteredStudents.map((s) => _buildTableRow(s)),
                    // Pagination
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Showing 1 to ${_filteredStudents.length} of ${_students.length} entries", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Row(
                            children: [
                              const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                              const SizedBox(width: 8),
                              _buildPageButton("1", true),
                              _buildPageButton("2", false),
                              _buildPageButton("3", false),
                              const Text("...", style: TextStyle(color: Colors.grey)),
                              _buildPageButton("125", false),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminChatSupportScreen()));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.smart_toy, color: Color(0xFF0038FF), size: 30),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0038FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0038FF) : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF1E2875),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isPositiveTrend, String trendText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isPositiveTrend ? Icons.arrow_upward : Icons.arrow_upward, size: 10, color: isPositiveTrend ? Colors.green : Colors.red),
              const SizedBox(width: 2),
              Text(trendText, style: TextStyle(fontSize: 10, color: isPositiveTrend ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(String page, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0038FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        page,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> student) {
    final isActive = student['status'] == 'Active';
    final avatarColor = student['gender'] == 'Male' ? const Color(0xFF0038FF) : const Color(0xFFEC4899);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: avatarColor.withValues(alpha: 0.1),
                      child: Text(student['avatar'], style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                          const SizedBox(height: 2),
                          Text("${student['name'].split(' ')[0].toLowerCase()}@email.com\n${student['phone']}", style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 2, child: Text(student['class'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
              Expanded(flex: 2, child: Text(student['roll'].replaceAll("Roll No: ", ""), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
              const Expanded(flex: 2, child: Text("ECS00123", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.transparent : const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        student['status'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isActive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1, child: IconButton(icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey), onPressed: () {})),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  void showAddStudentBottomSheet() {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    bool allowPhoneLogin = true;
    String selectedClass = 'Class 10-A';
    String selectedGender = 'Male';
    String selectedStatus = 'Active';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                        const Text(
                          "Add New Student",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Student Name",
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedClass,
                      decoration: const InputDecoration(
                        labelText: "Class",
                        prefixIcon: Icon(Icons.class_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      items: ['Class 10-A', 'Class 10-B', 'Class 9-A', 'Class 9-B', 'Class 8-A', 'Class 8-B', 'Class 7-A', 'Class 7-B', 'Class 6-A']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedClass = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: rollController,
                      decoration: const InputDecoration(
                        labelText: "Roll Number (e.g. 05)",
                        prefixIcon: Icon(Icons.tag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Parent Mobile Number",
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Login Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      title: const Text("Allow Login with Phone Number", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                      value: allowPhoneLogin,
                      onChanged: (val) {
                        setModalState(() => allowPhoneLogin = val);
                      },
                      activeTrackColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Gender",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text("Male")),
                            selected: selectedGender == 'Male',
                            onSelected: (val) {
                              if (val) setModalState(() => selectedGender = 'Male');
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text("Female")),
                            selected: selectedGender == 'Female',
                            onSelected: (val) {
                              if (val) setModalState(() => selectedGender = 'Female');
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter student name")),
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
                          'status': selectedStatus,
                          'avatar': avatarStr,
                          'phone': phoneController.text.trim().isEmpty ? "N/A" : phoneController.text.trim(),
                          'password': passwordController.text.trim(),
                          'phoneLoginEnabled': allowPhoneLogin,
                          'gender': selectedGender,
                        };

                        setState(() {
                          _students.insert(0, newStudent);
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Student ${newStudent['name']} added successfully!"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text("Save Student", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    const SizedBox(height: 10),
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
