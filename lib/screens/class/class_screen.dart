import 'package:flutter/material.dart';

class ClassScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const ClassScreen({super.key, this.onOpenDrawer});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'title': 'Timetable', 'icon': Icons.calendar_today_outlined},
    {'title': 'Diary', 'icon': Icons.menu_book_outlined},
    {'title': 'Assignments', 'icon': Icons.assignment_outlined},
    {'title': 'Attendance', 'icon': Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF001A72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.onOpenDrawer,
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
              const Text(
                "Class",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.business, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          "Ecstasy School 1",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, color: Colors.white),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 12),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?u=school_student'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Access your class related information",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _tabs[index]['icon'],
                  color: isSelected
                      ? const Color(0xFF0038FF)
                      : const Color(0xFF666666),
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  _tabs[index]['title'],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF0038FF)
                        : const Color(0xFF666666),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                if (isSelected)
                  Container(
                    height: 3,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0038FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(height: 3),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedTab) {
      case 0:
        return _buildTimetable();
      case 1:
        return _buildPlaceholder("Diary Content");
      case 2:
        return _buildPlaceholder("Assignments Content");
      case 3:
        return _buildPlaceholder("Attendance Content");
      default:
        return Container();
    }
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildTimetable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.chevron_left, color: Colors.grey),
              SizedBox(width: 16),
              Icon(Icons.calendar_month, size: 18, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                "Monday, 20 May 2024",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(width: 16),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Timetable",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E)),
              ),
              Text(
                "View Full Timetable",
                style: TextStyle(
                    color: Color(0xFF0038FF),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Timetable Header
          Row(
            children: const [
              Expanded(
                  flex: 10,
                  child: Text("Period",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
              Expanded(
                  flex: 20,
                  child: Text("Time",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
              Expanded(
                  flex: 30,
                  child: Text("Subject",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
              Expanded(
                  flex: 30,
                  child: Text("Teacher",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
              Expanded(
                  flex: 10,
                  child: Text("Room",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500))),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          _buildTimetableItem(
            period: "1",
            time: "08:00 AM\n- 08:45 AM",
            subject: "Mathematics",
            subjectCode: "MATH",
            teacher: "Mr. Amit Verma",
            room: "101",
            color: Colors.blue,
            icon: Icons.menu_book,
            teacherImg: "https://i.pravatar.cc/150?u=teacher1",
          ),
          _buildTimetableItem(
            period: "2",
            time: "08:45 AM\n- 09:30 AM",
            subject: "English",
            subjectCode: "ENG",
            teacher: "Ms. Priya Sharma",
            room: "102",
            color: Colors.green,
            icon: Icons.menu_book,
            teacherImg: "https://i.pravatar.cc/150?u=teacher2",
          ),
          _buildTimetableItem(
            period: "3",
            time: "09:30 AM\n- 10:15 AM",
            subject: "Science",
            subjectCode: "SCI",
            teacher: "Mr. Rahul Mehta",
            room: "103",
            color: Colors.orange,
            icon: Icons.science_outlined,
            teacherImg: "https://i.pravatar.cc/150?u=teacher3",
          ),

          _buildBreakTime("Break Time", "10:15 AM - 10:30 AM"),

          _buildTimetableItem(
            period: "4",
            time: "10:30 AM\n- 11:15 AM",
            subject: "Social Science",
            subjectCode: "SST",
            teacher: "Ms. Neha Gupta",
            room: "104",
            color: Colors.purple,
            icon: Icons.public,
            teacherImg: "https://i.pravatar.cc/150?u=teacher4",
          ),
          _buildTimetableItem(
            period: "5",
            time: "11:15 AM\n- 12:00 PM",
            subject: "Hindi",
            subjectCode: "HIN",
            teacher: "Mr. Sandeep Yadav",
            room: "105",
            color: Colors.indigo,
            icon: Icons.language,
            teacherImg: "https://i.pravatar.cc/150?u=teacher5",
          ),
          _buildTimetableItem(
            period: "6",
            time: "12:00 PM\n- 12:45 PM",
            subject: "Computer Science",
            subjectCode: "CS",
            teacher: "Ms. Anjali Singh",
            room: "106",
            color: Colors.teal,
            icon: Icons.computer,
            teacherImg: "https://i.pravatar.cc/150?u=teacher6",
          ),

          const SizedBox(height: 32),
          _buildSectionHeader("Today's Assignments", "View All"),
          const SizedBox(height: 16),
          _buildAssignmentItem(
            title: "Maths - Chapter 5 Exercise",
            type: "Homework",
            typeColor: Colors.blue,
            dueText: "Due Today",
            dueTime: "11:59 PM",
            icon: Icons.assignment,
            iconColor: Colors.blue,
          ),
          _buildAssignmentItem(
            title: "Science - Lab Report",
            type: "Practical",
            typeColor: Colors.green,
            dueText: "Due Tomorrow",
            dueTime: "11:59 PM",
            icon: Icons.science,
            iconColor: Colors.green,
          ),

          const SizedBox(height: 32),
          _buildSectionHeader("Attendance Summary", "View Details"),
          const SizedBox(height: 16),
          _buildAttendanceSummary(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E)),
        ),
        Text(
          action,
          style: const TextStyle(
              color: Color(0xFF0038FF),
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTimetableItem({
    required String period,
    required String time,
    required String subject,
    required String subjectCode,
    required String teacher,
    required String room,
    required Color color,
    required IconData icon,
    required String teacherImg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 10,
            child: Text(
              period,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 20,
            child: Text(
              time,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 30,
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                      Text(subjectCode,
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 30,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(teacherImg),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    teacher,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Text(
              room,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakTime(String title, String time) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.coffee_outlined, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem({
    required String title,
    required String type,
    required Color typeColor,
    required String dueText,
    required String dueTime,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                            color: typeColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("Solve exercise questions from chapter 5.",
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(dueText,
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
              Text(dueTime,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildAttendanceSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAttendanceStat(
            "Total Classes", "120", Icons.calendar_today, Colors.green),
        _buildAttendanceStat(
            "Present", "108", Icons.check_circle_outline, Colors.blue),
        _buildAttendanceStat("Absent", "8", Icons.highlight_off, Colors.orange),
        _buildAttendanceStat("Attendance", "90%", Icons.percent, Colors.purple),
      ],
    );
  }

  Widget _buildAttendanceStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
