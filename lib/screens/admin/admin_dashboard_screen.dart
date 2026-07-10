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

}
