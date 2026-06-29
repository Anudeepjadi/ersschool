import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminEmployeeDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> employee;

  const AdminEmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ─── Top Header with Buttons on Right ────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _topActionBtn("Print", const Color(0xFF1E2843), () => _printDetails(context)),
                    const SizedBox(width: 10),
                    _topActionBtn("Close", Colors.grey.shade600, () => Navigator.pop(context)),
                  ],
                ),
              ),

              // ─── Centered Title ──────────────────────────────────────────
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Employee Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
              ),

              // ─── Centered Profile Picture ────────────────────────────────
              const SizedBox(height: 24),
              Center(
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(Icons.person, size: 100, color: Colors.grey.shade400),
                ),
              ),

              const SizedBox(height: 32),

              // ─── Details Grid (Rows with Two Columns) ───────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow(
                        _buildDetailRow("Employee Code:", employee['employeeCode'] ?? '-'),
                        _buildDetailRow("Branch:", employee['school'] ?? 'N/A'),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Full Name:", employee['name'] ?? 'N/A'),
                        _buildDetailRow("Date Of Birth:", "-"),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Gender:", employee['gender'] ?? 'N/A'),
                        _buildDetailRow("Email:", "null, null"),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Contact Mobile:", employee['phone'] ?? 'N/A'),
                        _buildDetailRow("Aadhaar Number:", "-"),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Address:", "Hyderabad"),
                        _buildDetailRow("Employee Role:", employee['department'] ?? 'Employee'),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Employee Type:", "Full Time Employee"),
                        _buildDetailRow("Salary:", "-"),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Designation:", employee['subject'] ?? 'Staff'),
                        _buildDetailRow("Is Active:", employee['status'] == 'Active' ? "True" : "False"),
                      ),
                      const SizedBox(height: 16),
                      _buildRow(
                        _buildDetailRow("Date of Join:", "-"),
                        _buildDetailRow("Released Date:", "-"),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow("Other Details:", "-"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topActionBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
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
                          _pdfDetailRow("Employee Code:", employee['employeeCode'] ?? '-'),
                          _pdfDetailRow("Full Name:", employee['name'] ?? 'N/A'),
                          _pdfDetailRow("Gender:", employee['gender'] ?? 'N/A'),
                          _pdfDetailRow("Contact Mobile:", employee['phone'] ?? 'N/A'),
                          _pdfDetailRow("Address:", "Hyderabad"),
                          _pdfDetailRow("Employee Type:", "Full Time Employee"),
                          _pdfDetailRow("Designation:", employee['subject'] ?? 'Staff'),
                          _pdfDetailRow("Date of Join:", "-"),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 40),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _pdfDetailRow("Branch:", employee['school'] ?? 'N/A'),
                          _pdfDetailRow("Date Of Birth:", "-"),
                          _pdfDetailRow("Email:", "null, null"),
                          _pdfDetailRow("Aadhaar Number:", "-"),
                          _pdfDetailRow("Employee Role:", employee['department'] ?? 'Employee'),
                          _pdfDetailRow("Salary:", "-"),
                          _pdfDetailRow("Is Active:", employee['status'] == 'Active' ? "True" : "False"),
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
        name: 'Employee_${employee['name']?.toString().replaceAll(' ', '_') ?? 'Details'}.pdf',
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

  Widget _buildRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 24),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
