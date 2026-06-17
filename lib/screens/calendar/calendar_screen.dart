import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _activeTab = 0; // 0: Calendar, 1: Holidays List
  DateTime _selectedDate = DateTime(2026, 5, 20);
  String _selectedSchool = "Ecstasy School 1";

  final List<String> _schools = ["Ecstasy School 1", "Ecstasy School 2", "Ecstasy School 3"];

  // Days mapping in June 2026
  // Starting day is Wednesday (Sun=0, Mon=1, Tue=2, Wed=3).
  // So April has 3 days: 28, 29, 30.
  // June has 1 day: 1.
  final List<DateTime> _juneGridDays = [
    // Row 1
    DateTime(2026, 4, 28), DateTime(2026, 4, 29), DateTime(2026, 4, 30),
    DateTime(2026, 5, 1), DateTime(2026, 5, 2), DateTime(2026, 5, 3), DateTime(2026, 5, 4),
    // Row 2
    DateTime(2026, 5, 5), DateTime(2026, 5, 6), DateTime(2026, 5, 7),
    DateTime(2026, 5, 8), DateTime(2026, 5, 9), DateTime(2026, 5, 10), DateTime(2026, 5, 11),
    // Row 3
    DateTime(2026, 5, 12), DateTime(2026, 5, 13), DateTime(2026, 5, 14),
    DateTime(2026, 5, 15), DateTime(2026, 5, 16), DateTime(2026, 5, 17), DateTime(2026, 5, 18),
    // Row 4
    DateTime(2026, 5, 19), DateTime(2026, 5, 20), DateTime(2026, 5, 21),
    DateTime(2026, 5, 22), DateTime(2026, 5, 23), DateTime(2026, 5, 24), DateTime(2026, 5, 25),
    // Row 5
    DateTime(2026, 5, 26), DateTime(2026, 5, 27), DateTime(2026, 5, 28),
    DateTime(2026, 5, 29), DateTime(2026, 5, 30), DateTime(2026, 5, 31), DateTime(2026, 6, 1),
  ];

  // Map dates to dot colors
  Color? _getEventColor(DateTime day) {
    if (day.month != 5 || day.year != 2026) return null;
    if (day.day == 24) return const Color(0xFF8B5CF6); // Purple (Exams)
    if (day.day == 25) return const Color(0xFF22C55E); // Green (Meetings)
    if (day.day == 27) return const Color(0xFFEF4444); // Red (Holidays)
    if (day.day == 31) return const Color(0xFFF59E0B); // Orange (Events)
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00145A), Color(0xFF00228C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 12,
        right: 12,
        bottom: 20,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              "Calendar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // School selector dropdown represented as PopupMenuButton
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _selectedSchool = value;
              });
            },
            offset: const Offset(0, 40),
            itemBuilder: (BuildContext context) {
              return _schools.map((String school) {
                return PopupMenuItem<String>(
                  value: school,
                  child: Text(school, style: const TextStyle(fontSize: 13)),
                );
              }).toList();
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      _selectedSchool,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.keyboard_arrow_down, size: 14, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Notification indicator
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No new notifications")),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Center(
                    child: Text(
                      "5",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Student Profile Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/student_profile.png",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
    final Color color = isActive ? AppColors.primary : const Color(0xFF6B7280);
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
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
            const SizedBox(height: 10),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: const BorderRadius.only(
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
              padding: const EdgeInsets.all(20),
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
                            const SizedBox(height: 16),
                            _buildLegendRow(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 3,
                        child: _buildEventsListCard(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildHolidaysSection(),
                ],
              ),
            );
          } else {
            // Mobile portrait layout (stacked vertically)
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendarGridCard(),
                  const SizedBox(height: 12),
                  _buildLegendRow(),
                  const SizedBox(height: 24),
                  _buildEventsListCard(),
                  const SizedBox(height: 32),
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
        padding: const EdgeInsets.all(16),
        child: _buildHolidaysSection(),
      );
    }
  }

  Widget _buildCalendarGridCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "June 2026",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20, color: Color(0xFF1E2875)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Currently viewing June 2026")),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20, color: Color(0xFF1E2875)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Currently viewing June 2026")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 8),
          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _juneGridDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final day = _juneGridDays[index];
              final isCurrentMonth = day.month == 5;
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
                    color: isSelected ? const Color(0xFF0038FF) : Colors.transparent,
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
                                  ? const Color(0xFF1E2875)
                                  : Colors.grey.shade300,
                        ),
                      ),
                      if (dotColor != null && !isSelected) ...[
                        const SizedBox(height: 2),
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
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            _buildLegendItem(const Color(0xFF8B5CF6), "Exams"),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF22C55E), "Meetings"),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFFF59E0B), "Events"),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFFEF4444), "Holidays"),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF3B82F6), "Others"),
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
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1E2875),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEventsListCard() {
    final bool isSelectedDateJune20 = _selectedDate.day == 20 && _selectedDate.month == 5 && _selectedDate.year == 2026;
    final List<Map<String, String>> displayedEvents;

    if (isSelectedDateJune20) {
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
    } else if (_selectedDate.day == 24 && _selectedDate.month == 5 && _selectedDate.year == 2026) {
      displayedEvents = [
        {
          "title": "Class Test - Science",
          "time": "09:00 AM - 10:30 AM",
          "location": "Room 103",
          "type": "Exam"
        }
      ];
    } else if (_selectedDate.day == 25 && _selectedDate.month == 5 && _selectedDate.year == 2026) {
      displayedEvents = [
        {
          "title": "Parent Teacher Meeting - Class 8",
          "time": "11:30 AM - 12:30 PM",
          "location": "Conference Hall",
          "type": "Meeting"
        }
      ];
    } else if (_selectedDate.day == 27 && _selectedDate.month == 5 && _selectedDate.year == 2026) {
      displayedEvents = [
        {
          "title": "Summer Break Begins",
          "time": "All Day",
          "location": "School Closed",
          "type": "Holiday"
        }
      ];
    } else if (_selectedDate.day == 31 && _selectedDate.month == 5 && _selectedDate.year == 2026) {
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Events on ${_selectedDate.day} ${_monthName(_selectedDate.month)} ${_selectedDate.year}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
          ),
          const SizedBox(height: 16),
          if (displayedEvents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, color: Colors.grey.shade300, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      "No events scheduled for this day.",
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
        color = const Color(0xFF8B5CF6);
        bgColor = const Color(0xFFF3E8FF);
        break;
      case "Meeting":
        icon = Icons.people_outline;
        color = const Color(0xFF22C55E);
        bgColor = const Color(0xFFDCFCE7);
        break;
      case "Event":
        icon = Icons.science_outlined;
        color = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFFEF3C7);
        break;
      case "Holiday":
        icon = Icons.beach_access_outlined;
        color = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEE2E2);
        break;
      default:
        icon = Icons.directions_run_outlined;
        color = const Color(0xFF3B82F6);
        bgColor = const Color(0xFFDBEAFE);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      ev["time"] ?? "",
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
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

  String _monthName(int month) {
    const months = ["", "Jan", "Feb", "Mar", "Apr", "June", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month];
  }

  Widget _buildHolidaysSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Holidays List",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Downloading Holiday Calendar...")),
                );
              },
              icon: const Icon(Icons.download, size: 16, color: AppColors.primary),
              label: const Text(
                "Download",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Table headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Holiday Name",
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "Date",
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Day",
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  "Description",
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _buildHolidayRow("Summer Break", "20 June 2026 - 15 Jun 2026", "Mon - Sat", "School closed for summer vacation.", const Color(0xFFEF4444), const Color(0xFFFEE2E2), Icons.beach_access),
        _buildHolidayRow("Independence Day", "15 Aug 2026", "Thursday", "National holiday.", const Color(0xFFF59E0B), const Color(0xFFFEF3C7), Icons.flag),
        _buildHolidayRow("Janmashtami", "26 Aug 2026", "Monday", "Celebration of Lord Krishna's birthday.", const Color(0xFF22C55E), const Color(0xFFDCFCE7), Icons.celebration),
        _buildHolidayRow("Gandhi Jayanti", "02 Oct 2026", "Wednesday", "Birth anniversary of Mahatma Gandhi.", const Color(0xFF8B5CF6), const Color(0xFFF3E8FF), Icons.person),
        _buildHolidayRow("Diwali Break", "30 Oct 2026 - 03 Nov 2026", "Wed - Sun", "Festival of Lights.", const Color(0xFF3B82F6), const Color(0xFFDBEAFE), Icons.wb_sunny),
      ],
    );
  }

  Widget _buildHolidayRow(String name, String date, String day, String desc, Color color, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
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
