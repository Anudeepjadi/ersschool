import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _tfaEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedDateFormat = 'DD MMM YYYY';
  String _selectedTimeFormat = '12 Hour (AM/PM)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings & Preferences",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Manage your account and application preferences",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Profile Completion", "100%", "Complete", Colors.green),
                  _buildStatCard("Security Status", "Strong", "Last changed 28 days ago", Colors.blue),
                  _buildStatCard("Notifications", "Active", "8 channels enabled", Colors.orange),
                  _buildStatCard("Language", "English", "Change anytime", Colors.purple),
                  _buildStatCard("Account Status", "Active", "No issues found", Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Information Card
            _buildProfileSection(),
            const SizedBox(height: 16),

            // Password & Security Card
            _buildSecuritySection(),
            const SizedBox(height: 16),

            // Preferences Card
            _buildPreferencesSection(),
            const SizedBox(height: 16),

            // Notification Channels Card
            _buildNotificationsSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Information",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 14),
          _ProfileField("Name", "Rahul Kumar"),
          Divider(),
          _ProfileField("Role", "Administrator"),
          Divider(),
          _ProfileField("Email", "rahul.kumar@ecstasyschool.edu"),
          Divider(),
          _ProfileField("Employee ID", "ECS001"),
          Divider(),
          _ProfileField("Mobile Number", "+91 98765 43210"),
          Divider(),
          _ProfileField("Department", "Administration"),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password & Security",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline, color: AppColors.primary),
            title: const Text("Password", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            subtitle: const Text("Last changed 28 days ago", style: TextStyle(fontSize: 11, color: Colors.grey)),
            trailing: TextButton(onPressed: () {}, child: const Text("Change Password")),
          ),
          const Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Icons.security_outlined, color: AppColors.primary),
            title: const Text("Two-Factor Authentication", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            subtitle: const Text("Add an extra layer of security", style: TextStyle(fontSize: 11, color: Colors.grey)),
            value: _tfaEnabled,
            onChanged: (v) => setState(() => _tfaEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Preferences",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 14),
          _buildPreferencesDropdown("Language", _selectedLanguage, ['English', 'Spanish', 'Hindi'], (v) => setState(() => _selectedLanguage = v!)),
          const Divider(),
          _buildPreferencesDropdown("Date Format", _selectedDateFormat, ['DD MMM YYYY', 'YYYY-MM-DD'], (v) => setState(() => _selectedDateFormat = v!)),
          const Divider(),
          _buildPreferencesDropdown("Time Format", _selectedTimeFormat, ['12 Hour (AM/PM)', '24 Hour'], (v) => setState(() => _selectedTimeFormat = v!)),
        ],
      ),
    );
  }

  Widget _buildPreferencesDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        DropdownButton<String>(
          value: value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF757897), fontWeight: FontWeight.bold),
          underline: const SizedBox(),
          items: items.map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Notification Channels",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 14),
          _NotificationRow("Email Notifications", true),
          Divider(),
          _NotificationRow("SMS Notifications", true),
          Divider(),
          _NotificationRow("In-App Notifications", true),
          Divider(),
          _NotificationRow("WhatsApp Notifications", false),
          Divider(),
          _NotificationRow("Telegram Notifications", false),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileField(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  final String title;
  final bool enabled;
  const _NotificationRow(this.title, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF1E2875), fontWeight: FontWeight.w600)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (enabled ? const Color(0xFF10B981) : Colors.red).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            enabled ? "Enabled" : "Disabled",
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: enabled ? const Color(0xFF10B981) : Colors.red),
          ),
        )
      ],
    );
  }
}
