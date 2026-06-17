import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminHelpCenterScreen extends StatefulWidget {
  const AdminHelpCenterScreen({super.key});

  @override
  State<AdminHelpCenterScreen> createState() => _AdminHelpCenterScreenState();
}

class _AdminHelpCenterScreenState extends State<AdminHelpCenterScreen> {
  final List<Map<String, dynamic>> _tickets = [
    {'id': 'TKT-2026-1256', 'subject': 'Unable to download grade report', 'category': 'Academics', 'status': 'Open', 'date': '20 Jun 2026'},
    {'id': 'TKT-2026-1242', 'subject': 'Fee payment not reflected', 'category': 'Fees & Payments', 'status': 'In Progress', 'date': '19 Jun 2026'},
    {'id': 'TKT-2026-1187', 'subject': 'Transport route change request', 'category': 'Transport', 'status': 'Resolved', 'date': '18 Jun 2026'},
    {'id': 'TKT-2026-1129', 'subject': 'Hostel room maintenance issue', 'category': 'Hostel', 'status': 'Resolved', 'date': '17 Jun 2026'},
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
              "Help Center",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Get help and support",
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
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: "Search for help articles, topics...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF757897)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Help Articles", "256", "Browse articles", Colors.blue),
                  _buildStatCard("FAQs", "128", "Find quick answers", Colors.teal),
                  _buildStatCard("Open Tickets", "18", "Need assistance", Colors.orange),
                  _buildStatCard("Resolved Tickets", "342", "Issues resolved", Colors.green),
                  _buildStatCard("Live Chat", "Available", "We're online", Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Popular Help Topics
            _buildHelpTopicsSection(),
            const SizedBox(height: 16),

            // FAQs List
            _buildFAQSection(),
            const SizedBox(height: 16),

            // Support Tickets Log
            _buildTicketsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 125,
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

  Widget _buildHelpTopicsSection() {
    final List<Map<String, dynamic>> topics = [
      {'title': 'Academics', 'icon': Icons.school_outlined, 'articles': 24, 'color': Colors.blue},
      {'title': 'Student Account', 'icon': Icons.person_outline, 'articles': 18, 'color': Colors.teal},
      {'title': 'Fees & Payments', 'icon': Icons.currency_rupee, 'articles': 22, 'color': Colors.green},
      {'title': 'Attendance', 'icon': Icons.checklist, 'articles': 16, 'color': Colors.orange},
      {'title': 'Transport', 'icon': Icons.directions_bus_outlined, 'articles': 14, 'color': Colors.purple},
      {'title': 'Hostel', 'icon': Icons.hotel_outlined, 'articles': 12, 'color': Colors.pinkAccent},
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
          const Text(
            "Popular Help Topics",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final top = topics[index];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: top['color'].withValues(alpha: 0.1),
                      child: Icon(top['icon'], color: top['color'], size: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(top['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("${top['articles']} Articles", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    final List<Map<String, String>> faqs = [
      {'q': 'How can I pay my school fees online?', 'a': 'Go to Fees -> Collect Fees or select Fee card on your dashboard to pay via cards or netbanking.'},
      {'q': 'How do I check my examination results?', 'a': 'Go to Examinations -> click Published Results next to the exam name to view analysis.'},
      {'q': 'How can I apply for hostel accommodation?', 'a': 'Open Hostel -> select Add Resident to assign rooms and beds to students.'},
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
          const Text(
            "Frequently Asked Questions",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 12),
          Column(
            children: faqs.map((f) {
              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(f['q']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(f['a']!, style: const TextStyle(fontSize: 11, color: Color(0xFF757897))),
                  ),
                ],
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildTicketsSection() {
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
              "My Support Tickets",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tickets.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tk = _tickets[index];
              Color statusColor;
              switch (tk['status']) {
                case 'Open':
                  statusColor = const Color(0xFF3B82F6);
                  break;
                case 'In Progress':
                  statusColor = const Color(0xFFF59E0B);
                  break;
                default:
                  statusColor = const Color(0xFF10B981);
              }

              return ListTile(
                title: Text(tk['subject'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("ID: ${tk['id']} • Category: ${tk['category']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tk['status'],
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tk['date'],
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
