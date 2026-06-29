import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/profile_manager.dart';
import '../login/login_screen.dart';
import '../class/class_screen.dart';
import '../my_info/my_info_screen.dart';
import 'tabs/home_tab.dart';
import 'tabs/fee_tab.dart';
import 'tabs/exams_tab.dart';
import 'tabs/more_tab.dart';
import '../admin/widgets/ai_bot_fab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTabChanged(int index) {
    if (currentIndex == index) {
      // Pop to first route if tapping on current tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      HomeTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onTabSelected: _onTabChanged,
      ),
      const MyInfoScreen(),
      ClassScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onTabSelected: _onTabChanged,
      ),
      FeeTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onTabSelected: _onTabChanged,
      ),
      ExamsTab(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onTabSelected: _onTabChanged,
      ),
      MoreTab(
        onTabSelected: _onTabChanged,
      ),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final isFirstRouteInCurrentTab = !await _navigatorKeys[currentIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (currentIndex != 0) {
            setState(() => currentIndex = 0);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                currentAccountPicture: ValueListenableBuilder<String?>(
                  valueListenable: ProfileManager().studentProfileImagePath,
                  builder: (context, path, _) {
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: path != null ? FileImage(File(path)) : null,
                      child: path == null ? const Icon(Icons.person, size: 40, color: AppColors.primary) : null,
                    );
                  },
                ),
                accountName: const Text(
                  "Anudeep Jaadi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: const Text("anudeepjaadi@ecstasyschool.com"),
              ),
              _buildDrawerItem(Icons.home, "Home", 0),
              _buildDrawerItem(Icons.person_outline, "My Info", 1),
              _buildDrawerItem(Icons.menu_book, "Class", 2),
              _buildDrawerItem(Icons.currency_rupee, "Fee", 3),
              _buildDrawerItem(Icons.assignment_outlined, "Exams", 4),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: _onTabChanged,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "My Info"),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: "Class"),
              BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: "Fee"),
              BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "Exams"),
              BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
            ],
          ),
        ),
        body: IndexedStack(
          index: currentIndex,
          children: tabs.asMap().entries.map((entry) {
            return Navigator(
              key: _navigatorKeys[entry.key],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => entry.value,
                );
              },
            );
          }).toList(),
        ),
        floatingActionButton: const AiBotFab(),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: currentIndex == index ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          color: currentIndex == index ? AppColors.primary : AppColors.textPrimary,
          fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: currentIndex == index,
      onTap: () {
        _onTabChanged(index);
        Navigator.pop(context);
      },
    );
  }
}
