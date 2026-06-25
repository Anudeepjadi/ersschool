import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class HomeScreen extends StatelessWidget {
  final Function(int, {int? subTab, String? moreSubScreen}) onNavigateTab;

  HomeScreen({Key? key, required this.onNavigateTab}) : super(key: key);

  void _showStatDetail(
    BuildContext context,
    String title,
    List<Map<String, String>> data,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B263B),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: data.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  item['title'] ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] ?? "",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: item['trailing'] != null
                    ? Text(
                        item['trailing']!,
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close".tr),
          ),
        ],
      ),
    );
  }

  void _showPendingTasksDialog(BuildContext context) {
    _showStatDetail(context, "All Pending Tasks", [
      {
        'title': 'Check Assignments',
        'subtitle': 'Mathematics Class 8-A',
        'trailing': '8 Pending',
      },
      {
        'title': 'Grade Submissions',
        'subtitle': 'Unit Test - I Science',
        'trailing': '5 Pending',
      },
      {
        'title': 'Mark Attendance',
        'subtitle': 'Class 9-B & 10-A',
        'trailing': '2 Classes',
      },
      {
        'title': 'Announcements',
        'subtitle': 'Staff Meeting Follow-up',
        'trailing': '1 Unread',
      },
      {
        'title': 'Upload Lesson Plan',
        'subtitle': 'Next week syllabus',
        'trailing': 'Due Today',
      },
      {
        'title': 'Parent Feedback',
        'subtitle': '5 responses to review',
        'trailing': 'New',
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),

          // 1. Top Quick Action Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTopActionItem(
                      context,
                      Icons.how_to_reg,
                      "Mark Attendance",
                      () {
                        onNavigateTab(1, subTab: 2);
                      },
                      Colors.purple,
                    ),
                    _buildTopActionItem(
                      context,
                      Icons.class_,
                      "My Classes",
                      () {
                        onNavigateTab(1, subTab: 0);
                      },
                      Colors.green,
                    ),
                    _buildTopActionItem(
                      context,
                      Icons.assignment,
                      "Assignments",
                      () {
                        onNavigateTab(1, subTab: 4);
                      },
                      Colors.orange,
                    ),
                    _buildTopActionItem(
                      context,
                      Icons.description,
                      "Examinations",
                      () {
                        onNavigateTab(3);
                      },
                      Colors.blue,
                    ),
                    _buildTopActionItem(
                      context,
                      Icons.bar_chart,
                      "Reports",
                      () {
                        onNavigateTab(4);
                      },
                      Colors.red,
                    ),
                    _buildTopActionItem(
                      context,
                      Icons.calendar_month,
                      "Calendar",
                      () {
                        onNavigateTab(5, moreSubScreen: "Calendar");
                      },
                      Colors.indigo,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),

          // 2. Overview Stats
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Overview".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButton<String>(
                    value: "This Week",
                    underline: SizedBox(),
                    icon: Icon(Icons.keyboard_arrow_down, size: 18),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    onChanged: (newValue) {},
                    items: [
                      DropdownMenuItem(
                          value: "This Week", child: Text("This Week".tr)),
                      DropdownMenuItem(
                          value: "This Month", child: Text("This Month".tr)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 140, // Increased for new StatCard design
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Classes Assigned",
                  value: "6",
                  icon: Icons.school,
                  iconColor: Colors.blue,
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                  onTap: () => _showStatDetail(context, "Assigned Classes", [
                    {
                      'title': 'Class 8 - A',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 101',
                    },
                    {
                      'title': 'Class 9 - B',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 103',
                    },
                    {
                      'title': 'Class 8 - C',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 105',
                    },
                    {
                      'title': 'Class 10 - A',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 106',
                    },
                    {
                      'title': 'Class 7 - B',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 102',
                    },
                    {
                      'title': 'Class 11 - A',
                      'subtitle': 'Mathematics',
                      'trailing': 'Room 201',
                    },
                  ]),
                ),
                StatCard(
                  title: "Total Students",
                  value: "138",
                  icon: Icons.people,
                  iconColor: Colors.green,
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                  onTap: () => _showStatDetail(context, "Student Attendance", [
                    {
                      'title': 'Total Enrolled',
                      'subtitle': 'Across all classes',
                      'trailing': '138',
                    },
                    {
                      'title': 'Present Today',
                      'subtitle': 'Status as of 12:30 PM',
                      'trailing': '125',
                    },
                    {
                      'title': 'Absent Today',
                      'subtitle': 'Leave / Uninformed',
                      'trailing': '13',
                    },
                    {
                      'title': 'On Leave',
                      'subtitle': 'Approved requests',
                      'trailing': '5',
                    },
                  ]),
                ),
                StatCard(
                  title: "Assignments",
                  value: "12",
                  icon: Icons.assignment_outlined,
                  iconColor: Colors.orange,
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                  onTap: () => _showStatDetail(context, "Current Assignments", [
                    {
                      'title': 'Algebraic Expressions',
                      'subtitle': 'Class 8-A',
                      'trailing': 'Pending',
                    },
                    {
                      'title': 'Linear Equations',
                      'subtitle': 'Class 9-B',
                      'trailing': 'Completed',
                    },
                    {
                      'title': 'Trigonometry Intro',
                      'subtitle': 'Class 10-A',
                      'trailing': 'Review',
                    },
                    {
                      'title': 'Statistics Basics',
                      'subtitle': 'Class 8-C',
                      'trailing': 'New',
                    },
                  ]),
                ),
                StatCard(
                  title: "Exams Scheduled",
                  value: "2",
                  icon: Icons.event,
                  iconColor: Colors.purple,
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                  onTap: () => _showStatDetail(context, "Upcoming Exams", [
                    {
                      'title': 'Unit Test - I',
                      'subtitle': 'Mathematics (All 8th)',
                      'trailing': '25 May',
                    },
                    {
                      'title': 'Term Final',
                      'subtitle': 'Mathematics (Class 10)',
                      'trailing': '15 June',
                    },
                  ]),
                ),
                StatCard(
                  title: "Teaching Hours",
                  value: "18h 30m",
                  icon: Icons.timer,
                  iconColor: Colors.red,
                  iconBackgroundColor: Colors.red.withValues(alpha: 0.1),
                  onTap: () => _showStatDetail(context, "Teaching Hours", [
                    {
                      'title': 'Weekly Target',
                      'subtitle': 'Mandatory hours',
                      'trailing': '20h',
                    },
                    {
                      'title': 'Completed',
                      'subtitle': 'This week',
                      'trailing': '18h 30m',
                    },
                    {
                      'title': 'Extra Classes',
                      'subtitle': 'Remedial sessions',
                      'trailing': '2h',
                    },
                  ]),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // 3. Today's Schedule
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B263B),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onNavigateTab(1, subTab: 1);
                  },
                  child: Text("View Timetable >".tr,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildScheduleCard(
                context,
                "08:00 AM\n- 08:45 AM",
                "Mathematics",
                "Class 8 - A",
                "Room 101",
                false,
              ),
              _buildScheduleCard(
                context,
                "09:00 AM\n- 09:45 AM",
                "Mathematics",
                "Class 9 - B",
                "Room 103",
                false,
              ),
              _buildScheduleCard(
                context,
                "10:00 AM\n- 10:45 AM",
                "Mathematics",
                "Class 8 - C",
                "Room 105",
                false,
              ),
              _buildScheduleCard(
                context,
                "10:45 AM\n- 11:00 AM",
                "Break Time",
                "",
                "",
                true,
              ),
              _buildScheduleCard(
                context,
                "11:00 AM\n- 11:45 AM",
                "Mathematics",
                "Class 10 - A",
                "Room 106",
                false,
              ),
            ],
          ),
          SizedBox(height: 16),

          // 4. Pending Tasks & Upcoming Events
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Pending Tasks".tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B263B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () => _showPendingTasksDialog(context),
                          child: Text("View All".tr,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildPendingTaskCard(
                      Icons.checklist,
                      "Check Assignments",
                      "8 Pending",
                      Colors.purple,
                      () => _showStatDetail(context, "Check Assignments", [
                        {
                          'title': 'Math Set A',
                          'subtitle': 'Class 8-A',
                          'trailing': '5 items',
                        },
                        {
                          'title': 'Math Set B',
                          'subtitle': 'Class 8-A',
                          'trailing': '3 items',
                        },
                      ]),
                    ),
                    _buildPendingTaskCard(
                      Icons.grade,
                      "Grade Submissions",
                      "5 Pending",
                      Colors.orange,
                      () => _showStatDetail(context, "Grade Submissions", [
                        {
                          'title': 'Unit Test 1',
                          'subtitle': 'Science Class 9-A',
                          'trailing': '5 pending',
                        },
                      ]),
                    ),
                    _buildPendingTaskCard(
                      Icons.how_to_reg,
                      "Mark Attendance",
                      "2 Classes",
                      Colors.blue,
                      () => _showStatDetail(context, "Mark Attendance", [
                        {
                          'title': 'Class 9-B',
                          'subtitle': 'Morning Session',
                          'trailing': 'Not Marked',
                        },
                        {
                          'title': 'Class 10-A',
                          'subtitle': 'Afternoon Session',
                          'trailing': 'Not Marked',
                        },
                      ]),
                    ),
                    _buildPendingTaskCard(
                      Icons.campaign,
                      "Announcements",
                      "1 Unread",
                      Colors.green,
                      () => _showStatDetail(context, "Announcements", [
                        {
                          'title': 'Staff Meeting',
                          'subtitle': 'Rescheduled to 4 PM',
                          'trailing': 'New',
                        },
                      ]),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Upcoming Events".tr,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B263B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            onNavigateTab(
                              5,
                              moreSubScreen: "Calendar",
                            ); // Go to Calendar
                          },
                          child: Text("View Calendar".tr,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    _buildUpcomingEventCard(
                      context,
                      "MAY\n25",
                      "Unit Test - Mathematics (Class 8)",
                      "10:00 AM | Exam Hall 1",
                      () => _showStatDetail(
                        context,
                        "Unit Test - Mathematics",
                        [
                          {
                            'title': 'Subject',
                            'subtitle': 'Mathematics (Set A)',
                            'trailing': 'Class 8',
                          },
                          {
                            'title': 'Time',
                            'subtitle': 'Duration: 1h 30m',
                            'trailing': '10:00 AM',
                          },
                          {
                            'title': 'Location',
                            'subtitle': 'School Building Block B',
                            'trailing': 'Hall 1',
                          },
                        ],
                      ),
                    ),
                    _buildUpcomingEventCard(
                      context,
                      "MAY\n27",
                      "Parent Teacher Meeting",
                      "11:30 AM | Conference Room",
                      () => _showStatDetail(context, "Parent Teacher Meeting", [
                        {
                          'title': 'Agenda',
                          'subtitle': 'Term 1 Performance Discussion',
                          'trailing': 'PTM',
                        },
                        {
                          'title': 'Time',
                          'subtitle': 'Slot: 11:30 AM - 01:30 PM',
                          'trailing': '11:30 AM',
                        },
                        {
                          'title': 'Location',
                          'subtitle': 'Main Admin Block',
                          'trailing': 'Room 102',
                        },
                      ]),
                    ),
                    _buildUpcomingEventCard(
                      context,
                      "MAY\n31",
                      "Science Exhibition",
                      "01:00 PM | School Auditorium",
                      () => _showStatDetail(context, "Science Exhibition", [
                        {
                          'title': 'Event',
                          'subtitle': 'Annual Science & Tech Fair',
                          'trailing': 'School-wide',
                        },
                        {
                          'title': 'Coordinator',
                          'subtitle': 'Mr. Ramesh Kumar',
                          'trailing': 'Lead',
                        },
                        {
                          'title': 'Location',
                          'subtitle': 'Assembly Grounds',
                          'trailing': 'Auditorium',
                        },
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // 5. Staff Meeting Announcement
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                _showStatDetail(context, "Available Staff Meetings", [
                  {
                    'title': 'Monthly Staff Meeting',
                    'subtitle': '22 May 2024 at 3:00 PM',
                    'trailing': 'Conference Room',
                  },
                  {
                    'title': 'Department Heads Sync',
                    'subtitle': '23 May 2024 at 10:00 AM',
                    'trailing': 'Principal Office',
                  },
                  {
                    'title': 'Curriculum Review',
                    'subtitle': '25 May 2024 at 4:00 PM',
                    'trailing': 'Staff Room',
                  },
                  {
                    'title': 'Exam Coordination',
                    'subtitle': '28 May 2024 at 11:30 AM',
                    'trailing': 'Meeting Hall 2',
                  },
                ]);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.volume_up,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text("Staff Meeting".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B263B),
                          ),
                        ),
                        Spacer(),
                        Text("20 May 2024".tr,
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("Monthly staff meeting will be held on 22 May 2024 at 3:00 PM in the conference room. All teachers are requested to attend.".tr,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          onNavigateTab(
                            5,
                            moreSubScreen: "Meetings",
                            subTab: 0,
                          ); // Redirect to Schedule Meeting
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text("New".tr,
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTopActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    Color color,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 85,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(
    BuildContext context,
    String time,
    String subject,
    String className,
    String room,
    bool isBreak,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isBreak ? Colors.purple[50]?.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: isBreak ? Colors.purple[100]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              time,
              style: TextStyle(
                color: isBreak ? Colors.purple[600] : Colors.blue[800],
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 24, width: 1, color: Colors.grey[300]),
          SizedBox(width: 16),
          Icon(
            isBreak ? Icons.local_cafe : Icons.menu_book,
            color: isBreak ? Colors.purple : Colors.blue,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color:
                        isBreak ? Colors.purple[900] : Color(0xFF1B263B),
                  ),
                ),
                if (!isBreak) ...[
                  SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          className,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.location_on,
                            size: 12, color: Colors.grey),
                        SizedBox(width: 2),
                        Text(
                          room,
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isBreak) ...[
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Edit schedule clicked".tr)),
                  );
                } else if (value == 'remove') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Remove schedule clicked".tr)),
                  );
                }
              },
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: Colors.grey, size: 20),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Edit'.tr, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Remove'.tr, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingTaskCard(
    IconData icon,
    String title,
    String status,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, color: color, size: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingEventCard(
    BuildContext context,
    String date,
    String title,
    String details,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                date,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[800],
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    details,
                    style: TextStyle(color: Colors.grey, fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
