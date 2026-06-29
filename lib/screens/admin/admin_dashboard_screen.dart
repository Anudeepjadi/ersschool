import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/profile_manager.dart';
import '../login/login_screen.dart';
import 'tabs/admin_home_tab.dart';
import 'tabs/admin_students_tab.dart';
import 'tabs/admin_teachers_tab.dart';
import 'tabs/admin_branches_tab.dart';
import 'tabs/admin_more_tab.dart';

// Import all sub-screens
import 'screens/student_management/admin_register_student_screen.dart';
import 'screens/admin_attendance_screen.dart';
import 'screens/admin_fees_screen.dart';
import 'screens/admin_examinations_screen.dart';
import 'screens/admin_meetings_screen.dart';
import 'screens/admin_hostel_screen.dart';
import 'screens/admin_library_screen.dart';
import 'screens/admin_transport_screen.dart';
import 'screens/admin_events_screen.dart';
import 'screens/admin_communications_screen.dart';
import 'screens/admin_id_cards_screen.dart';
import 'screens/admin_certificates_screen.dart';
import 'screens/admin_reports_screen.dart';
import 'screens/admin_class_details_screen.dart';
import 'screens/admin_class_teachers_screen.dart';
import 'screens/admin_assignments_screen.dart';
import 'screens/admin_diary_screen.dart';
import 'screens/admin_time_table_screen.dart';
import 'screens/admin_invalid_info_screen.dart';
import 'screens/admin_sms_screen.dart';
import 'screens/admin_settings_screen.dart';
import 'screens/admin_help_center_screen.dart';
import 'screens/admin_employee_list_screen.dart';
import 'screens/admin_register_employee_screen.dart';
import 'screens/admin_chat_support_screen.dart';
import 'screens/admin_system_updates_screen.dart';
import 'screens/admin_video_tutorials_screen.dart';
import 'screens/admin_about_us_screen.dart';

import 'widgets/admin_bottom_nav_bar.dart';

class AdminDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const AdminDashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AdminTeachersTabState> _teachersTabKey =
      GlobalKey<AdminTeachersTabState>();
  final GlobalKey<AdminExaminationsScreenState> _examinationsKey = GlobalKey<AdminExaminationsScreenState>();
  final GlobalKey<AdminMeetingsScreenState> _meetingsKey = GlobalKey<AdminMeetingsScreenState>();
  bool _isMeetingsExpanded = false;

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
                  builder: (_) => const AdminRegisterStudentScreen()));
        },
        onAddTeacher: () {
          _onTabChanged(2);
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
      drawer: _buildDrawer(),
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

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Custom Header matching the attached screenshot
          Container(
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
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 22),
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
                            backgroundImage:
                                path != null ? FileImage(File(path)) : null,
                            child: path == null
                                ? const Icon(Icons.person,
                                    color: AppColors.primary, size: 36)
                                : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Admin User",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Super Administrator",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.school_outlined,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Ecstasy School 1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // MAIN Section
          _buildDrawerSectionTitle("MAIN"),
          _buildDrawerItem(
              Icons.grid_view_outlined, "Dashboard", currentIndex == 0, () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          }),
          _buildDrawerItem(
              Icons.people_alt_outlined, "Students", currentIndex == 1, () {
            setState(() => currentIndex = 1);
            Navigator.pop(context);
          }),
          _buildDrawerItem(
              Icons.co_present_outlined, "Teachers", currentIndex == 2, () {
            setState(() => currentIndex = 2);
            Navigator.pop(context);
          }),
          _buildDrawerItem(
              Icons.corporate_fare_outlined, "Branches", currentIndex == 3, () {

          // Students Dropdown
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.people_alt_outlined, color: currentIndex == 1 ? AppColors.primary : Color(0xFF757897)),
              title: Text("Students".tr, style: TextStyle(
                color: currentIndex == 1 ? AppColors.primary : Color(0xFF1E2875),
                fontWeight: currentIndex == 1 ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              )),
              childrenPadding: EdgeInsets.only(left: 12),
              children: [
                _buildDrawerSubItem("Students List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentListScreen()));
                }),
                _buildDrawerSubItem("Register New Student", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen()));
                }),
                _buildDrawerSubItem("Student Promotions", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentPromotionsScreen()));
                }),
                _buildDrawerSubItem("Student Siblings", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentSiblingsScreen()));
                }),
                _buildDrawerSubItem("Student ID Cards", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
                }),
              ],
            ),
          ),

          // Employee Dropdown
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.people_outline, color: currentIndex == 2 ? AppColors.primary : Color(0xFF757897)),
              title: Text("Employee".tr, style: TextStyle(
                color: currentIndex == 2 ? AppColors.primary : Color(0xFF1E2875),
                fontWeight: currentIndex == 2 ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              )),
              childrenPadding: EdgeInsets.only(left: 12),
              children: [
                _buildDrawerSubItem("Employees", currentIndex == 2, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Employee')));
                }),
                _buildDrawerSubItem("Teachers", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Teacher')));
                }),
                _buildDrawerSubItem("Add New Teacher", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminRegisterEmployeeScreen(staffType: 'Teacher')));
                }),
                _buildDrawerSubItem("Attender/Aaya", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEmployeeListScreen(staffType: 'Attender')));
                }),
              ],
            ),
          ),

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
          _buildDrawerItem(Icons.calendar_today_outlined, "Attendance", false,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminAttendanceScreen()));
          }),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: false,
              leading: Icon(
                Icons.video_camera_front_outlined,
                color: currentIndex == 6 ? AppColors.primary : const Color(0xFF757897),
              ),
              title: Text(
                "Meetings".tr,
                style: TextStyle(
                  color: currentIndex == 6 ? AppColors.primary : const Color(0xFF1E2875),
                  fontWeight: currentIndex == 6 ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              trailing: Icon(
                _isMeetingsExpanded ? Icons.keyboard_arrow_down : Icons.chevron_right,
                size: 16,
                color: Colors.grey.shade400,
              ),
              childrenPadding: const EdgeInsets.only(left: 12),
              onExpansionChanged: (isExpanded) {
                setState(() {
                  _isMeetingsExpanded = isExpanded;
                });
                if (isExpanded) {
                  _onTabChanged(6);
                  _meetingsKey.currentState?.selectFeature(MeetingsFeature.menu);
                }
              },
              children: [
                _buildDrawerSubItem("Schedule Online Meeting", false, () {
                  _onTabChanged(6);
                  _meetingsKey.currentState?.selectFeature(MeetingsFeature.schedule);
                  Navigator.pop(context);
                }),
                _buildDrawerSubItem("Calendar", false, () {
                  _onTabChanged(6);
                  _meetingsKey.currentState?.selectFeature(MeetingsFeature.calendar);
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
          _buildDrawerItem(Icons.currency_rupee, "Fees", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminFeesScreen()));
          }),
          _buildDrawerItem(Icons.assignment_outlined, "Examination", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => AdminExaminationsScreen()));
          }),
          _buildDrawerItem(Icons.menu_book_outlined, "Library", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminLibraryScreen()));
          }),
          _buildDrawerItem(Icons.directions_bus_outlined, "Transport", false,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminTransportScreen()));
          }),
          _buildDrawerItem(Icons.bed_outlined, "Hostel", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminHostelScreen()));
          }),
          _buildDrawerItem(Icons.event_outlined, "Events", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminEventsScreen()));
          }),
          _buildDrawerItem(Icons.campaign_outlined, "Communications", false,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminCommunicationsScreen()));
          }),
          _buildDrawerItem(Icons.badge_outlined, "ID Card", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
          }),
          _buildDrawerItem(
              Icons.workspace_premium_outlined, "Certificates", false, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminCertificatesScreen()));
          }),
          _buildDrawerItem(Icons.assessment_outlined, "Reports", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminReportsScreen()));
          }),
          _buildDrawerItem(Icons.settings_outlined, "Settings", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminSettingsScreen()));
          }),

          const Divider(height: 20),

          // SUPPORT Section
          _buildDrawerSectionTitle("SUPPORT"),
          _buildDrawerItem(Icons.help_outline, "Help Center", false, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminHelpCenterScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.headset_mic_outlined, "Chat Support", false,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminChatSupportScreen()));
          }, showChevron: false),
          _buildDrawerItem(
              Icons.cloud_download_outlined, "System Updates", false, () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminSystemUpdatesScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.play_circle_outline, "Video Tutorials", false,
              () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AdminVideoTutorialsScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.info_outline, "About Us", false, () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AdminAboutUsScreen()));
          }, showChevron: false),

          const Divider(height: 20),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap, {
    bool showChevron = true,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: selected ? AppColors.primary : const Color(0xFF757897)),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback onTap, {bool showChevron = true}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.primary : Color(0xFF757897)),
        title: Text(title.tr, style: TextStyle(
          color: isSelected ? AppColors.primary : Color(0xFF1E2875),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        )),
        trailing: showChevron ? Icon(Icons.chevron_right, size: 16, color: Colors.grey) : null,
        onTap: onTap,
        dense: true,
      ),
    );
  }

  Widget _buildDrawerSubItem(String title, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title.tr, style: TextStyle(
          color: isSelected ? AppColors.primary : Color(0xFF1E2875),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 12,
        )),
        onTap: onTap,
        dense: true,
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, size: 16, color: Colors.grey)
          : null,
      selected: selected,
      onTap: onTap,
      dense: true,
    );
  }

  Widget _buildDrawerExpansionItem(
    IconData icon,
    String title,
    List<Widget> children,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF757897)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1E2875),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: Colors.grey,
        childrenPadding: const EdgeInsets.only(left: 48),
        children: children,
      ),
    );
  }

  Widget _buildSubDrawerItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1E2875),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
