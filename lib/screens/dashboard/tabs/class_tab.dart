import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ClassTab extends StatelessWidget {
  const ClassTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Class", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSubjectTile("Physics", "Mr. Amit Verma", Icons.menu_book_outlined, Colors.green),
          _buildSubjectTile("Mathematics", "Mrs. Kavita Rao", Icons.calculate_outlined, Colors.purple),
          _buildSubjectTile("Chemistry", "Dr. Shalini Gupta", Icons.science_outlined, Colors.orange),
          _buildSubjectTile("English", "Mrs. Sandra DSouza", Icons.edit_note_outlined, Colors.blue),
          _buildSubjectTile("Computer Science", "Mr. Rohit Sen", Icons.computer_outlined, Colors.red),
        ],
      ),
    );
  }

  Widget _buildSubjectTile(String subject, String teacher, IconData icon, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color),
        ),
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        subtitle: Text("Teacher: $teacher"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}
