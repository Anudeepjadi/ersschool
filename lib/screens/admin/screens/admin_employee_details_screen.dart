import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../widgets/admin_app_bar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'admin_employee_id_card_print_screen.dart';

class AdminEmployeeDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> employee;
  const AdminEmployeeDetailsScreen({super.key, required this.employee});

  @override
  State<AdminEmployeeDetailsScreen> createState() => _AdminEmployeeDetailsScreenState();
}

class _AdminEmployeeDetailsScreenState extends State<AdminEmployeeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
      appBar: AdminAppBar(
        title: "Employee Profile".tr,
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
                        _buildActionButton(Icons.currency_rupee, "Salary", Colors.green.shade700, () {}),
                        _buildActionButton(Icons.print, "Print Profile", AppColors.primary, () => _printDetails(context)),
                        _buildActionButton(Icons.badge, "Print ID", AppColors.primaryDark, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminEmployeeIdCardPrintScreen(employeeData: widget.employee),
                            ),
                          );
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
                      _buildDetailRow("Full Name", widget.employee['name'] ?? "N/A"),
                      _buildDetailRow("Gender", widget.employee['gender'] ?? "N/A"),
                      _buildDetailRow("Date of Birth", widget.employee['dob'] ?? "N/A"),
                      _buildDetailRow("Aadhaar Number", widget.employee['aadhaar'] ?? "N/A"),
                      _buildDetailRow("Address", widget.employee['address'] ?? "Hyderabad", isMultiLine: true),
                    ],
                  ),
                  
                  _buildInfoCard(
                    title: "Contact Details",
                    icon: Icons.contact_phone_outlined,
                    children: [
                      _buildDetailRow("Primary Mobile", widget.employee['phone'] ?? "N/A"),
                      _buildDetailRow("Primary Email", widget.employee['email'] ?? "N/A"),
                      _buildDetailRow("Secondary Mobile", widget.employee['secondary_mobile'] ?? "N/A"),
                    ],
                  ),
                  
                  _buildInfoCard(
                    title: "Professional Information",
                    icon: Icons.work_outline,
                    children: [
                      _buildDetailRow("Employee Code", widget.employee['employeeCode'] ?? "N/A"),
                      _buildDetailRow("Role / Dept", widget.employee['department'] ?? "N/A"),
                      _buildDetailRow("Designation", widget.employee['subject'] ?? "Staff"),
                      _buildDetailRow("Employee Type", widget.employee['employee_type'] ?? "Full Time"),
                      _buildDetailRow("Branch", widget.employee['school'] ?? "N/A"),
                      _buildDetailRow("Date of Join", widget.employee['date_of_join'] ?? "N/A"),
                      _buildDetailRow("Experience", widget.employee['experience'] ?? "N/A"),
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
    final String status = (widget.employee['status'] ?? 'Active').toString();
    final bool isActive = status == 'Active';

    final photo = widget.employee['avatar'] ?? widget.employee['photoPath'];
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
            widget.employee['name']?.toString() ?? "Employee Name".tr,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.employee['department'] ?? 'Role'.tr} | ${widget.employee['employeeCode'] ?? 'N/A'}",
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

  Future<void> _printDetails(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "Employee Details",
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF1E2875)),
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _pdfDetailRow("Employee Code:", widget.employee['employeeCode'] ?? '-'),
                          _pdfDetailRow("Full Name:", widget.employee['name'] ?? 'N/A'),
                          _pdfDetailRow("Gender:", widget.employee['gender'] ?? 'N/A'),
                          _pdfDetailRow("Contact Mobile:", widget.employee['phone'] ?? 'N/A'),
                          _pdfDetailRow("Address:", "Hyderabad"),
                          _pdfDetailRow("Employee Type:", "Full Time Employee"),
                          _pdfDetailRow("Designation:", widget.employee['subject'] ?? 'Staff'),
                          _pdfDetailRow("Date of Join:", "-"),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 40),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _pdfDetailRow("Branch:", widget.employee['school'] ?? 'N/A'),
                          _pdfDetailRow("Date Of Birth:", "-"),
                          _pdfDetailRow("Email:", "null, null"),
                          _pdfDetailRow("Aadhaar Number:", "-"),
                          _pdfDetailRow("Employee Role:", widget.employee['department'] ?? 'Employee'),
                          _pdfDetailRow("Salary:", "-"),
                          _pdfDetailRow("Is Active:", widget.employee['status'] == 'Active' ? "True" : "False"),
                          _pdfDetailRow("Released Date:", "-"),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Divider(),
                pw.SizedBox(height: 16),
                _pdfDetailRow("Other Details:", "-"),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Employee_${widget.employee['name']?.toString().replaceAll(' ', '_') ?? 'Details'}.pdf',
      );
    } catch (e) {
      debugPrint("Print Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to print: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  pw.Widget _pdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
          pw.SizedBox(height: 2),
          pw.Text(value, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF1E2875))),
        ],
      ),
    );
  }
}
