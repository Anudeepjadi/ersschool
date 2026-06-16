import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TimetableTab extends StatelessWidget {
  const TimetableTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date Selector
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.chevron_left, color: Colors.grey.shade400),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  const Text(
                    "Monday, 20 May 2024",
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 18),
                ],
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),

        // Timetable Table
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Timetable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View Full Timetable", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Table Header
              Row(
                children: [
                  _tableHeaderText("Period", 1),
                  _tableHeaderText("Time", 2),
                  _tableHeaderText("Subject", 3),
                  _tableHeaderText("Teacher", 3),
                  _tableHeaderText("Room", 1),
                ],
              ),
              const SizedBox(height: 20),
              _buildTimetableRow("1", "08:00 AM\n- 08:45 AM", "Mathematics", "MATH", "Mr. Amit Verma", "101", Colors.blue),
              _buildTimetableRow("2", "08:45 AM\n- 09:30 AM", "English", "ENG", "Ms. Priya Sharma", "102", Colors.green),
              _buildTimetableRow("3", "09:30 AM\n- 10:15 AM", "Science", "SCI", "Mr. Rahul Mehta", "103", Colors.orange),

              // Break Time
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.restaurant, color: Colors.grey.shade400, size: 16),
                    const SizedBox(width: 10),
                    const Text("Break Time", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                    const Spacer(),
                    const Text("10:15 AM - 10:30 AM", style: TextStyle(color: Color(0xFF5A629B), fontSize: 11)),
                  ],
                ),
              ),

              _buildTimetableRow("4", "10:30 AM\n- 11:15 AM", "Social Science", "SST", "Ms. Neha Gupta", "104", Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tableHeaderText(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildTimetableRow(String period, String time, String subject, String subjectCode, String teacher, String room, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: Text(period, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14))),
          Expanded(flex: 2, child: Text(time, style: const TextStyle(fontSize: 10, color: Colors.black87, height: 1.3))),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Icon(Icons.menu_book_outlined, color: color, size: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                      Text(subjectCode, style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const CircleAvatar(radius: 10, backgroundColor: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(teacher, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500))),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(room, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12))),
        ],
      ),
    );
  }
}
