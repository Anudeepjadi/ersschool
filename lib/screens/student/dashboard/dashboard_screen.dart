import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../login/login_screen.dart';
import '../class/class_screen.dart';
import '../my_info/my_info_screen.dart';
import 'tabs/home_tab.dart';
import 'tabs/fee_tab.dart';
import 'tabs/exams_tab.dart';
import 'tabs/more_tab.dart';
import '../../admin/widgets/ai_bot_fab.dart';
import 'package:ersschool/core/localization/language_manager.dart';

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
      MyInfoScreen(
        onTabSelected: _onTabChanged,
      ),
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

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Color(0xFF757897),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: _onTabChanged,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "My Info"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: "Class"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee_outlined), activeIcon: Icon(Icons.currency_rupee), label: "Fee"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
      body: tabs[currentIndex],
      floatingActionButton: AiBotFab(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Unified Custom Header matching Admin Dashboard
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
                        valueListenable: ProfileManager().studentProfileImagePath,
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
                            valueListenable: ProfileManager().studentName,
                            builder: (context, studentName, _) {
                              return Text(
                                studentName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2),
                          ValueListenableBuilder<String>(
                            valueListenable: ProfileManager().studentEmail,
                            builder: (context, studentEmail, _) {
                              return Text(
                                studentEmail,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // MAIN Section
          _buildDrawerSectionTitle("MAIN"),
          _buildDrawerItem(Icons.home_outlined, "Home", currentIndex == 0, () {
            setState(() => currentIndex = 0);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.person_outline, "My Info", currentIndex == 1, () {
            setState(() => currentIndex = 1);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.menu_book_outlined, "Class", currentIndex == 2, () {
            setState(() => currentIndex = 2);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.currency_rupee_outlined, "Fee", currentIndex == 3, () {
            setState(() => currentIndex = 3);
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.assignment_outlined, "Exams", currentIndex == 4, () {
            setState(() => currentIndex = 4);
            Navigator.pop(context);
          }),
          
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
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : Color(0xFF1E2875),
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: showChevron
          ? Icon(Icons.chevron_right, size: 16, color: Colors.grey)
          : null,
      selected: selected,
      onTap: onTap,
      dense: true,
    );
  }
}
