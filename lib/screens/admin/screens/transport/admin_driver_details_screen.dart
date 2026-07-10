import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/admin_app_bar.dart';
import 'package:ersschool/core/theme/app_colors.dart';

class AdminDriverDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> driver;
  const AdminDriverDetailsScreen({super.key, required this.driver});

  @override
  State<AdminDriverDetailsScreen> createState() => _AdminDriverDetailsScreenState();
}

class _AdminDriverDetailsScreenState extends State<AdminDriverDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(
        title: "Driver Details".tr,
        subtitle: "View driver information",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: "Personal Information",
                    icon: Icons.person_outline,
                    children: [
                      _buildDetailRow("Full Name", widget.driver['name'] ?? ""),
                      _buildDetailRow("Gender", widget.driver['gender'] ?? ""),
                      _buildDetailRow("Date Of Birth", widget.driver['dob'] ?? ""),
                      _buildDetailRow("Aadhaar Number", widget.driver['aadhaar'] ?? ""),
                      _buildDetailRow("Badge Number", widget.driver['badge_number'] ?? ""),
                      _buildDetailRow("Other Details", widget.driver['other_details'] ?? "", isMultiLine: true),
                    ],
                  ),
                  _buildInfoCard(
                    title: "Contact Information",
                    icon: Icons.contact_phone_outlined,
                    children: [
                      _buildDetailRow("Contact Mobile", widget.driver['mobile'] ?? widget.driver['phone'] ?? ""),
                      _buildDetailRow("Email", widget.driver['email'] ?? ""),
                      _buildDetailRow("Address", widget.driver['address'] ?? "", isMultiLine: true),
                    ],
                  ),
                  _buildInfoCard(
                    title: "Employment Information",
                    icon: Icons.work_outline,
                    children: [
                      _buildDetailRow("Employee Code", widget.driver['code'] ?? widget.driver['employeeCode'] ?? ""),
                      _buildDetailRow("Branch", widget.driver['branch'] ?? ""),
                      _buildDetailRow("Employee Type", widget.driver['employee_type'] ?? "Full Time Employee"),
                      _buildDetailRow("Employee Role", widget.driver['role'] ?? "Driver"),
                      _buildDetailRow("Designation", widget.driver['designation'] ?? ""),
                      _buildDetailRow("Date of Join", widget.driver['date_of_join'] ?? ""),
                      _buildDetailRow("Driving License Number", widget.driver['driving_license'] ?? ""),
                      _buildDetailRow("Salary", widget.driver['salary'] != null ? "₹${widget.driver['salary']}" : ""),
                      _buildDetailRow("Releaved Date", widget.driver['releaved_date'] ?? ""),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final String status = (widget.driver['status'] ?? 'Active').toString();
    final bool isActive = status == 'Active';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade100,
              child: const Icon(Icons.person, size: 60, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.driver['name']?.toString() ?? "Driver Name".tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.driver['role'] ?? 'Driver'.tr} | ${widget.driver['code'] ?? widget.driver['employeeCode'] ?? 'N/A'}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: isActive ? Colors.green.shade200 : Colors.red.shade200),
                ),
                child: Text(
                  status.tr.toUpperCase(),
                  style: TextStyle(
                    color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isMultiLine = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.tr,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
