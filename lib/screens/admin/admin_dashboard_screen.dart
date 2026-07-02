import 'package:flutter/material.dart';
import 'tabs/admin_home_tab.dart';
import 'tabs/admin_students_tab.dart';
import 'tabs/admin_teachers_tab.dart';
import 'tabs/admin_branches_tab.dart';
import 'tabs/admin_more_tab.dart';
import 'widgets/admin_drawer.dart';

// Import all sub-screens
import 'screens/student_management/admin_register_student_screen.dart';
import 'screens/admin_register_employee_screen.dart';
<<<<<<< HEAD
import 'screens/admin_chat_support_screen.dart';
import 'screens/admin_system_updates_screen.dart';
import 'screens/admin_video_tutorials_screen.dart';
import 'screens/admin_about_us_screen.dart';
import 'screens/student_management/admin_student_list_screen.dart';
import 'screens/student_management/admin_student_promotions_screen.dart';
import 'screens/student_management/admin_student_siblings_screen.dart';
=======
>>>>>>> Anudeep

import 'widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const AdminDashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      AdminHomeTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onOpenProfile: () => _onTabChanged(4),
        onAddStudent: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AdminRegisterStudentScreen()));
        },
        onAddTeacher: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AdminRegisterEmployeeScreen()));
        },
      ),
      AdminStudentsTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminTeachersTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminBranchesTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminMoreTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onOpenProfile: () => _onTabChanged(4),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: AdminDrawer(
        currentIndex: currentIndex,
        onTabSelected: _onTabChanged,
      ),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: currentIndex,
        onTabSelected: _onTabChanged,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabs,
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildDrawerHeader(),
          _buildDrawerSectionTitle("MAIN"),
          _buildDrawerItem(Icons.grid_view_outlined, "Dashboard", currentIndex == 0, () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          }),
          
          // Students Expansion
          _buildDrawerExpansionItem(Icons.people_alt_outlined, "Students", [
            _buildSubDrawerItem("Students List", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentListScreen()));
            }),
            _buildSubDrawerItem("Register New Student", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen()));
            }),
            _buildSubDrawerItem("Student Promotions", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentPromotionsScreen()));
            }),
            _buildSubDrawerItem("Student Siblings", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentSiblingsScreen()));
            }),
            _buildSubDrawerItem("Student ID Cards", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
            }),
          ]),

          // Employee Expansion
          _buildDrawerExpansionItem(Icons.people_outline, "Employee", [
            _buildSubDrawerItem("Employees", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Employee')));
            }),
            _buildSubDrawerItem("Teachers", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Teacher')));
            }),
            _buildSubDrawerItem("Add New Teacher", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminRegisterEmployeeScreen(staffType: 'Teacher')));
            }),
            _buildSubDrawerItem("Attender/Aaya", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Attender')));
            }),
          ]),

          _buildDrawerItem(Icons.corporate_fare_outlined, "Branches", currentIndex == 3, () {
            setState(() => currentIndex = 3);
            Navigator.pop(context);
          }),

          _buildDrawerExpansionItem(Icons.class_outlined, "Classes", [
            _buildSubDrawerItem("Assignments", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAssignmentsScreen()));
            }),
            _buildSubDrawerItem("Attendance", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
            }),
            _buildSubDrawerItem("Class Details", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassDetailsScreen()));
            }),
            _buildSubDrawerItem("Class Teachers", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassTeachersScreen()));
            }),
            _buildSubDrawerItem("Diary", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDiaryScreen()));
            }),
            _buildSubDrawerItem("Time Table", () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTimeTableScreen()));
            }),
          ]),

          _buildDrawerItem(Icons.assignment_outlined, "Examination", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen()));
          }),
          _buildDrawerItem(Icons.menu_book_outlined, "Library", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLibraryScreen()));
          }),
          _buildDrawerItem(Icons.directions_bus_outlined, "Transport", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTransportScreen()));
          }),
          _buildDrawerItem(Icons.bed_outlined, "Hostel", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminHostelScreen()));
          }),
          _buildDrawerItem(Icons.event_outlined, "Events", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEventsScreen()));
          }),
          _buildDrawerItem(Icons.campaign_outlined, "Communications", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCommunicationsScreen()));
          }),
          _buildDrawerItem(Icons.workspace_premium_outlined, "Certificates", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCertificatesScreen()));
          }),
          _buildDrawerItem(Icons.assessment_outlined, "Reports", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminReportsScreen()));
          }),
          _buildDrawerItem(Icons.settings_outlined, "Settings", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingsScreen()));
          }),

          const Divider(height: 20),
          _buildDrawerSectionTitle("SUPPORT"),
          _buildDrawerItem(Icons.help_outline, "Help Center", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminHelpCenterScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.headset_mic_outlined, "Chat Support", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminChatSupportScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.cloud_download_outlined, "System Updates", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSystemUpdatesScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.play_circle_outline, "Video Tutorials", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminVideoTutorialsScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.info_outline, "About Us", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAboutUsScreen()));
          }, showChevron: false),

          const Divider(height: 20),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text("Logout".tr, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 18,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ValueListenableBuilder<String?>(
                  valueListenable: ProfileManager().adminProfileImagePath,
                  builder: (context, path, _) {
                    return CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      backgroundImage: path != null ? FileImage(File(path)) : null,
                      child: path == null ? const Icon(Icons.person, color: AppColors.primary, size: 36) : null,
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin User", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text("Super Administrator", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school_outlined, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text("Ecstasy School 1", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500))),
                Icon(Icons.keyboard_arrow_down, color: Colors.white.withValues(alpha: 0.7), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.0),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap, {bool showChevron = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.primary : const Color(0xFF757897)),
        title: Text(title.tr, style: TextStyle(
          color: isSelected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        )),
        trailing: showChevron ? const Icon(Icons.chevron_right, size: 16, color: Colors.grey) : null,
        onTap: onTap,
        dense: true,
      ),
    );
  }

  Widget _buildDrawerExpansionItem(IconData icon, String title, List<Widget> children) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF757897)),
        title: Text(title.tr, style: const TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13)),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 12),
        children: children,
      ),
    );
  }

  Widget _buildSubDrawerItem(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 48),
      title: Text(title.tr, style: const TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 12)),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
=======
>>>>>>> Anudeep
}
