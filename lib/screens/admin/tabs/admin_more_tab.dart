import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../login/login_screen.dart';

class AdminMoreTab extends StatelessWidget {
  final VoidCallback onOpenDrawer;

  const AdminMoreTab({super.key, required this.onOpenDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
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
                          icon: Icons.assessment_outlined,
                          label: 'Reports',
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.calendar_month_outlined,
                          label: 'Calendar',
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.directions_bus_outlined,
                          label: 'Transport',
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickCard(
                          context,
                          icon: Icons.library_books_outlined,
                          label: 'Library',
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Management section
                  _sectionTitle('Management'),
                  const SizedBox(height: 10),
                  _buildTile(
                    context,
                    icon: Icons.campaign_outlined,
                    title: 'Notice Board',
                    subtitle: 'Create & manage notices',
                    color: Colors.orange,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.event_outlined,
                    title: 'Events Manager',
                    subtitle: 'Schedule & manage events',
                    color: Colors.blue,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.receipt_long_outlined,
                    title: 'Fee Management',
                    subtitle: 'Fee structure & collection',
                    color: Colors.green,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.assignment_outlined,
                    title: 'Exam Management',
                    subtitle: 'Schedule & manage exams',
                    color: Colors.purple,
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
                  ),
                  _buildTile(
                    context,
                    icon: Icons.lock_reset_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your login password',
                    color: Colors.purple,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.language_outlined,
                    title: 'Language',
                    subtitle: 'English (Default)',
                    color: Colors.teal,
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
                  ),
                  _buildTile(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help Desk',
                    subtitle: 'Contact support team',
                    color: Colors.green,
                  ),
                  _buildTile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    color: Colors.grey,
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

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF3B5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 28,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
            ),
            child: const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ecstasy School ERP',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: Colors.greenAccent, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Super Admin',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: Colors.white70, size: 22),
            onPressed: () => _showComingSoon(context, 'Edit Profile'),
          ),
        ],
      ),
    );
  }

  // ── Section title ───────────────────────────────────────────────────────
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

  // ── Quick card ──────────────────────────────────────────────────────────
  Widget _buildQuickCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => _showComingSoon(context, label),
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

  // ── Settings tile ───────────────────────────────────────────────────────
  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
        onTap: () => _showComingSoon(context, title),
      ),
    );
  }

  // ── Logout button ───────────────────────────────────────────────────────
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

  // ── Helpers ─────────────────────────────────────────────────────────────
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — Coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
