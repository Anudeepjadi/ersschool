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
          // User profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B263B), Color(0xFF0D1B2A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ms. Priya Sharma",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Mathematics Teacher (HOD)",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "EMP001",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
          const Text(
            "Account Options",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B)),
          ),
          const SizedBox(height: 12),
          // Settings list
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text("App Settings"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    bool pushEnabled = true;
                    bool emailEnabled = false;
                    String language = "English (US)";

                    showDialog(
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setModalState) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFF3E5F5), // Lavender background
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            title: const Text(
                              "App Settings",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF1B263B)),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  title: const Text("Push Notifications", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                                  activeColor: Colors.deepPurple,
                                  value: pushEnabled,
                                  onChanged: (v) {
                                    setModalState(() => pushEnabled = v);
                                  },
                                ),
                                const SizedBox(height: 8),
                                SwitchListTile(
                                  title: const Text("Email Alerts", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                                  activeColor: Colors.deepPurple,
                                  value: emailEnabled,
                                  onChanged: (v) {
                                    setModalState(() => emailEnabled = v);
                                  },
                                ),
                                const SizedBox(height: 12),
                                ListTile(
                                  title: const Text("App Language", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                                  trailing: Text(
                                    language,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SimpleDialog(
                                        backgroundColor: Colors.white,
                                        title: const Text("Select Language"),
                                        children: ["English (US)", "Hindi", "Telugu", "Tamil"].map((lang) {
                                          return SimpleDialogOption(
                                            onPressed: () {
                                              setModalState(() => language = lang);
                                              Navigator.pop(context);
                                            },
                                            child: Text(lang),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Done", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.grey),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text("Change Password"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const TextField(
                              obscureText: true,
                              decoration: InputDecoration(labelText: "Current Password"),
                            ),
                            const TextField(
                              obscureText: true,
                              decoration: InputDecoration(labelText: "New Password"),
                            ),
                            const TextField(
                              obscureText: true,
                              decoration: InputDecoration(labelText: "Confirm New Password"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Password updated successfully")),
                              );
                            },
                            child: const Text("Update"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Sign Out", style: TextStyle(color: Colors.red)),
                onTap: () {
                  // Sign out logic
                  onOptionSelected("SignOut");
                  // Since we are in a sub-portal pattern, we should trigger a reset to Home
                  // This is handled in MainLayout if we map "SignOut" to a state reset.
                },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHolidayItem(String date, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 13)),
        ],
      ),
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
