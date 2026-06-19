import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';

class EmployeeItem {
  final String name;
  final String id;
  final String role;
  final String department;
  bool isActive;
  final String avatarUrl;

  EmployeeItem({
    required this.name,
    required this.id,
    required this.role,
    required this.department,
    required this.isActive,
    required this.avatarUrl,
  });
}

class EmployeesScreen extends StatefulWidget {
  final int activeTab;
  final Function(int)? onSubTabSelected;
  const EmployeesScreen({super.key, this.activeTab = 0, this.onSubTabSelected});

  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  String searchQuery = "";
  String roleTab = "Employees"; // Employees, Teachers, Attender/Aaya
  int currentPage = 1;
  final int itemsPerPage = 8;

  // Mock list of 56 employees
  late List<EmployeeItem> _employees;

  @override
  void initState() {
    super.initState();
    _employees = [
      EmployeeItem(name: "Ms. Priya Sharma", id: "EMP001", role: "Teacher", department: "Mathematics", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100"),
      EmployeeItem(name: "Mr. Ramesh Kumar", id: "EMP002", role: "Teacher", department: "Science", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100"),
      EmployeeItem(name: "Ms. Neha Verma", id: "EMP003", role: "Teacher", department: "English", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100"),
      EmployeeItem(name: "Mr. Amit Gupta", id: "EMP004", role: "Teacher", department: "Social Studies", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100"),
      EmployeeItem(name: "Ms. Sneha Reddy", id: "EMP005", role: "Teacher", department: "Computer", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100"),
      EmployeeItem(name: "Mr. Sanjay Mehta", id: "EMP006", role: "Accountant", department: "Accounts", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=100"),
      EmployeeItem(name: "Ms. Kavita Singh", id: "EMP007", role: "Librarian", department: "Library", isActive: true, avatarUrl: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=100"),
      EmployeeItem(name: "Mr. Vijay Patel", id: "EMP008", role: "Lab Assistant", department: "Science Lab", isActive: false, avatarUrl: "https://images.unsplash.com/photo-1500048993953-d23a436266cf?w=100"),
    ];

    // Padding items up to 56 total
    for (int i = 9; i <= 56; i++) {
      final isTeacher = i <= 32;
      final role = isTeacher ? "Teacher" : (i <= 52 ? "Staff" : "Attender/Aaya");
      final dept = isTeacher
          ? (i % 3 == 0 ? "Chemistry" : (i % 2 == 0 ? "Physics" : "History"))
          : (i % 2 == 0 ? "Administration" : "Security");

      _employees.add(EmployeeItem(
        name: isTeacher ? "Teacher $i" : "Staff Member $i",
        id: "EMP${i.toString().padLeft(3, '0')}",
        role: role,
        department: dept,
        isActive: i % 14 != 0,
        avatarUrl: "https://images.unsplash.com/photo-${1500000000000 + i}?w=100",
      ));
    }
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final roleController = TextEditingController();
    final deptController = TextEditingController();
    bool isActive = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Add New Employee"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Employee Name"),
                    ),
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(labelText: "Employee ID (e.g. EMP009)"),
                    ),
                    TextField(
                      controller: roleController,
                      decoration: const InputDecoration(labelText: "Role (e.g. Teacher, Accountant)"),
                    ),
                    TextField(
                      controller: deptController,
                      decoration: const InputDecoration(labelText: "Department"),
                    ),
                    Row(
                      children: [
                        const Text("Status: "),
                        Switch(
                          value: isActive,
                          onChanged: (val) {
                            setModalState(() {
                              isActive = val;
                            });
                          },
                        ),
                        Text(isActive ? "Active" : "Inactive"),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        _employees.insert(
                          0,
                          EmployeeItem(
                            name: nameController.text,
                            id: idController.text.isNotEmpty ? idController.text : "EMP${_employees.length + 1}",
                            role: roleController.text.isNotEmpty ? roleController.text : "Teacher",
                            department: deptController.text.isNotEmpty ? deptController.text : "General",
                            isActive: isActive,
                            avatarUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100",
                          ),
                        );
                        currentPage = 1;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${nameController.text} added successfully')),
                      );
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showImportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Import Employees"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select a file to import employee records (CSV or Excel)."),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Selecting file from device...")),
                );
              },
              icon: const Icon(Icons.file_open),
              label: const Text("Choose File"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ],
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Download List"),
        content: const Text("Are you sure you want to download the current employee list?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Downloading employee_list.pdf...")),
              );
            },
            child: const Text("Download"),
          ),
        ],
      ),
    );
  }

  void _showGenerateIDCardsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Generate ID Cards"),
        content: const Text("Generate and bulk download ID cards for all filtered employees?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Generating ID Cards...")),
              );
            },
            child: const Text("Generate"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter employees by search query
    final searchFiltered = _employees.where((emp) {
      return emp.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          emp.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
          emp.department.toLowerCase().contains(searchQuery.toLowerCase()) ||
          emp.role.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    // 2. Filter for display by category tab selection
    final filtered = searchFiltered.where((emp) {
      if (roleTab == "Employees") return true;
      if (roleTab == "Teachers") return emp.role == "Teacher";
      if (roleTab == "Non-Teaching Staff") return emp.role != "Teacher";
      if (roleTab == "Attender/Aaya") return emp.role == "Attender/Aaya";
      if (roleTab == "Inactive") return !emp.isActive;
      return true;
    }).toList();

    // Stats calculations (using searchFiltered so they stay constant across tabs)
    final totalCountDisplay = searchFiltered.length;
    final teachersCountDisplay = searchFiltered.where((emp) => emp.role == "Teacher").length;
    final nonTeachingCountDisplay = searchFiltered.where((emp) => emp.role != "Teacher").length;
    final inactiveCountDisplay = searchFiltered.where((emp) => !emp.isActive).length;

    // Pagination calculations
    final totalCount = filtered.length;
    final totalPages = (totalCount / itemsPerPage).ceil();
    final int safeTotalPages = totalPages == 0 ? 1 : totalPages;
    if (currentPage > safeTotalPages) {
      currentPage = safeTotalPages;
    }
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage > totalCount ? totalCount : startIndex + itemsPerPage;
    final pageItems = filtered.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Sub-tabs bar spacer - since sub-tabs are displayed by CustomHeader, we will let main.dart sync this state.
          // Wait, the page header sub-tabs of employees page in PDF: Employees (active), Teachers, Attender/Aaya.
          // In main.dart we will listen to subTab index changes and update the roleTab! That's perfect!
          const SizedBox(height: 12),

          // 2. Employee Overview Stats (Horizontal scroll)
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Total Employees",
                  value: "$totalCountDisplay",
                  icon: Icons.people_outline,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                  onTap: () => widget.onSubTabSelected?.call(0),
                ),
                StatCard(
                  title: "Teachers",
                  value: "$teachersCountDisplay",
                  icon: Icons.person_add_alt_1_outlined,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  onTap: () => widget.onSubTabSelected?.call(1),
                ),
                StatCard(
                  title: "Non-Teaching Staff",
                  value: "$nonTeachingCountDisplay",
                  icon: Icons.group_outlined,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                  onTap: () => widget.onSubTabSelected?.call(2),
                ),
                StatCard(
                  title: "Inactive",
                  value: "$inactiveCountDisplay",
                  icon: Icons.person_off_outlined,
                  iconColor: Colors.deepPurple,
                  iconBackgroundColor: Colors.red.withValues(alpha: 0.1),
                  onTap: () => widget.onSubTabSelected?.call(4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Employee List Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Employees List ($totalCount)",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddEmployeeDialog,
                  icon: const Icon(Icons.add, size: 14, color: Colors.white),
                  label: const Text("Add Employee", style: TextStyle(fontSize: 12, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Search and Filter Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                          currentPage = 1;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search by name or employee ID",
                        hintStyle: TextStyle(fontSize: 12),
                        prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, size: 18, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Filters clicked")),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. Employees Table View
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 580, // Fixed width for scrollable table effect
                  child: Column(
                    children: [
                      // Table Header Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(flex: 3, child: Text("Employee Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                            Expanded(flex: 2, child: Text("Employee ID", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("Role", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("Department", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                            Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.right)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Colors.grey),
                      // Table Data Rows
                      if (pageItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text("No employees found", style: TextStyle(color: Colors.grey)),
                        )
                      else
                    ...pageItems.map((emp) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
                            ),
                            child: Row(
                              children: [
                                // Employee Name + Avatar
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundImage: NetworkImage(emp.avatarUrl),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          emp.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Employee ID
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.id, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                ),
                                // Role
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.role, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                ),
                                // Department
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.department, style: const TextStyle(fontSize: 12)),
                                ),
                                // Status capsule
                                Expanded(
                                  flex: 2,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          emp.isActive = !emp.isActive;
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${emp.name} is now ${emp.isActive ? 'Active' : 'Inactive'}'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: emp.isActive ? Colors.green[50] : Colors.red[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          emp.isActive ? "Active" : "Inactive",
                                          style: TextStyle(
                                            color: emp.isActive ? Colors.green[800] : Colors.red[800],
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Action Menu Button
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Menu for ${emp.name}')),
                                        );
                                      },
                                      child: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 6. Pagination Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Showing ${startIndex + 1} to $endIndex of $totalCount employees",
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left, size: 18),
                          onPressed: currentPage > 1
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                        ),
                        ...List.generate(safeTotalPages, (index) {
                          final page = index + 1;
                          final isSelected = page == currentPage;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                currentPage = page;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue[800] : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: isSelected ? null : Border.all(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                "$page",
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                        IconButton(
                          icon: const Icon(Icons.arrow_right, size: 18),
                          onPressed: currentPage < safeTotalPages
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 7. Quick Actions Row
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Add Employee", icon: Icons.add_circle_outline, onTap: _showAddEmployeeDialog),
              QuickActionItem(title: "Import Employees", icon: Icons.file_upload_outlined, onTap: _showImportDialog),
              QuickActionItem(title: "Download List", icon: Icons.file_download_outlined, onTap: _showDownloadDialog),
              QuickActionItem(title: "Generate ID Cards", icon: Icons.badge_outlined, onTap: _showGenerateIDCardsDialog),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method for main.dart to filter category sub-tabs
  void setRoleTab(String tabName) {
    setState(() {
      roleTab = tabName;
      currentPage = 1;
    });
  }
}
