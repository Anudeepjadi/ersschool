import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../login/login_screen.dart';
import 'tabs/home_tab.dart';
import 'tabs/my_info_tab.dart';
import 'tabs/class_tab.dart';
import 'tabs/fee_tab.dart';
import 'tabs/exams_tab.dart';
import 'tabs/more_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      HomeTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onTabSelected: _onTabChanged,
      ),
      const MyInfoTab(),
      ClassTab(onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      const FeeTab(),
      const ExamsTab(),
      const MoreTab(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
              accountName: Text(
                "School Admin",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text("admin@ecstasyschool.com"),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text("Home"),
              selected: currentIndex == 0,
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("My Info"),
              selected: currentIndex == 1,
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("Class"),
              selected: currentIndex == 2,
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text("Fee"),
              selected: currentIndex == 3,
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text("Exams"),
              selected: currentIndex == 4,
              onTap: () {
                setState(() => currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF1E2875),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "My Info"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Class"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: "Fee"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
      body: tabs[currentIndex],
    );
  }
}
