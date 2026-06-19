import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../widgets/admin_app_bar.dart';

class AdminChatSupportScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final bool openBotChat;
  const AdminChatSupportScreen({super.key, this.onOpenDrawer, this.openBotChat = false});

  @override
  State<AdminChatSupportScreen> createState() => _AdminChatSupportScreenState();
}

class _AdminChatSupportScreenState extends State<AdminChatSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  Map<String, dynamic>? _selectedChat;
  String _currentFilter = 'All';

  final List<Map<String, dynamic>> _chats = [
    {
      'title': 'Rahul Kumar',
      'subtitle': 'I need help downloading my hall ticket.',
      'type': 'student',
      'time': '10:30 AM',
      'status': 'Open',
      'unread': true,
      'name': 'Rahul Kumar',
      'role': 'Student - Class 8 A',
    },
    {
      'title': 'Ananya Sharma',
      'subtitle': 'Please help me update my profile information.',
      'type': 'student',
      'time': 'Yesterday',
      'status': 'Resolved',
      'unread': false,
      'name': 'Ananya Sharma',
      'role': 'Student - Class 7 B',
    },
    {
      'title': 'ID Card Issue',
      'subtitle': 'My ID card has incorrect information.',
      'type': 'topic',
      'icon': Icons.badge_outlined,
      'color': Colors.purple,
      'time': 'Yesterday',
      'status': 'Open',
      'unread': false,
    },
    {
      'title': 'Fee Payment',
      'subtitle': 'Payment failed but amount deducted from my account.',
      'type': 'topic',
      'icon': Icons.payment_outlined,
      'color': Colors.orange,
      'time': '20 May',
      'status': 'Resolved',
      'unread': false,
    },
    {
      'title': 'Examination',
      'subtitle': 'When will the semester results be declared?',
      'type': 'topic',
      'icon': Icons.assignment_outlined,
      'color': Colors.green,
      'time': '19 May',
      'status': 'Closed',
      'unread': false,
    },
    {
      'title': 'Hostel Allocation',
      'subtitle': 'I want to change my hostel room.',
      'type': 'topic',
      'icon': Icons.business_outlined,
      'color': Colors.blue,
      'time': '18 May',
      'status': 'Open',
      'unread': false,
    },
    {
      'title': 'Transport',
      'subtitle': 'Need information about bus timings.',
      'type': 'topic',
      'icon': Icons.directions_bus_outlined,
      'color': Colors.redAccent,
      'time': '17 May',
      'status': 'Resolved',
      'unread': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.openBotChat) {
      _selectedChat = {
        'title': 'AI Assistant',
        'subtitle': 'Hi, how can I help you?',
        'type': 'bot',
        'icon': Icons.smart_toy,
        'color': Colors.blue,
        'time': 'Now',
        'status': 'Open',
        'unread': false,
        'name': 'AI Assistant',
        'role': 'Support Bot',
      };
    } else {
      _selectedChat = _chats[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    
    Widget sidebar = _buildSidebar();
    Widget chatArea = _buildChatArea();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Chat Support",
        subtitle: "Manage student and staff queries",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SafeArea(
        child: isMobile 
            ? (_selectedChat == null ? sidebar : chatArea)
            : Row(
                children: [
                  SizedBox(width: 320, child: sidebar),
                  const VerticalDivider(width: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                  Expanded(child: chatArea),
                ],
              ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                      hintText: "Search chats...",
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.filter_alt_outlined, color: Colors.blue, size: 24),
            ],
          ),
        ),
        
        // Tabs
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTab("All", _currentFilter == 'All'),
              _buildTab("Open", _currentFilter == 'Open'),
              _buildTab("Resolved", _currentFilter == 'Resolved'),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        
        // Chat List
        Expanded(
          child: Builder(
            builder: (context) {
              final filteredChats = _chats.where((chat) {
                if (_currentFilter == 'All') return true;
                if (_currentFilter == 'Open') return chat['status'] == 'Open';
                if (_currentFilter == 'Resolved') return chat['status'] == 'Resolved' || chat['status'] == 'Closed';
                return true;
              }).toList();
              return ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (context, index) {
                  final chat = filteredChats[index];
                  return _buildChatListItem(chat);
                },
              );
            }
          ),
        ),
        
        // Start New Chat Button
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Starting new chat...')));
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Can't find your conversation?", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text("Start New Chat", style: TextStyle(fontSize: 14, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.blue.shade700 : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade700 : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildChatListItem(Map<String, dynamic> chat) {
    bool isSelected = _selectedChat == chat;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedChat = chat;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFF) : Colors.white,
          border: const Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Stack(
              children: [
                if (chat['type'] == 'student')
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.person, color: Colors.grey.shade400),
                  )
                else
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: chat['color'].withValues(alpha: 0.1),
                    child: Icon(chat['icon'], color: chat['color'], size: 20),
                  ),
                if (chat['type'] == 'student')
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      ),
                      Text(
                        chat['time'],
                        style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          chat['subtitle'],
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusPill(chat['status']),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color bgColor;
    Color textColor;
    if (status == 'Open') {
      bgColor = const Color(0xFFE6F0FF);
      textColor = Colors.blue.shade700;
    } else if (status == 'Resolved') {
      bgColor = const Color(0xFFE6F9F0);
      textColor = Colors.green.shade700;
    } else {
      bgColor = const Color(0xFFF0F0F0);
      textColor = Colors.grey.shade700;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _buildChatArea() {
    if (_selectedChat == null) {
      return const Center(child: Text("Select a chat"));
    }
    
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width < 600)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _selectedChat = null),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (MediaQuery.of(context).size.width < 600)
                const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person, color: Colors.grey.shade400),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedChat!['name'] ?? _selectedChat!['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(_selectedChat!['role'] ?? 'Topic', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.grey),
              const SizedBox(width: 16),
              Text("Details", style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ),
        
        // Chat Messages
        Expanded(
          child: Container(
            color: const Color(0xFFFCFCFC), // Very light grey background
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: Text("Today", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87))),
                const SizedBox(height: 20),
                
                if (_selectedChat != null && _selectedChat!['type'] == 'bot') ...[
                  _buildLeftMessage("Hi! 👋\nHow can I help you today?", "Now"),
                ] else ...[
                  // User Message
                  _buildRightMessage("Hello, I need help downloading my hall ticket for the upcoming examination.", "10:30 AM"),
                

                  // Agent Message
                  _buildLeftMessage("Hello Rahul! 👋\n\nI'd be happy to help you with that.\nMay I know which examination hall ticket you want to download?", "10:31 AM"),
                
                  // User Message
                  _buildRightMessage("It's for the Half Yearly Examination 2024-25.", "10:32 AM"),
                
                  // Agent Message
                  _buildLeftMessage("Thanks for the information.\nPlease give me a moment while I check this for you.", "10:32 AM"),
                
                  // Agent Message
                  _buildLeftMessage("Great! You can download your hall ticket by following these steps:\n\n1. Go to Examinations > Hall Tickets\n2. Select Half Yearly Examination 2024-25\n3. Click on Download Hall Ticket\n\nLet me know if you face any issues.", "10:33 AM"),
                
                  // User Message
                  _buildRightMessage("Thank you! I was able to download it.", "10:34 AM"),
                
                  // Agent Message
                  _buildLeftMessage("You're welcome! 😊\nIf you need any more help, feel free to reach out anytime.", "10:34 AM"),
                
                  // Survey
                  const SizedBox(height: 20),
                  _buildSurvey(),
                  
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chat ID: #CS-10245", style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                      Text("10:34 AM", style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // Input Area
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Icon(Icons.attach_file, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Icon(Icons.sentiment_satisfied_alt, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightMessage(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F8FF), // Light blue from image
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875), fontWeight: FontWeight.w600, height: 1.4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(time, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Icon(Icons.done_all, size: 12, color: Colors.blue.shade400),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftMessage(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: const Color(0xFFEEF2FF),
            child: Icon(Icons.headset_mic, size: 14, color: Colors.blue.shade700),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2)),
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600, height: 1.4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(time, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurvey() {
    return Column(
      children: [
        const Text("How was your support experience?", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSurveyOption(Icons.sentiment_dissatisfied, "Poor", Colors.grey.shade600, false),
            const SizedBox(width: 32),
            _buildSurveyOption(Icons.sentiment_satisfied, "Good", Colors.grey.shade600, false),
            const SizedBox(width: 32),
            _buildSurveyOption(Icons.sentiment_very_satisfied, "Excellent", Colors.green, true),
          ],
        ),
      ],
    );
  }

  Widget _buildSurveyOption(IconData icon, String label, Color color, bool isFilled) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
