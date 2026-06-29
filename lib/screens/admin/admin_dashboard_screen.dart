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
import 'screens/admin_attendance_screen.dart';
import 'screens/admin_fees_screen.dart';
import 'screens/admin_examinations_screen.dart';
import 'screens/admin_hostel_screen.dart';
import 'screens/admin_library_screen.dart';
import 'screens/admin_transport_screen.dart';
import 'screens/admin_events_screen.dart';
import 'screens/admin_communications_screen.dart';
import 'screens/admin_id_cards_screen.dart';
import 'screens/admin_certificates_screen.dart';
import 'screens/admin_reports_screen.dart';
import 'screens/admin_sms_screen.dart';
import 'screens/admin_settings_screen.dart';
import 'screens/admin_help_center_screen.dart';
import 'screens/admin_chat_support_screen.dart';
import 'screens/admin_system_updates_screen.dart';
import 'screens/admin_video_tutorials_screen.dart';
import 'screens/admin_about_us_screen.dart';

import 'screens/student_management/admin_student_list_screen.dart';
import 'screens/student_management/admin_register_student_screen.dart';
import 'screens/student_management/admin_student_promotions_screen.dart';
import 'screens/student_management/admin_student_siblings_screen.dart';

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
  bool _isExamExpanded = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
<<<<<<< HEAD
=======
  final GlobalKey _studentsTabKey = GlobalKey();
>>>>>>> parent of da62c40 (Merge branch 'jagan' into Anudeep)
  final GlobalKey<AdminTeachersTabState> _teachersTabKey = GlobalKey<AdminTeachersTabState>();
  final GlobalKey<AdminExaminationsScreenState> _examinationsKey = GlobalKey<AdminExaminationsScreenState>();

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
          _onTabChanged(1);
        },
        onAddTeacher: () {
          _onTabChanged(2);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _teachersTabKey.currentState?.showAddTeacherBottomSheet();
          });
        },
        onTabSelected: _onTabChanged,
      ),
      AdminStudentsTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminTeachersTab(
        key: _teachersTabKey,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminBranchesTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      AdminMoreTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onOpenProfile: () => _onTabChanged(4),
      ),
      AdminExaminationsScreen(
        key: _examinationsKey,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        initialFeature: ExaminationFeature.menu,
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: currentIndex > 4 ? 4 : currentIndex,
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
        physics: BouncingScrollPhysics(),
        children: [
          // Custom Header matching the attached screenshot
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              bottom: 18,
            ),
            decoration: BoxDecoration(
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
                    icon: Icon(Icons.close, color: Colors.white, size: 22),
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
                            child: path == null ? Icon(Icons.person, color: AppColors.primary, size: 36) : null,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: ProfileManager().adminName,
                            builder: (context, name, _) {
                              return Text(
                                name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2),
                          Text("Super Administrator".tr,
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
                SizedBox(height: 16),
                PopupMenuButton<String>(
                  onSelected: (String school) {
                    debugPrint("AdminDashboardScreen drawer selected school: $school");
                    ProfileManager().selectedSchool.value = school;
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Ecstasy School 1',
                      child: Text('Ecstasy School 1'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                    PopupMenuItem<String>(
                      value: 'Ecstasy School 2',
                      child: Text('Ecstasy School 2'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                    PopupMenuItem<String>(
                      value: 'Ecstasy School 3',
                      child: Text('Ecstasy School 3'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: ProfileManager().selectedSchool,
                      builder: (context, selectedSchool, _) {
                        return Row(
                          children: [
                            Icon(Icons.school_outlined, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedSchool,
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
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // MAIN Section
          _buildDrawerSectionTitle("MAIN"),
          _buildDrawerItem(Icons.grid_view_outlined, "Dashboard", currentIndex == 0, () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          }),

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

          // Teachers Dropdown
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.co_present_outlined, color: currentIndex == 2 ? AppColors.primary : Color(0xFF757897)),
              title: Text("Teachers".tr, style: TextStyle(
                color: currentIndex == 2 ? AppColors.primary : Color(0xFF1E2875),
                fontWeight: currentIndex == 2 ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              )),
              childrenPadding: EdgeInsets.only(left: 12),
              children: [
                _buildDrawerSubItem("Teachers List", currentIndex == 2, () {
                  setState(() => currentIndex = 2);
                  Navigator.pop(context);
                }),
                _buildDrawerSubItem("Add New Teacher", false, () {
                  Navigator.pop(context);
                  _onTabChanged(2);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _teachersTabKey.currentState?.showAddTeacherBottomSheet();
                  });
                }),
              ],
            ),
          ),

          _buildDrawerItem(Icons.corporate_fare_outlined, "Branches", currentIndex == 3, () {
            setState(() => currentIndex = 3);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.calendar_today_outlined, "Attendance", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAttendanceScreen()));
          }),
          _buildDrawerItem(Icons.currency_rupee, "Fees", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminFeesScreen()));
          }),
          _buildDrawerItem(Icons.assignment_outlined, "Examination", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminExaminationsScreen()));
          }),
          _buildDrawerItem(Icons.menu_book_outlined, "Library", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminLibraryScreen()));
          }),
          _buildDrawerItem(Icons.directions_bus_outlined, "Transport", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransportScreen()));
          }),
          _buildDrawerItem(Icons.bed_outlined, "Hostel", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHostelScreen()));
          }),
          _buildDrawerItem(Icons.event_outlined, "Events", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEventsScreen()));
          }),
          _buildDrawerItem(Icons.campaign_outlined, "Communications", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminCommunicationsScreen()));
          }),
          _buildDrawerItem(Icons.badge_outlined, "ID Card", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminIDCardsScreen()));
          }),
          _buildDrawerItem(Icons.workspace_premium_outlined, "Certificates", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminCertificatesScreen()));
          }),
          _buildDrawerItem(Icons.assessment_outlined, "Reports", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminReportsScreen()));
          }),
          _buildDrawerItem(Icons.error_outline, "Invalid Info", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminInvalidInfoScreen()));
          }),
          _buildDrawerItem(Icons.sms_outlined, "SMS", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSmsScreen()));
          }),
          _buildDrawerItem(Icons.settings_outlined, "Settings", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSettingsScreen()));
          }),

          Divider(height: 20),

          // SUPPORT Section
          _buildDrawerSectionTitle("SUPPORT"),
          _buildDrawerItem(Icons.help_outline, "Help Center", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminHelpCenterScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.headset_mic_outlined, "Chat Support", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminChatSupportScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.cloud_download_outlined, "System Updates", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSystemUpdatesScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.play_circle_outline, "Video Tutorials", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminVideoTutorialsScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.info_outline, "About Us", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAboutUsScreen()));
          }, showChevron: false),

          Divider(height: 20),
          
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout".tr, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
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
      leading: Icon(icon, color: selected ? AppColors.primary : Color(0xFF757897)),
      title: Text(
        title.tr,
        style: TextStyle(
          color: selected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: showChevron
          ? Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400)
          : null,
      selected: selected,
      onTap: onTap,
      dense: true,
    );
  }
}
