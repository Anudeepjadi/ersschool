import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminSystemUpdatesScreen extends StatefulWidget {
  const AdminSystemUpdatesScreen({super.key});

  @override
  State<AdminSystemUpdatesScreen> createState() => _AdminSystemUpdatesScreenState();
}

class _AdminSystemUpdatesScreenState extends State<AdminSystemUpdatesScreen> {
  String _activeTab = 'All Updates';

  final List<Map<String, dynamic>> _updates = [
    {
      'version': 'Version 2.4.0 — Major Update',
      'date': '20 Jun 2026',
      'tags': ['New Features', 'Improvement'],
      'description': 'Introducing new dashboard, improved reports, enhanced communication system and more.',
      'type': 'Major',
    },
    {
      'version': 'Security Patch — 2.4.0',
      'date': '18 Jun 2026',
      'tags': ['Security'],
      'description': 'Security improvements and vulnerability fixes.',
      'type': 'Security',
    },
    {
      'version': 'Announcements Module Update',
      'date': '15 Jun 2026',
      'tags': ['Improvement'],
      'description': 'New announcement targeting and scheduling options.',
      'type': 'Announcements',
    },
    {
      'version': 'Examination Module Enhancements',
      'date': '12 Jun 2026',
      'tags': ['Improvement'],
      'description': 'Added support for grade analytics and custom result cards.',
      'type': 'Examination',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "System Updates",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Stay informed about updates and improvements",
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
                  _buildStatCard("Total Updates", "128", "All time", Colors.blue),
                  _buildStatCard("Latest Version", "v2.4.0", "Current version", Colors.green),
                  _buildStatCard("Last Updated", "20 Jun 2026", "09:30 AM", Colors.orange),
                  _buildStatCard("Upcoming Updates", "3", "In next 30 days", Colors.purple),
                  _buildStatCard("Auto Updates", "Enabled", "System is up to date", Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tabs Row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All Updates', "What's New", 'Announcements', 'Security Updates', 'Maintenance'].map((t) {
                  final isSelected = _activeTab == t;
                  return GestureDetector(
                    onTap: () => setState(() => _activeTab = t),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : const Color(0xFF757897),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // System Status block
            _buildSystemStatusSection(),
            const SizedBox(height: 16),

            // Updates Logs list
            _buildUpdatesList(),
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

  Widget _buildSystemStatusSection() {
    final List<Map<String, String>> services = [
      {'name': 'Website', 'status': 'Operational'},
      {'name': 'Mobile App', 'status': 'Operational'},
      {'name': 'API Services', 'status': 'Operational'},
      {'name': 'Database', 'status': 'Operational'},
      {'name': 'File Storage', 'status': 'Operational'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "System Status",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Text(
                "All Systems Operational",
                style: TextStyle(fontSize: 11, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 12),
          Column(
            children: services.map((s) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s['name']!, style: const TextStyle(fontSize: 12, color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(s['status']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildUpdatesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Recent Updates Log",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _updates.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final up = _updates[index];
              return ListTile(
                title: Text(up['version'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(up['description'], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      children: (up['tags'] as List<String>).map((t) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        );
                      }).toList(),
                    )
                  ],
                ),
                trailing: Text(
                  up['date'],
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
