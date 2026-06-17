import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class MyInfoTab extends StatelessWidget {
  const MyInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.secondary,
              backgroundImage: AssetImage("assets/images/student_profile.png"),
            ),
            const SizedBox(height: 16),
            const Text(
              "Anudeep Jaadi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            const Text(
              "Class 8-A | Roll No: 24",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            _buildInfoTile(
              Icons.email_outlined,
              "Email",
              "anudeep.jaadi@school.com",
            ),
            _buildInfoTile(
              Icons.phone_iphone_outlined,
              "Mobile",
              "+91 98765 43210",
            ),
            _buildInfoTile(
              Icons.cake_outlined,
              "Date of Birth",
              "12 August 2011",
            ),
            _buildInfoTile(
              Icons.location_on_outlined,
              "Address",
              "102, Sunrise Apartments, Mumbai",
            ),
            _buildInfoTile(
              Icons.people_outline,
              "Parents",
              "Mr. Rajesh & Mrs. Sunita Sharma",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
      ),
    );
  }
}
