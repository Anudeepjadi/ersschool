import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminChatSupportScreen extends StatefulWidget {
  const AdminChatSupportScreen({super.key});

  @override
  State<AdminChatSupportScreen> createState() => _AdminChatSupportScreenState();
}

class _AdminChatSupportScreenState extends State<AdminChatSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, dynamic>? _selectedChat;

  final List<Map<String, dynamic>> _chats = [
    {
      'title': 'Rahul Kumar',
      'subtitle': 'Student • Class 8 - A',
      'issue': 'I need help downloading my hall ticket.',
      'messages': [
        {'sender': 'user', 'text': 'Hello, I need help downloading my hall ticket for the upcoming examination.', 'time': '10:30 AM'},
        {'sender': 'agent', 'text': 'Hello Rahul! I\'d be happy to help you with that. May I know which examination hall ticket you want to download?', 'time': '10:31 AM'},
        {'sender': 'user', 'text': 'It\'s for the Half Yearly Examination 2024-25.', 'time': '10:32 AM'},
        {'sender': 'agent', 'text': 'Thanks for the information. Please give me a moment while I check this for you.\n\nGreat! You can download your hall ticket by following these steps:\n1. Go to Examinations -> Hall Tickets\n2. Select Half Yearly Examination 2024-25\n3. Click on Download Hall Ticket\n\nLet me know if you face any issues.', 'time': '10:33 AM'},
        {'sender': 'user', 'text': 'Thank you! I was able to download it.', 'time': '10:34 AM'},
        {'sender': 'agent', 'text': 'You\'re welcome! If you need any more help, feel free to reach out anytime.', 'time': '10:34 AM'},
      ],
      'status': 'Open',
      'time': '10:30 AM',
      'unread': true,
    },
    {
      'title': 'Ananya Sharma',
      'subtitle': 'Student • Class 7 - B',
      'issue': 'Please help me update my profile information.',
      'messages': [
        {'sender': 'user', 'text': 'Hi, I need to update my mobile number.', 'time': 'Yesterday'},
      ],
      'status': 'Resolved',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'title': 'ID Card Issue',
      'subtitle': 'Student • Class 6 - A',
      'issue': 'My ID card has incorrect information.',
      'messages': [],
      'status': 'Open',
      'time': 'Yesterday',
      'unread': false,
    },
    {
      'title': 'Fee Payment',
      'subtitle': 'Student • Class 5 - B',
      'issue': 'Payment failed but amount deducted.',
      'messages': [],
      'status': 'Resolved',
      'time': '20 May',
      'unread': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedChat = _chats[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chat Support",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Connect with our support team",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Chat list sidebar/row (horizontal list on mobile layout for better space)
          Container(
            height: 90,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final chat = _chats[index];
                final isSelected = _selectedChat == chat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedChat = chat),
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : const Color(0xFFF5F7FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.transparent),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                chat['title'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                              ),
                            ),
                            if (chat['unread'])
                              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chat['subtitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message bubble thread details
          Expanded(
            child: _selectedChat == null
                ? const Center(child: Text("Select a conversation to start", style: TextStyle(color: Colors.grey)))
                : _buildChatThreadPanel(_selectedChat!),
          ),

          // Message Input Field Row
          if (_selectedChat != null) _buildMessageInputSection(),
        ],
      ),
    );
  }

  Widget _buildChatThreadPanel(Map<String, dynamic> chat) {
    final List<dynamic> msgs = chat['messages'];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat['title'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  Text(chat['subtitle'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (chat['status'] == 'Open' ? AppColors.primary : Colors.green).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  chat['status'],
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: chat['status'] == 'Open' ? AppColors.primary : Colors.green),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: msgs.isEmpty
              ? Center(child: Text("No messages yet. Send a note!", style: TextStyle(color: Colors.grey.shade400)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[index];
                    final isMe = m['sender'] == 'agent';
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                          ),
                          border: isMe ? null : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['text'],
                              style: TextStyle(fontSize: 12, color: isMe ? Colors.white : const Color(0xFF1E2875), height: 1.4),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                m['time'],
                                style: TextStyle(fontSize: 8, color: isMe ? Colors.white70 : Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMessageInputSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                fillColor: const Color(0xFFF5F7FF),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 18),
              onPressed: () {
                final text = _messageController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _selectedChat!['messages'].add({
                      'sender': 'agent',
                      'text': text,
                      'time': 'Just now',
                    });
                    _messageController.clear();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
