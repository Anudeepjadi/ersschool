import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

// Mock events shared across the popup
final Map<String, List<Map<String, String>>> schoolEvents = {
  "2026-06-24": [
    {
      "title": "Science Exhibition",
      "time": "10:00 AM - 02:00 PM",
      "location": "School Auditorium",
      "desc": "Annual Science Projects display by Middle School students.",
      "type": "Exhibition"
    }
  ],
  "2026-06-25": [
    {
      "title": "Parents Teacher Meeting",
      "time": "09:00 AM - 11:00 AM",
      "location": "Conference Hall",
      "desc": "Discussion regarding Quarterly Exam results and progress report.",
      "type": "Meeting"
    }
  ],
  "2026-06-30": [
    {
      "title": "Art & Craft Workshop",
      "time": "11:00 AM - 01:00 PM",
      "location": "Activity Room",
      "desc": "Hands-on pottery and painting workshop for Class 6-8.",
      "type": "Workshop"
    }
  ],
  "2026-07-01": [
    {
      "title": "School Reopens",
      "time": "08:30 AM",
      "location": "Main Assembly Ground",
      "desc": "New Academic Term begins. All students must report by 8:30 AM.",
      "type": "Academic"
    }
  ],
};

/// Call this to show the calendar popup
void showCalendarPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const _CalendarPopup(),
  );
}

class _CalendarPopup extends StatefulWidget {
  const _CalendarPopup();

  @override
  State<_CalendarPopup> createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<_CalendarPopup> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2026, 5, 24);
    _currentMonth = DateTime(2026, 5, 1);
  }

  void _nextMonth() => setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      });

  void _prevMonth() => setState(() {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      });

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysBefore = first.weekday - 1;
    final firstToDisplay = first.subtract(Duration(days: daysBefore));
    final last = DateTime(month.year, month.month + 1, 0);
    final daysAfter = last.weekday == 7 ? 0 : 7 - last.weekday;
    final lastToDisplay = last.add(Duration(days: daysAfter));

    final list = <DateTime>[];
    DateTime temp = firstToDisplay;
    while (!temp.isAfter(lastToDisplay)) {
      list.add(temp);
      temp = temp.add(const Duration(days: 1));
    }
    return list;
  }

  String _monthName(int m) => const [
        "", "Jan", "Feb", "Mar", "Apr", "Jun", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
      ][m];

  String _dateKey(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Color _typeColor(String type) {
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

  @override
  Widget build(BuildContext context) {
    final days = _daysInMonth(_currentMonth);
    final selectedKey = _dateKey(_selectedDate);
    final selectedEvents = schoolEvents[selectedKey] ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    "School Calendar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),

            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // ─── Month navigator ───────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_monthName(_currentMonth.month)} ${_currentMonth.year}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2875),
                            ),
                          ),
                          Row(
                            children: [
                              _NavBtn(
                                icon: Icons.chevron_left,
                                onTap: _prevMonth,
                              ),
                              const SizedBox(width: 4),
                              _NavBtn(
                                icon: Icons.chevron_right,
                                onTap: _nextMonth,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ─── Weekday labels ────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: ["M", "T", "W", "T", "F", "S", "S"]
                            .map((d) => Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ─── Calendar Grid ────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: days.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 4,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (context, i) {
                          final day = days[i];
                          final key = _dateKey(day);
                          final isSelected = key == selectedKey;
                          final isCurrentMonth =
                              day.month == _currentMonth.month;
                          final hasEvents = schoolEvents.containsKey(key);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = day;
                                if (day.month != _currentMonth.month) {
                                  _currentMonth =
                                      DateTime(day.year, day.month, 1);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : hasEvents
                                        ? const Color(0xFFE8ECFF)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    "${day.day}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected || hasEvents
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : isCurrentMonth
                                              ? const Color(0xFF1E2875)
                                              : Colors.grey.shade400,
                                    ),
                                  ),
                                  if (hasEvents && !isSelected)
                                    Positioned(
                                      bottom: 4,
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(height: 24, indent: 20, endIndent: 20),

                    // ─── Events for selected day ──────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_monthName(_selectedDate.month)} ${_selectedDate.day} Events",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2875),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${selectedEvents.length} event(s)",
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (selectedEvents.isEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        child: Row(
                          children: [
                            Icon(Icons.event_busy,
                                color: Colors.grey.shade400, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              "No events scheduled for this day.",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    else
                      ...selectedEvents.map((ev) {
                        final tc = _typeColor(ev["type"] ?? "");
                        return Container(
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                          decoration: BoxDecoration(
                            color: tc.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: tc.withValues(alpha: 0.25), width: 1),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: tc.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      ev["type"] ?? "",
                                      style: TextStyle(
                                          color: tc,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.access_time,
                                      size: 12, color: Colors.grey.shade500),
                                  const SizedBox(width: 3),
                                  Text(
                                    ev["time"] ?? "",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ev["title"] ?? "",
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2875),
                                ),
                              ),
                              if ((ev["desc"] ?? "").isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ev["desc"]!,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      height: 1.3),
                                ),
                              ],
                              if ((ev["location"] ?? "").isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        size: 13,
                                        color: Colors.grey.shade500),
                                    const SizedBox(width: 4),
                                    Text(
                                      ev["location"]!,
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      }),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
