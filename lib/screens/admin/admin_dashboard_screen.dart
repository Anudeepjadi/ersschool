import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../login/login_screen.dart';
import 'tabs/admin_home_tab.dart';
import 'tabs/admin_students_tab.dart';
import 'tabs/admin_teachers_tab.dart';
import 'tabs/admin_branches_tab.dart';
import 'tabs/admin_more_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      ),
      const AdminStudentsTab(),
      const AdminTeachersTab(),
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
        unselectedItemColor: const Color(0xFF1E2875),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "Students",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: "Teachers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child:
                  Icon(Icons.admin_panel_settings, size: 40, color: AppColors.primary),
            ),
            accountName: Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text("admin@ecstasyschool.com"),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: AppColors.primary),
            title: const Text("Dashboard"),
            selected: currentIndex == 0,
            onTap: () {
              setState(() => currentIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Students"),
            selected: currentIndex == 1,
            onTap: () {
              setState(() => currentIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text("Teachers"),
            selected: currentIndex == 2,
            onTap: () {
              setState(() => currentIndex = 2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text("Branches"),
            selected: currentIndex == 3,
            onTap: () {
              setState(() => currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title:
                const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
