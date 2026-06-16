import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/empty_state_widget.dart';

class AttendanceTab extends StatelessWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _buildAttendanceStat("Total Days", "0", Colors.blue),
              const SizedBox(width: 15),
              _buildAttendanceStat("Present", "0", Colors.green),
              const SizedBox(width: 15),
              _buildAttendanceStat("Absent", "0", Colors.red),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
        const SizedBox(height: 60),
        const EmptyStateWidget(
          icon: Icons.person_outline,
          title: "No Attendance Record",
          subtitle: "Attendance record is not available for this date.",
        ),
      ],
    );
  }

  Widget _buildAttendanceStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
