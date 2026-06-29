import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../login/login_screen.dart';
import '../screens/teacher_my_info_screen.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class TeacherDrawer extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onTabSelected;

  const TeacherDrawer({
    super.key,
    this.currentIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the name and designation from ProfileManager or use defaults
    final currentTeacher = AppDataStore.instance.currentUser;
    final String designation = currentTeacher != null ? currentTeacher['subject'] as String : "Senior Faculty";

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
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
                      child: GestureDetector(
                        onTap: () {
                          // Go to Profile screen
                          Navigator.pop(context); // Close drawer
                          // If we are not already in MyInfoScreen, push it.
                          // But to be safe, we push a new one.
                          Navigator.push(context, MaterialPageRoute(builder: (_) => TeacherMyInfoScreen(
                            onTabSelected: onTabSelected,
                          )));
                        },
                        child: ValueListenableBuilder<String?>(
                          valueListenable: ProfileManager().teacherProfileImagePath,
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
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: ProfileManager().teacherName,
                        builder: (context, tName, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                designation,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("MAIN".tr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),
          
          _buildDrawerItem(
            context,
            icon: Icons.home_outlined,
            title: "Dashboard",
            index: 0,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.class_outlined,
            title: "Classes",
            index: 1,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people_outline,
            title: "Students",
            index: 2,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.assignment_outlined,
            title: "Exams",
            index: 3,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart_outlined,
            title: "Reports",
            index: 4,
          ),
          
          Divider(height: 20),
          
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout".tr, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
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

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required int index}) {
    final isSelected = currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : Color(0xFF757897)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Color(0xFF1E2875),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer
        // If we are NOT in the dashboard, pop the current screen
        if (currentIndex == null || currentIndex! > 4) {
           // We are in a pushed screen, so pop back to Dashboard
           Navigator.pop(context);
        }
        if (onTabSelected != null) {
          onTabSelected!(index);
        }
      },
    );
  }
}
