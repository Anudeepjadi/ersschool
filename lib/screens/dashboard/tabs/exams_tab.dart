import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ExamsTab extends StatelessWidget {
  const ExamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Exams", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Examination Overview"),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOverviewItem(Icons.assignment, "Total Exams", "12", Colors.blue),
                _buildOverviewItem(Icons.check_circle_outline, "Completed", "7", Colors.green),
                _buildOverviewItem(Icons.calendar_today, "Upcoming", "5", Colors.orange),
                _buildOverviewItem(Icons.auto_graph, "Average Score", "85.6%", Colors.purple),
              ],
            ),
            const SizedBox(height: 30),
            _buildSectionHeader("Upcoming Exams", trailing: "View Timetable >"),
            const SizedBox(height: 15),
            _buildTableHeaders(["Exam Name", "Subject", "Date", "Time"]),
            _buildUpcomingExamRow("Unit Test - 1", "Mathematics", "25 May 2024", "10:00 AM", Colors.blue),
            _buildUpcomingExamRow("Unit Test - 1", "Science", "27 May 2024", "10:00 AM", Colors.green),
            _buildUpcomingExamRow("Unit Test - 1", "English", "29 May 2024", "10:00 AM", Colors.orange),
            _buildUpcomingExamRow("Unit Test - 1", "Social Science", "31 May 2024", "10:00 AM", Colors.redAccent),
            _buildUpcomingExamRow("Unit Test - 1", "Hindi", "03 Jun 2024", "10:00 AM", Colors.indigo),
            _buildViewAllButton("View All Upcoming Exams >"),
            const SizedBox(height: 30),
            _buildSectionHeader("Recent Exam Results", trailing: "View All Results >"),
            const SizedBox(height: 15),
            _buildTableHeaders(["Exam Name", "Subject", "Marks", "Grade"]),
            _buildResultRow("Mid Term Exam", "Mathematics", "42/50", "84%", "A", Colors.green),
            _buildResultRow("Mid Term Exam", "Science", "44/50", "88%", "A", Colors.green),
            _buildResultRow("Mid Term Exam", "English", "38/50", "76%", "B+", Colors.blue),
            _buildViewAllButton("View All Results >"),
            const SizedBox(height: 30),
            _buildSectionHeader("Quick Actions"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction(Icons.calendar_month, "Term Exam\nTimetable", Colors.purple),
                _buildQuickAction(Icons.description_outlined, "Grade\nReport", Colors.green),
                _buildQuickAction(Icons.file_download_outlined, "Download\nHall Ticket", Colors.orange),
                _buildQuickAction(Icons.bar_chart, "Performance\nAnalysis", Colors.blue),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
      ],
    );
  }

  Widget _buildOverviewItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }

  Widget _buildTableHeaders(List<String> headers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: headers
            .map((h) => Expanded(
                  child: Text(
                    h,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildUpcomingExamRow(String name, String subject, String date, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.assignment_outlined, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Text("Term 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subject.substring(0, 3).toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                const Text("Monday", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String name, String subject, String marks, String percent, String grade, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      const Text("Term 1", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(subject.substring(0, 3).toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Text(marks, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Row(
              children: [
                Text(percent, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(grade, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
