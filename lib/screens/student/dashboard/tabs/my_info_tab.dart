import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/profile_manager.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class MyInfoTab extends StatelessWidget {
  MyInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Info".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: ProfileManager().studentProfileImagePath,
              builder: (context, path, _) {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: path != null ? FileImage(File(path)) : null,
                  child: path == null ? Icon(Icons.person, size: 60, color: AppColors.primary) : null,
                );
              },
            ),
            SizedBox(height: 16),
            Text("Student".tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            Text("Class 8-A | Roll No: 24".tr,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 25),
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
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
      ),
    );
  }
}
