import 'package:flutter/material.dart';
import '../dashboard/widgets/student_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final Function(int)? onTabSelected;

  const PrivacyPolicyScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: StudentAppBar(
        title: "Privacy Policy".tr,
        subtitle: "How we protect your data",
        onOpenDrawer: () => Scaffold.of(context).openDrawer(),
        onProfileTap: onTabSelected != null ? () => onTabSelected!(1) : null,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "Introduction".tr,
              "Your privacy is important to us. It is Ecstasy School's policy to respect your privacy regarding any information we may collect from you through our app.".tr,
            ),
            _buildSection(
              "Information We Collect".tr,
              "We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent.".tr,
            ),
            _buildSection(
              "How We Use Information".tr,
              "We use your information to provide educational services, manage student records, and facilitate communication between the school, parents, and students.".tr,
            ),
            _buildSection(
              "Data Security".tr,
              "We protect your data with commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use, or modification.".tr,
            ),
            _buildSection(
              "Contact Us".tr,
              "If you have any questions about how we handle user data and personal information, feel free to contact us at support@ecstasyschool.com".tr,
            ),
            SizedBox(height: 30),
            Center(
              child: Text(
                "Last Updated: June 2026".tr,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
