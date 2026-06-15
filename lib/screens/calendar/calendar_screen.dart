import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  // Mock events map: key is "yyyy-MM-dd"
  final Map<String, List<Map<String, String>>> _events = {
    "2026-05-24": [
      {
        "title": "Science Exhibition",
        "time": "10:00 AM - 02:00 PM",
        "location": "School Auditorium",
        "desc": "Annual Science Projects display by Middle School students.",
        "type": "Exhibition"
      }
    ],
    "2026-05-25": [
      {
        "title": "Parents Teacher Meeting",
        "time": "09:00 AM - 11:00 AM",
        "location": "Conference Hall",
        "desc": "Discussion regarding Quarterly Exam results and progress report.",
        "type": "Meeting"
      }
    ],
    "2026-05-30": [
      {
        "title": "Art & Craft Workshop",
        "time": "11:00 AM - 01:00 PM",
        "location": "Activity Room",
        "desc": "Hands-on pottery and painting workshop for Class 6-8.",
        "type": "Workshop"
      }
    ],
    "2026-06-15": [
      {
        "title": "School Reopens",
        "time": "08:30 AM",
        "location": "Main Assembly Ground",
        "desc": "New Academic Term begins. All students must report by 8:30 AM.",
        "type": "Academic"
      }
    ],
  };

  @override
  void initState() {
    super.initState();
    // Default to May 2026 to align with the database/mock data shown in the mockup screenshots!
    _selectedDate = DateTime(2026, 5, 24);
    _currentMonth = DateTime(2026, 5, 1);
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = first.weekday - 1; // Days from previous month to show (assuming Monday is first day of week)
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 7 - last.weekday;
    final lastToDisplay = last.add(Duration(days: daysAfter));

    final List<DateTime> list = [];
    DateTime temp = firstToDisplay;
    while (temp.isBefore(lastToDisplay) || temp.isAtSameMomentAs(lastToDisplay)) {
      list.add(temp);
      temp = temp.add(const Duration(days: 1));
    }
    return list;
  }

  String _getMonthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_currentMonth);
    final dateKey = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
    final selectedDayEvents = _events[dateKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("School Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventBottomSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Month Selector Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_getMonthName(_currentMonth.month)} ${_currentMonth.year}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Color(0xFF1E2875)),
                      onPressed: _prevMonth,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Color(0xFF1E2875)),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Weekdays row
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeekdayHeader("M"),
                _WeekdayHeader("T"),
                _WeekdayHeader("W"),
                _WeekdayHeader("T"),
                _WeekdayHeader("F"),
                _WeekdayHeader("S"),
                _WeekdayHeader("S"),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Calendar Days Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                final isSelected = day.year == _selectedDate.year &&
                    day.month == _selectedDate.month &&
                    day.day == _selectedDate.day;
                final isCurrentMonth = day.month == _currentMonth.month;
                
                final dayKey = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
                final hasEvents = _events.containsKey(dayKey);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = day;
                      if (day.month != _currentMonth.month) {
                        _currentMonth = DateTime(day.year, day.month, 1);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (hasEvents ? AppColors.secondary.withValues(alpha: 0.15) : Colors.transparent),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (hasEvents ? AppColors.secondary.withValues(alpha: 0.3) : Colors.transparent),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "${day.day}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected || hasEvents ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : (isCurrentMonth ? const Color(0xFF1E2875) : Colors.grey.shade400),
                          ),
                        ),
                        if (hasEvents && !isSelected)
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 30, thickness: 1, indent: 20, endIndent: 20),

          // Events header for selected day
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Events for ${_getMonthName(_selectedDate.month)} ${_selectedDate.day}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                Text(
                  "${selectedDayEvents.length} Event(s)",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Events List for selected day
          Expanded(
            child: selectedDayEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          "No events scheduled for this day",
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount: selectedDayEvents.length,
                    itemBuilder: (context, index) {
                      final ev = selectedDayEvents[index];
                      final typeColor = _getEventTypeColor(ev["type"] ?? "");

                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: typeColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ev["type"] ?? "Event",
                                      style: TextStyle(
                                        color: typeColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    ev["time"] ?? "",
                                    style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ev["title"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2875),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                ev["desc"] ?? "",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    ev["location"] ?? "",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case "Exhibition":
        return Colors.purple;
      case "Meeting":
        return Colors.green;
      case "Workshop":
        return Colors.blue;
      case "Academic":
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  void _showAddEventBottomSheet() {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final locationController = TextEditingController();
    final descController = TextEditingController();
    String type = "Meeting";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Add School Event",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Event Title",
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: "Time (e.g. 10:00 AM - 12:00 PM)",
                        prefixIcon: Icon(Icons.access_time),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: "Location (e.g. School Auditorium)",
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(
                        labelText: "Event Type",
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: ["Meeting", "Exhibition", "Workshop", "Academic", "Other"]
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            type = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        if (titleController.text.isNotEmpty && timeController.text.isNotEmpty) {
                          final dateKey = "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";
                          final newEvent = {
                            "title": titleController.text,
                            "time": timeController.text,
                            "location": locationController.text.isEmpty ? "TBD" : locationController.text,
                            "desc": descController.text.isEmpty ? "" : descController.text,
                            "type": type,
                          };

                          setState(() {
                            if (_events.containsKey(dateKey)) {
                              _events[dateKey]!.add(newEvent);
                            } else {
                              _events[dateKey] = [newEvent];
                            }
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Event added successfully!")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Title and Time are required.")),
                          );
                        }
                      },
                      child: const Text("Save Event"),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String label;
  const _WeekdayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF1E2875),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
