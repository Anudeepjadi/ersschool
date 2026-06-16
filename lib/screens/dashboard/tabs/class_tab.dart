import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'class_sub_tabs/timetable_tab.dart';
import 'class_sub_tabs/diary_tab.dart';
import 'class_sub_tabs/assignments_tab.dart';
import 'class_sub_tabs/attendance_tab.dart';

class ClassTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const ClassTab({super.key, this.onOpenDrawer});

  @override
  State<ClassTab> createState() => _ClassTabState();
}

class _ClassTabState extends State<ClassTab> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _subTabs = [
    {'title': 'Timetable', 'icon': Icons.calendar_today_outlined},
    {'title': 'Diary', 'icon': Icons.menu_book_outlined},
    {'title': 'Assignments', 'icon': Icons.assignment_outlined},
    {'title': 'Attendance', 'icon': Icons.person_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // 1. Header Section
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  onPressed: widget.onOpenDrawer,
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Class",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Access your class related information",
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text("Ecstasy School 1", style: TextStyle(color: Colors.white, fontSize: 11)),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 14),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Stack(
                  children: [
                    const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 28),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: const Text("5", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          // 2. White Content Area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Sub-tabs row (Sticky)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_subTabs.length, (index) {
                        bool isSelected = _selectedTabIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedTabIndex = index),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _subTabs[index]['icon'],
                                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                size: 26,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _subTabs[index]['title'],
                                style: TextStyle(
                                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                height: 2,
                                width: isSelected ? 40 : 0,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),

                  const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (_selectedTabIndex == 0) const TimetableTab(),
                          if (_selectedTabIndex == 1) const DiaryTab(),
                          if (_selectedTabIndex == 2) const AssignmentsTab(),
                          if (_selectedTabIndex == 3) const AttendanceTab(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
}
