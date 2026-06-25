import 'package:flutter/material.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/teacher_app_bar.dart';
import '../widgets/teacher_drawer.dart';
import '../widgets/teacher_bottom_nav.dart';
import 'package:ersschool/core/localization/language_manager.dart';

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
  EmployeesScreen({super.key, this.activeTab = 0, this.onSubTabSelected});

  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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

    // Padding items to reach: 10 Teachers, 10 Non-teaching, 5 Attenders (Total 25)
    for (int i = 9; i <= 25; i++) {
      String role;
      String dept;
      String name;

      if (i <= 13) {
        // 5 more teachers -> total 10
        role = "Teacher";
        dept = (i % 2 == 0) ? "Physics" : "Chemistry";
        name = "Teacher $i";
      } else if (i <= 20) {
        // 7 more non-teaching -> total 10
        role = "Staff";
        dept = (i % 2 == 0) ? "Administration" : "IT Support";
        name = "Staff Member $i";
      } else {
        // 5 attenders -> total 5
        role = "Attender/Aaya";
        dept = "Support Staff";
        name = "Attender $i";
      }

      _employees.add(EmployeeItem(
        name: name,
        id: "EMP${i.toString().padLeft(3, '0')}",
        role: role,
        department: dept,
        isActive: i % 7 != 0, // Make a couple inactive just for variety
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
              title: Text("Add New Employee".tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Employee Name"),
                    ),
                    TextField(
                      controller: idController,
                      decoration: InputDecoration(labelText: "Employee ID (e.g. EMP009)"),
                    ),
                    TextField(
                      controller: roleController,
                      decoration: InputDecoration(labelText: "Role (e.g. Teacher, Accountant)"),
                    ),
                    TextField(
                      controller: deptController,
                      decoration: InputDecoration(labelText: "Department"),
                    ),
                    Row(
                      children: [
                        Text("Status: ".tr),
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
                  child: Text("Cancel".tr),
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
                  child: Text("Add".tr),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.activeTab > 3 ? 0 : widget.activeTab,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF5F7FF),
        appBar: TeacherAppBar(
          title: "Employees Directory",
          subtitle: "Manage all school staff",
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: TeacherDrawer(
          currentIndex: 5,
          onTabSelected: widget.onSubTabSelected,
        ),
        bottomNavigationBar: TeacherBottomNav(
          currentIndex: 5,
          onTabSelected: (idx) {
            Navigator.pop(context); // Close EmployeesScreen
            if (widget.onSubTabSelected != null) {
              widget.onSubTabSelected!(idx);
            }
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: Colors.white,
              elevation: 1,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                dividerColor: Colors.transparent,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(text: "All Staff"),
                  Tab(text: "Teaching"),
                  Tab(text: "Non-Teaching"),
                  Tab(text: "Admin"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmployeeListContent(context),
                  _buildEmployeeListContent(context),
                  _buildEmployeeListContent(context),
                  _buildEmployeeListContent(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeListContent(BuildContext context) {
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
          SizedBox(height: 12),

          // 2. Employee Overview Stats (Horizontal scroll)
          SizedBox(
            height: 135,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Total Employees",
                  value: _employees.length.toString(),
                  icon: Icons.people_outline,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "On Leave Today",
                  value: "8",
                  icon: Icons.person_off_outlined,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "New Hires",
                  value: "5",
                  icon: Icons.person_add_alt_1_outlined,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Open Positions",
                  value: "2",
                  icon: Icons.work_outline,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // 3. Employee List Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Employees List ($totalCount)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddEmployeeDialog,
                  icon: Icon(Icons.add, size: 14, color: Colors.white),
                  label: Text("Add Employee".tr, style: TextStyle(fontSize: 12, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // 4. Search and Filter Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      decoration: InputDecoration(
                        hintText: "Search by name or employee ID",
                        hintStyle: TextStyle(fontSize: 12),
                        prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.tune, size: 18, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Filters clicked".tr)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // 5. Employees Table View
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ScrollableTableWrapper(
                child: SizedBox(
                  width: 580, // Fixed width for scrollable table effect
                  child: Column(
                    children: [
                      // Table Header Row
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(children: [
                            Expanded(flex: 3, child: Text("Employee Name".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                            Expanded(flex: 2, child: Text("Employee ID".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("Role".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("Department".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey))),
                            Expanded(flex: 2, child: Text("Status".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                            Expanded(flex: 1, child: Text("Action".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey), textAlign: TextAlign.right)),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey),
                      // Table Data Rows
                      if (pageItems.isEmpty)
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text("No employees found".tr, style: TextStyle(color: Colors.grey)),
                        )
                      else
                    ...pageItems.map((emp) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                                      Expanded(
                                        child: Text(
                                          emp.name,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Employee ID
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.id, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                ),
                                // Role
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.role, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
                                ),
                                // Department
                                Expanded(
                                  flex: 2,
                                  child: Text(emp.department, style: TextStyle(fontSize: 12)),
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
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                      child: Icon(Icons.more_vert, size: 18, color: Colors.grey),
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
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Showing ${startIndex + 1} to $endIndex of $totalCount employees",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_left, size: 18),
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
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                          icon: Icon(Icons.arrow_right, size: 18),
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
              QuickActionItem(title: "Approve Leave", icon: Icons.event_available, onTap: () {}),
              QuickActionItem(title: "Run Payroll", icon: Icons.payments_outlined, onTap: () {}),
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
