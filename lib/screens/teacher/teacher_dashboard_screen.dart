import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/profile_manager.dart';
import '../login/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/classes_screen.dart';
import 'screens/students_screen.dart';
import 'screens/exams_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/more_screen.dart';
import 'screens/meetings_screen.dart';
import 'screens/employees_screen.dart';
import '../student/calendar/calendar_screen.dart';
import 'widgets/teacher_app_bar.dart';
import 'screens/teacher_my_info_screen.dart';
import '../admin/widgets/ai_bot_fab.dart';
import 'widgets/teacher_drawer.dart';
import 'widgets/teacher_bottom_nav.dart';
class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int currentIndex = 0;
  int classesActiveTab = 0;
  int studentsActiveTab = 0;
  int examsActiveTab = 0;
  int reportsActiveTab = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _onNavigateTab(int index, {int? subTab, String? moreSubScreen}) {
    if (index >= 0 && index < 6) {
      if (subTab != null) {
        setState(() {
          if (index == 1) classesActiveTab = subTab;
          if (index == 2) studentsActiveTab = subTab;
          if (index == 3) examsActiveTab = subTab;
          if (index == 4) reportsActiveTab = subTab;
        });
      }
      
      if (index == 5 && moreSubScreen != null) {
        if (moreSubScreen == "Meetings") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MeetingsScreen(activeTab: subTab ?? 0, onSubTabSelected: _onTabChanged)));
          return;
        } else if (moreSubScreen == "Employees") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeesScreen(activeTab: subTab ?? 0, onSubTabSelected: _onTabChanged)));
          return;
        } else if (moreSubScreen == "Calendar") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CalendarScreen()));
          return;
        }
      }
      _onTabChanged(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      HomeScreen(
        onNavigateTab: _onNavigateTab,
      ),
      ClassesScreen(key: ValueKey('classes_$classesActiveTab'), activeTab: classesActiveTab),
      StudentsScreen(key: ValueKey('students_$studentsActiveTab'), activeTab: studentsActiveTab, onSubTabSelected: (index) {}),
      ExamsScreen(key: ValueKey('exams_$examsActiveTab'), activeTab: examsActiveTab),
      ReportsScreen(key: ValueKey('reports_$reportsActiveTab'), activeTab: reportsActiveTab),
      MoreScreen(onOptionSelected: (title) {
        if (title == "Meetings") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MeetingsScreen(onSubTabSelected: _onTabChanged)));
        } else if (title == "Employees") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeesScreen(onSubTabSelected: _onTabChanged)));
        }
      }),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: TeacherAppBar(
        title: "Welcome Teacher 👋",
        subtitle: "Here's your schedule for today.",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onProfileTap: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherMyInfoScreen(
            onTabSelected: (idx) {
              _onTabChanged(idx);
            },
          )));
          if (result == 'openDrawer') {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
      ),
      drawer: TeacherDrawer(currentIndex: currentIndex, onTabSelected: _onTabChanged),
      bottomNavigationBar: TeacherBottomNav(currentIndex: currentIndex, onTabSelected: _onTabChanged),
      body: IndexedStack(
        index: currentIndex,
        children: tabs,
      ),
      floatingActionButton: const AiBotFab(),
    );
  }
}
