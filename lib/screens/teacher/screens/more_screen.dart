import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  final Function(String) onOptionSelected;

  const MoreScreen({
    super.key,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          const Text(
            "Quick Portals",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
          ),
          const SizedBox(height: 12),
          // Grid of options
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
            ),
            children: [
              _buildMenuCard(
                context,
                Icons.video_camera_front,
                "Meetings Portal",
                "Schedule & Join Meetings",
                Colors.purple,
                () => onOptionSelected("Meetings"),
              ),
              _buildMenuCard(
                context,
                Icons.people,
                "Employees List",
                "Manage School Staff",
                Colors.orange,
                () => onOptionSelected("Employees"),
              ),
              _buildMenuCard(
                context,
                Icons.school,
                "Academic Calendar",
                "School Holidays & Events",
                Colors.green,
                () => onOptionSelected("Calendar"),
              ),
              _buildMenuCard(
                context,
                Icons.chat_bubble_outline,
                "Help & Feedback",
                "Contact ERP Administrator",
                Colors.blue,
                () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Help Desk"),
                      content: const Text("Need assistance? Email support@schoolerp.com or contact the school office (Ext 102)."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account section
          _sectionTitle('Account Options'),
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
            title: 'Management Feedback',
            subtitle: 'Send feedback to school management',
            color: Colors.orange,
            onTap: () => _showComingSoon(context, 'Management Feedback'),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 13, color: Colors.grey),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    onOptionSelected("Logout");
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                  Icon(Icons.info_outline, color: Colors.blue, size: 20),
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
              backgroundColor: Colors.blue,
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
                // ProfileManager().themeMode.value = ThemeMode.system;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light Theme'),
              onTap: () {
                // ProfileManager().themeMode.value = ThemeMode.light;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Theme'),
              onTap: () {
                // ProfileManager().themeMode.value = ThemeMode.dark;
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
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.school, color: Colors.blue, size: 32),
      ),
      children: const [
        Text(
          'A comprehensive school management app for Ecstasy School staff and teachers.',
        ),
      ],
    );
  }


  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B)),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
