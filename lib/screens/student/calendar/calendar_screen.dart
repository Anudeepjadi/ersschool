import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../dashboard/widgets/student_app_bar.dart';
import '../../admin/widgets/ai_bot_fab.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class CalendarScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final Function(int)? onTabSelected;

  const CalendarScreen({super.key, this.onOpenDrawer, this.onTabSelected});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _activeTab = 0; // 0: Calendar, 1: Holidays List
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  late List<DateTime> _gridDays;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _currentMonth = DateTime(now.year, now.month, 1);
    _generateGridDays();
  }

  void _generateGridDays() {
    final first = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysBefore = first.weekday == 7 ? 0 : first.weekday;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysAfter = 6 - (last.weekday == 7 ? 0 : last.weekday);
    final lastToDisplay = last.add(Duration(days: daysAfter));

    final list = <DateTime>[];
    DateTime temp = firstToDisplay;
    while (!temp.isAfter(lastToDisplay)) {
      list.add(temp);
      temp = temp.add(Duration(days: 1));
    }
    while (list.length % 7 != 0) {
      list.add(temp);
      temp = temp.add(Duration(days: 1));
    }
    _gridDays = list;
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _generateGridDays();
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _generateGridDays();
    });
  }

  String _monthName(int m) => [
        "", "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
      ][m];

  // Map dates to dot colors
  Color? _getEventColor(DateTime day) {
    if (day.month != _currentMonth.month) return null;
    final now = DateTime.now();
    if (day.month == now.month && day.year == now.year) {
      if (day.day == 10) return Color(0xFF8B5CF6); // Purple (Exams)
      if (day.day == 15) return Color(0xFF22C55E); // Green (Meetings)
      if (day.day == 19) return Color(0xFF22C55E); // Green (Meetings)
      if (day.day == 22) return Color(0xFFEF4444); // Red (Holidays)
      if (day.day == 28) return Color(0xFFF59E0B); // Orange (Events)
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: StudentAppBar(
        title: "Calendar",
        subtitle: "View your schedule and holidays",
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: AiBotFab(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              _buildTabItem(0, Icons.calendar_month, "Calendar"),
              _buildTabItem(1, Icons.list_alt, "Holidays List"),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isActive = _activeTab == index;
    final Color color = isActive ? AppColors.primary : Color(0xFF6B7280);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_activeTab == 0) {
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 720) {
            // Wide screen / Tablet layout
            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            _buildCalendarGridCard(),
                            SizedBox(height: 16),
                            _buildLegendRow(),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: _buildEventsListCard(),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  _buildHolidaysSection(),
                ],
              ),
            );
          } else {
            // Mobile portrait layout (stacked vertically)
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendarGridCard(),
                  SizedBox(height: 12),
                  _buildLegendRow(),
                  SizedBox(height: 24),
                  _buildEventsListCard(),
                  SizedBox(height: 32),
                  _buildHolidaysSection(),
                ],
              ),
            );
          }
        },
      );
    } else {
      // Holidays Tab view
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _buildHolidaysSection(),
      );
    }
  }

  Widget _buildCalendarGridCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_monthName(_currentMonth.month)} ${_currentMonth.year}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 20, color: Color(0xFF1E2875)),
                    onPressed: _prevMonth,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 20, color: Color(0xFF1E2875)),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Day labels
          Row(
            children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 8),
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _gridDays.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final day = _gridDays[index];
              final isCurrentMonth = day.month == _currentMonth.month;
              final isSelected = day.day == _selectedDate.day && day.month == _selectedDate.month && day.year == _selectedDate.year;
              final dotColor = _getEventColor(day);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF0038FF) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${day.day}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : isCurrentMonth
                                  ? Color(0xFF1E2875)
                                  : Colors.grey.shade300,
                        ),
                      ),
                      if (dotColor != null && !isSelected) ...[
                        SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
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

  Widget _buildLegendRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            _buildLegendItem(Color(0xFF8B5CF6), "Exams"),
            SizedBox(width: 16),
            _buildLegendItem(Color(0xFF22C55E), "Meetings"),
            SizedBox(width: 16),
            _buildLegendItem(Color(0xFFF59E0B), "Events"),
            SizedBox(width: 16),
            _buildLegendItem(Color(0xFFEF4444), "Holidays"),
            SizedBox(width: 16),
            _buildLegendItem(Color(0xFF3B82F6), "Others"),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF1E2875),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsListCard() {
    final now = DateTime.now();
    final bool isCurrentMonth = _selectedDate.month == now.month && _selectedDate.year == now.year;
    final List<Map<String, String>> displayedEvents;

    if (isCurrentMonth && _selectedDate.day == 19) {
      displayedEvents = [
        {
          "title": "Class Test - Mathematics",
          "time": "10:00 AM - 11:00 AM",
          "location": "Room 101",
          "type": "Exam"
        },
        {
          "title": "Parent Teacher Meeting",
          "time": "11:30 AM - 12:30 PM",
          "location": "Conference Hall",
          "type": "Meeting"
        },
        {
          "title": "Science Exhibition",
          "time": "01:00 PM - 03:00 PM",
          "location": "School Auditorium",
          "type": "Event"
        },
        {
          "title": "Inter House Sports",
          "time": "03:30 PM - 05:30 PM",
          "location": "School Ground",
          "type": "Other"
        },
      ];
    } else if (isCurrentMonth && _selectedDate.day == 10) {
      displayedEvents = [
        {
          "title": "Class Test - Science",
          "time": "09:00 AM - 10:30 AM",
          "location": "Room 103",
          "type": "Exam"
        }
      ];
    } else if (isCurrentMonth && _selectedDate.day == 15) {
      displayedEvents = [
        {
          "title": "Parent Teacher Meeting - Class 8",
          "time": "11:30 AM - 12:30 PM",
          "location": "Conference Hall",
          "type": "Meeting"
        }
      ];
    } else if (isCurrentMonth && _selectedDate.day == 22) {
      displayedEvents = [
        {
          "title": "Summer Break Begins",
          "time": "All Day",
          "location": "School Closed",
          "type": "Holiday"
        }
      ];
    } else if (isCurrentMonth && _selectedDate.day == 28) {
      displayedEvents = [
        {
          "title": "Annual Prize Distribution",
          "time": "10:00 AM - 01:00 PM",
          "location": "School Auditorium",
          "type": "Event"
        }
      ];
    } else {
      displayedEvents = [];
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Events on ${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
          ),
          SizedBox(height: 16),
          if (displayedEvents.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, color: Colors.grey.shade300, size: 36),
                    SizedBox(height: 8),
                    Text("No events scheduled for this day.".tr,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: displayedEvents.map((ev) => _buildEventCard(ev)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> ev) {
    IconData icon;
    Color color;
    Color bgColor;

    switch (ev["type"]) {
      case "Exam":
        icon = Icons.book_outlined;
        color = Color(0xFF8B5CF6);
        bgColor = Color(0xFFF3E8FF);
        break;
      case "Meeting":
        icon = Icons.people_outline;
        color = Color(0xFF22C55E);
        bgColor = Color(0xFFDCFCE7);
        break;
      case "Event":
        icon = Icons.science_outlined;
        color = Color(0xFFF59E0B);
        bgColor = Color(0xFFFEF3C7);
        break;
      case "Holiday":
        icon = Icons.beach_access_outlined;
        color = Color(0xFFEF4444);
        bgColor = Color(0xFFFEE2E2);
        break;
      default:
        icon = Icons.directions_run_outlined;
        color = Color(0xFF3B82F6);
        bgColor = Color(0xFFDBEAFE);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev["title"] ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                    SizedBox(width: 4),
                    Text(
                      ev["time"] ?? "",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade400),
                    SizedBox(width: 4),
                    Text(
                      ev["location"] ?? "",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHolidaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Holidays List".tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Downloading Holiday Calendar...".tr)),
                );
              },
              icon: Icon(Icons.download, size: 16, color: AppColors.primary),
              label: Text("Download".tr,
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            width: 650,
            child: Column(
              children: [
                // Table headers
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: Text("Holiday Name".tr,
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text("Date".tr,
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Day".tr,
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text("Description".tr,
                          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                _buildHolidayRow("Summer Break", "20 June 2026 - 15 Jun 2026", "Mon - Sat", "School closed for summer vacation.", Color(0xFFEF4444), Color(0xFFFEE2E2), Icons.beach_access),
                _buildHolidayRow("Independence Day", "15 Aug 2026", "Thursday", "National holiday.", Color(0xFFF59E0B), Color(0xFFFEF3C7), Icons.flag),
                _buildHolidayRow("Janmashtami", "26 Aug 2026", "Monday", "Celebration of Lord Krishna's birthday.", Color(0xFF22C55E), Color(0xFFDCFCE7), Icons.celebration),
                _buildHolidayRow("Gandhi Jayanti", "02 Oct 2026", "Wednesday", "Birth anniversary of Mahatma Gandhi.", Color(0xFF8B5CF6), Color(0xFFF3E8FF), Icons.person),
                _buildHolidayRow("Diwali Break", "30 Oct 2026 - 03 Nov 2026", "Wed - Sun", "Festival of Lights.", Color(0xFF3B82F6), Color(0xFFDBEAFE), Icons.wb_sunny),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHolidayRow(String name, String date, String day, String desc, Color color, Color bgColor, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              desc,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
