import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
import 'screens/admin_settings_screen.dart';
import 'screens/admin_help_center_screen.dart';
import 'screens/admin_chat_support_screen.dart';
import 'screens/admin_system_updates_screen.dart';
import 'screens/admin_video_tutorials_screen.dart';
import 'screens/admin_about_us_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<AdminStudentsTabState> _studentsTabKey = GlobalKey<AdminStudentsTabState>();
  final GlobalKey<AdminTeachersTabState> _teachersTabKey = GlobalKey<AdminTeachersTabState>();

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
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _studentsTabKey.currentState?.showAddStudentBottomSheet();
          });
        },
        onAddTeacher: () {
          _onTabChanged(2);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _teachersTabKey.currentState?.showAddTeacherBottomSheet();
          });
        },
      ),
      AdminStudentsTab(key: _studentsTabKey),
      AdminTeachersTab(key: _teachersTabKey),
      const AdminBranchesTab(),
      AdminMoreTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF757897),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Students",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.co_present_outlined),
            label: "Teachers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.corporate_fare_outlined),
            label: "Branches",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: "More",
          ),
        ],
      ),
      body: tabs[currentIndex],
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
                colors: [AppColors.primary, Color(0xFF0038FF)],
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
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
                        ),
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
          _buildDrawerItem(Icons.grid_view_outlined, "Dashboard", currentIndex == 0, () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.people_alt_outlined, "Students", currentIndex == 1, () {
            setState(() => currentIndex = 1);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.co_present_outlined, "Teachers", currentIndex == 2, () {
            setState(() => currentIndex = 2);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.corporate_fare_outlined, "Branches", currentIndex == 3, () {
            setState(() => currentIndex = 3);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.calendar_today_outlined, "Attendance", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
          }),
          _buildDrawerItem(Icons.currency_rupee, "Fees", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminFeesScreen()));
          }),
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
          _buildDrawerItem(Icons.badge_outlined, "ID Card", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
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

          // SUPPORT Section
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
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
      leading: Icon(icon, color: selected ? AppColors.primary : const Color(0xFF757897)),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, size: 16, color: Colors.grey)
          : null,
      selected: selected,
      onTap: onTap,
      dense: true,
    );
  }
}
