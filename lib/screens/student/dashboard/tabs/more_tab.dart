import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/profile_manager.dart';
import '../../my_info/my_info_screen.dart';
import '../widgets/student_app_bar.dart';
import '../../../login/login_screen.dart';
import '../../transport/transport_screen.dart';
import '../../calendar/calendar_screen.dart';

class MoreTab extends StatelessWidget {
  final Function(int)? onTabSelected;

  const MoreTab({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: StudentAppBar(
        title: "More",
        subtitle: "Settings and additional options",
        onOpenDrawer: () => Scaffold.of(context).openDrawer(),
        onProfileTap: onTabSelected != null ? () => onTabSelected!(1) : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Profile Info Section
            _buildProfileSection(context),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick links section
                  _sectionTitle('Quick Links'),
                  const SizedBox(height: 12),
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
                                builder: (_) => TransportScreen(onTabSelected: onTabSelected)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.calendar_month_outlined,
                          label: 'Calendar',
                          color: Colors.pink,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CalendarScreen(onTabSelected: onTabSelected)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Account section
                  _sectionTitle('Account'),
                  const SizedBox(height: 10),
                  _buildTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notification Settings',
                    subtitle: 'Manage alerts & reminders',
                    color: Colors.orange,
                    onTap: () => _showComingSoon(context, 'Notification Settings'),
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

                  const SizedBox(height: 24),

                  // Support section
                  _sectionTitle('Support & Info'),
                  const SizedBox(height: 10),
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

                  const SizedBox(height: 24),

                  // Logout
                  _buildLogoutButton(context),

                  const SizedBox(height: 30),
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
      style: const TextStyle(
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
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Color(0xFF1E2875),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 13, color: Colors.grey),
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
              title: const Text('Logout',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
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
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
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
        title: Text(feature, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings & details for $feature'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This is dummy data representing the active status of this module.',
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
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$feature settings saved successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelectorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Theme', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System Default'),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.system;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light Theme'),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.light;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Theme'),
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.school, color: AppColors.primary, size: 32),
      ),
      children: const [
        Text(
          'A comprehensive school management app for Ecstasy School students and parents.',
        ),
      ],
    );
  }

  // ── Profile Section ────────────────────────────────────────────────────────
  Widget _buildProfileSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MyInfoScreen()));
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
                      backgroundColor: const Color(0xFFF0F4FF),
                      backgroundImage: path != null ? FileImage(File(path)) : null,
                      child: path == null
                          ? const Icon(
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
            const SizedBox(width: 16),
            // Name & class
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Anudeep Jaadi',
                    style: TextStyle(
                      color: Color(0xFF1E2875),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Class 8-A  •  Roll No: 24',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.verified_rounded,
                          color: Colors.green, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Active Student',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Edit icon
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  color: Colors.grey, size: 22),
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

