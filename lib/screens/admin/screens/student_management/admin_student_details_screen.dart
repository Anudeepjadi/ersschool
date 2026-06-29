import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ersschool/core/localization/language_manager.dart';
import 'admin_student_attendance_report_screen.dart';
import 'admin_student_fee_details_screen.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/admin_app_bar.dart';
import 'admin_student_id_card_print_screen.dart';

class AdminStudentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? student;
  const AdminStudentDetailsScreen({super.key, this.student});

  @override
  State<AdminStudentDetailsScreen> createState() => _AdminStudentDetailsScreenState();
}

class _AdminStudentDetailsScreenState extends State<AdminStudentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Student Profile".tr,
        subtitle: "View detailed information",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Profile Header
            _buildProfileHeader(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Action Buttons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildActionButton(Icons.calendar_today, "Attendance", AppColors.primary, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentAttendanceReportScreen(student: widget.student)));
                        }),
                        _buildActionButton(Icons.currency_rupee, "Fees", Colors.green.shade700, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentFeeDetailsScreen(student: widget.student)));
                        }),
                        _buildActionButton(Icons.print, "Print ID", AppColors.primaryDark, () {
                          if (widget.student != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminStudentIdCardPrintScreen(studentData: widget.student!),
                              ),
                            );
                          }
                        }),
                        _buildActionButton(Icons.close, "Close", Colors.grey.shade700, () => Navigator.pop(context)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Content Sections
                  _buildInfoCard(
                    title: "Personal Information",
                    icon: Icons.person_outline,
                    children: [
                      _buildDetailRow("Full Name", widget.student?['name'] ?? "N/A"),
                      _buildDetailRow("Gender", widget.student?['gender'] ?? "N/A"),
                      _buildDetailRow("Date of Birth", widget.student?['dob'] ?? "N/A"),
                      _buildDetailRow("Aadhaar Number", widget.student?['aadhaar'] ?? "N/A"),
                      _buildDetailRow("Caste / Subcaste", "${widget.student?['caste'] ?? 'N/A'} / ${widget.student?['subcaste'] ?? 'N/A'}"),
                      _buildDetailRow("Address", widget.student?['address'] ?? "N/A", isMultiLine: true),
                    ],
                  ),
                  
                  _buildInfoCard(
                    title: "Contact Details",
                    icon: Icons.contact_phone_outlined,
                    children: [
                      _buildDetailRow("Primary Mobile", widget.student?['mobile'] ?? widget.student?['phone'] ?? "N/A"),
                      _buildDetailRow("Primary Email", widget.student?['email'] ?? "N/A"),
                      _buildDetailRow("Secondary Mobile", widget.student?['secondary_mobile'] ?? "N/A"),
                      _buildDetailRow("Secondary Email", widget.student?['secondary_email'] ?? "N/A"),
                    ],
                  ),
                  
                  _buildInfoCard(
                    title: "Academic Information",
                    icon: Icons.school_outlined,
                    children: [
                      _buildDetailRow("Admission No", widget.student?['admission'] ?? widget.student?['admNo'] ?? "N/A"),
                      _buildDetailRow("Registration No", widget.student?['registration_no'] ?? "N/A"),
                      _buildDetailRow("Class & Section", "${widget.student?['class'] ?? 'N/A'} - ${widget.student?['section'] ?? 'A'}"),
                      _buildDetailRow("Branch", widget.student?['branch'] ?? "Ecstasy School 1 (ECS001)"),
                      _buildDetailRow("Admission Date", widget.student?['admission_date'] ?? "N/A"),
                      _buildDetailRow("Transport", "${widget.student?['transport_type'] ?? 'N/A'} (${widget.student?['transport_route'] ?? 'No route'})"),
                    ],
                  ),
                  
                  _buildInfoCard(
                    title: "Parent / Guardian Details",
                    icon: Icons.family_restroom_outlined,
                    children: [
                      _buildDetailRow("Father Name", widget.student?['father'] ?? "N/A"),
                      _buildDetailRow("Father Work", "${widget.student?['father_occupation'] ?? 'N/A'} (${widget.student?['father_qualification'] ?? ''})"),
                      const Divider(height: 24),
                      _buildDetailRow("Mother Name", widget.student?['mother'] ?? "N/A"),
                      _buildDetailRow("Mother Work", "${widget.student?['mother_occupation'] ?? 'N/A'} (${widget.student?['mother_qualification'] ?? ''})"),
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
    final String status = (widget.student?['status'] ?? 'Active').toString();
    final bool isActive = status == 'Active';

    final photo = widget.student?['avatar'] ?? widget.student?['photoPath'];
    final bool hasValidPhoto = photo != null && File(photo.toString()).existsSync();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          // Photo with border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade100,
              backgroundImage: hasValidPhoto
                  ? FileImage(File(photo.toString()))
                  : null,
              child: !hasValidPhoto
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.student?['name']?.toString() ?? "Student Name".tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.student?['class'] ?? 'Class'.tr} | ${widget.student?['admission'] ?? widget.student?['admNo'] ?? 'N/A'}",
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
            width: 120,
            child: Text(
              label.tr,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value.toString().tr,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(text.tr, style: const TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
