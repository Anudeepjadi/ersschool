import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../widgets/admin_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminCommunicationsScreen extends StatefulWidget {
  const AdminCommunicationsScreen({super.key});

  @override
  State<AdminCommunicationsScreen> createState() => _AdminCommunicationsScreenState();
}

class _AdminCommunicationsScreenState extends State<AdminCommunicationsScreen> {
  String _activeFolder = 'Inbox';
  Map<String, dynamic>? _selectedMessage;

  final List<Map<String, dynamic>> _folders = [
    {'name': 'Inbox', 'icon': Icons.inbox, 'count': 12},
    {'name': 'Sent', 'icon': Icons.send, 'count': 142},
    {'name': 'Scheduled', 'icon': Icons.schedule, 'count': 8},
    {'name': 'Drafts', 'icon': Icons.drafts, 'count': 5},
    {'name': 'Important', 'icon': Icons.star_border, 'count': 6},
    {'name': 'Trash', 'icon': Icons.delete_outline, 'count': 3},
  ];

  final List<Map<String, dynamic>> _messages = [
    {
      'title': 'Annual Sports Day — 20 May 2024',
      'sender': 'Admin (admin@ecstasyschool.com)',
      'to': 'All Students, Parents & Staff',
      'preview': 'We are excited to inform you that our Annual Sports...',
      'content': 'Dear Students, Parents & Staff,\n\nWe are excited to inform you that our Annual Sports Day will be held on 20 May 2024 at the Main Ground from 09:00 AM onwards.\n\nAll students are encouraged to participate in the events and make this day a grand success.\n\nRegards,\nAdmin Team\nEcstasy School 1',
      'date': '20 May 2024',
      'time': '10:30 AM',
      'unread': true,
      'audience': 'All Students',
    },
    {
      'title': 'Fee Payment Reminder',
      'sender': 'Accounts (accounts@ecstasyschool.com)',
      'to': 'Parents',
      'preview': 'This is a friendly reminder to clear the pending fee...',
      'content': 'Dear Parents,\n\nThis is a friendly reminder to clear the pending fee amount of your ward for the current term before the due date to avoid late payment charges.\n\nRegards,\nAccounts Team',
      'date': '19 May 2024',
      'time': 'Yesterday',
      'unread': true,
      'audience': 'Parents',
    },
    {
      'title': 'Holiday Notice — 18 May 2024',
      'sender': 'Principal Office',
      'to': 'All Students',
      'preview': 'Please be informed that the school will remain closed...',
      'content': 'Please be informed that the school will remain closed tomorrow on account of local elections. Regular classes will resume on Monday.',
      'date': '17 May 2024',
      'time': '17 May 2024',
      'unread': false,
      'audience': 'All Students',
    },
    {
      'title': 'PTM Schedule — Class 8 to 10',
      'sender': 'Academic Coordinator',
      'to': 'Parents',
      'preview': 'Dear Parents, Please note the PTM schedule for Class...',
      'content': 'Dear Parents, Please note the PTM schedule for Class 8 to 10 has been uploaded in the portal. Kindly check and attend as scheduled.',
      'date': '16 May 2024',
      'time': '16 May 2024',
      'unread': false,
      'audience': 'Parents',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMessage = _messages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(
        title: "Communications",
        subtitle: "Manage all school communications",
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats grid row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Messages", "156", "+18 this month", Colors.blue),
                  _buildStatCard("Messages Sent", "142", "+16 this month", Colors.green),
                  _buildStatCard("Scheduled", "8", "+2 this month", Colors.orange),
                  _buildStatCard("Opened Rate", "82%", "Open Rate", Colors.purple),
                  _buildStatCard("Responses", "678", "21% Response Rate", Colors.teal),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Folder selector list
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _folders.map((f) {
                  final isSelected = _activeFolder == f['name'];
                  return GestureDetector(
                    onTap: () => setState(() => _activeFolder = f['name']),
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(f['icon'], size: 16, color: isSelected ? Colors.white : Colors.grey),
                          SizedBox(width: 6),
                          Text(
                            f['name'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Color(0xFF757897),
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "(${f['count']})",
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // Layout row with Messages list on top and Message Detail view underneath
            _buildMessagesList(),
            SizedBox(height: 16),
            if (_selectedMessage != null) _buildMessageDetailCard(_selectedMessage!),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Messages Inbox (${_messages.length})",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                ),
                Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _messages.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isSelected = _selectedMessage == msg;
              return ListTile(
                selected: isSelected,
                selectedTileColor: AppColors.primary.withValues(alpha: 0.05),
                onTap: () => setState(() => _selectedMessage = msg),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        msg['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: msg['unread'] ? FontWeight.bold : FontWeight.w600,
                          color: Color(0xFF1E2875),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      msg['time'],
                      style: TextStyle(
                        fontSize: 11,
                        color: msg['unread'] ? AppColors.primary : Colors.grey,
                        fontWeight: msg['unread'] ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          msg['preview'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg['audience'],
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageDetailCard(Map<String, dynamic> msg) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Message Detail".tr,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5),
              ),
              Row(
                children: [
                  Icon(Icons.star_border, size: 18, color: Colors.grey),
                  SizedBox(width: 12),
                  Icon(Icons.delete_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Sent".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 16),
          Text(
            msg['title'],
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(msg['sender'][0], style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("From: ${msg['sender']}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text("To: ${msg['to']}", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              Text(msg['date'], style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 12),
          Text(
            msg['content'],
            style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary),
                ),
                onPressed: () => _handleMessageAction("Reply"),
                child: Row(children: [
                    Icon(Icons.reply, size: 16),
                    SizedBox(width: 6),
                    Text("Reply".tr),
                  ],
                ),
              ),
              SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _handleMessageAction("Forward"),
                child: Row(children: [
                    Icon(Icons.forward, size: 16),
                    SizedBox(width: 6),
                    Text("Forward".tr),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _handleMessageAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$action action triggered for: ${_selectedMessage?['title'] ?? 'Notice'}")),
    );
  }
}
