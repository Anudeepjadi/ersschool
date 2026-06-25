import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/profile_manager.dart';
import '../../../../core/data/app_data_store.dart';
import '../../my_info/my_info_screen.dart';
import '../widgets/student_app_bar.dart';
import '../../../login/login_screen.dart';
import '../../transport/transport_screen.dart';
import '../../calendar/calendar_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class MoreTab extends StatelessWidget {
  final Function(int)? onTabSelected;

  MoreTab({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: StudentAppBar(
        title: "More",
        subtitle: "Settings and additional options",
        onOpenDrawer: () => Scaffold.of(context).openDrawer(),
        onProfileTap: onTabSelected != null ? () => onTabSelected!(1) : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),

            // Profile Info Section
            _buildProfileSection(context),

            SizedBox(height: 24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick links section
                  _sectionTitle('Quick Links'),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.directions_bus_outlined,
                          label: 'Transport',
                          color: Colors.indigo,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TransportScreen(
                                    onTabSelected: onTabSelected)),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.calendar_month_outlined,
                          label: 'Calendar',
                          color: Colors.pink,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CalendarScreen(
                                    onTabSelected: onTabSelected)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Account section
                  _sectionTitle('Account'),
                  SizedBox(height: 10),
                  _buildTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notification Settings',
                    subtitle: 'Manage alerts & reminders',
                    color: Colors.orange,
                    onTap: () =>
                        _showComingSoon(context, 'Notification Settings'),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your login password',
                    color: Colors.purple,
                    onTap: () => _showComingSoon(context, 'Change Password'),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.palette_outlined,
                    title: 'Theme',
                    subtitle: 'System Default',
                    color: Colors.indigo,
                    onTap: () => _showThemeSelectorDialog(context),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English (Default)',
                    color: Colors.teal,
                    onTap: () => _showComingSoon(context, 'Language Settings'),
                  ),

                  SizedBox(height: 24),

                  // Support section
                  _sectionTitle('Support & Info'),
                  SizedBox(height: 10),
                  _buildTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'About School ERP',
                    subtitle: 'Ecstasy School Management v1.0',
                    color: Colors.blue,
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help Desk',
                    subtitle: 'Contact support team',
                    color: Colors.green,
                    onTap: () => _showComingSoon(context, 'Help Desk'),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.feedback_outlined,
                    title: 'Teachers Feedback',
                    subtitle: 'Send feedback to your teachers',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Teachers Feedback'),
                  ),
                  _buildTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    color: Colors.grey,
                    onTap: () => _showComingSoon(context, 'Privacy Policy'),
                  ),

                  SizedBox(height: 24),

                  // Logout
                  _buildLogoutButton(context),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ──────────────────────────────────────────────────────────
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    );
  }

  // ── Quick card ─────────────────────────────────────────────────────────────
  Widget _buildQuickCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Settings tile ──────────────────────────────────────────────────────────
  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E2875),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        trailing:
            Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  // ── Logout button ──────────────────────────────────────────────────────────
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text('Logout'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Are you sure you want to logout?'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel'.tr),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text('Logout'.tr,
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.logout, color: Colors.white),
        label: Text('Logout'.tr,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(feature,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings & details for $feature'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('This is dummy data representing the active status of this module.'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('$feature settings saved successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Save Changes'.tr),
          ),
        ],
      ),
    );
  }

  void _showThemeSelectorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Theme'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.brightness_auto),
              title: Text('System Default'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.system;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('Light Theme'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.light;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Theme'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.dark;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Ecstasy School ERP',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.school, color: AppColors.primary, size: 32),
      ),
      children: [
        Text('A comprehensive school management app for Ecstasy School students and parents.'.tr,
        ),
      ],
    );
  }

  // ── Profile Section ────────────────────────────────────────────────────────
  Widget _buildProfileSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile avatar
            GestureDetector(
              onTap: () {
                if (onTabSelected != null) {
                  onTabSelected!(1);
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => MyInfoScreen()));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2.5),
                ),
                child: ValueListenableBuilder<String?>(
                  valueListenable: ProfileManager().studentProfileImagePath,
                  builder: (context, path, _) {
                    return CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xFFF0F4FF),
                      backgroundImage:
                          path != null ? FileImage(File(path)) : null,
                      child: path == null
                          ? Icon(
                              Icons.person,
                              color: AppColors.primary,
                              size: 36,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            // Name & class
            ValueListenableBuilder<String>(
              valueListenable: ProfileManager().studentName,
              builder: (context, studentName, _) {
                final currentStudent = AppDataStore.instance.currentUser;
                final String classRoll = currentStudent != null
                    ? "${currentStudent['class'] ?? 'Class 8-A'}  |  ${currentStudent['roll'] ?? 'Roll No: 24'}"
                    : 'Class 8-A  |  Roll No: 24';
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: TextStyle(
                          color: Color(0xFF1E2875),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        classRoll,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.verified_rounded,
                              color: Colors.green, size: 14),
                          SizedBox(width: 4),
                          Text('Active Student'.tr,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // Edit icon
            IconButton(
              icon:
                  Icon(Icons.edit_outlined, color: Colors.grey, size: 22),
              onPressed: () {
                if (onTabSelected != null) {
                  onTabSelected!(1); // Switch to My Info tab
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

