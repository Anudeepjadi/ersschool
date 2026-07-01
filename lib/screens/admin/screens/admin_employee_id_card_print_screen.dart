import 'package:flutter/material.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'dart:io';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class AdminEmployeeIdCardPrintScreen extends StatefulWidget {
  final List<Map<String, dynamic>> employeesData;
  const AdminEmployeeIdCardPrintScreen({super.key, required this.employeesData});

  @override
  State<AdminEmployeeIdCardPrintScreen> createState() => _AdminEmployeeIdCardPrintScreenState();
}

class _AdminEmployeeIdCardPrintScreenState extends State<AdminEmployeeIdCardPrintScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
      backgroundColor: const Color(0xFFF1F5F9), // Slate 100
      appBar: AdminAppBar(
        title: "Print ID Card".tr,
        subtitle: "Preview and print employee ID",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(
              height: 480,
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.employeesData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Center(
                    child: _buildProfessionalIdCard(widget.employeesData[index]),
                  );
                },
              ),
            ),
            if (widget.employeesData.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  '${_currentIndex + 1} of ${widget.employeesData.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  _actionButton(Icons.print, "Print Card", AppColors.primaryDark, () async {
                    try {
                      await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) => _generatePdf(format, widget.employeesData),
                        name: 'ID_Cards',
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }),
                  _actionButton(Icons.share, "Share PDF", Colors.green.shade700, () async {
                    try {
                      final pdfBytes = await _generatePdf(PdfPageFormat.a4, widget.employeesData);
                      await Printing.sharePdf(
                        bytes: pdfBytes,
                        filename: "ID_Cards.pdf",
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalIdCard(Map<String, dynamic> employeeData) {
    final photo = employeeData['photoPath'];
    final bool hasValidPhoto = photo != null && File(photo.toString()).existsSync();
    const headerColor = Color(0xFF1E40AF); // Deeper blue
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: const BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ProfileManager().selectedSchool.value.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        "Shaping Futures, Building Tomorrow",
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Info body
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: hasValidPhoto
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(File(photo.toString()), fit: BoxFit.cover),
                            )
                          : const Icon(Icons.person, color: Colors.grey, size: 50),
                    ),
                    const SizedBox(height: 8),
                    const Text("EMPLOYEE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5, color: headerColor)),
                  ],
                ),
                const SizedBox(width: 18),
                
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeData['name'] ?? "",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Divider(color: headerColor, thickness: 1.5, endIndent: 20),
                      const SizedBox(height: 8),
                      _detailItem("Code", employeeData['employeeCode'] ?? "N/A"),
                      _detailItem("Gender", employeeData['gender'] ?? ""),
                      _detailItem("Phone", employeeData['phone'] ?? ""),
                      _detailItem("Dept.", employeeData['department'] ?? employeeData['designation'] ?? employeeData['role'] ?? 'N/A'),
                      _detailItem("Exp.", employeeData['experience'] ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barcode
                    Row(
                      children: List.generate(24, (index) {
                        return Container(
                          width: (index % 4 == 0) ? 3.0 : 1.5,
                          height: 24,
                          color: Colors.black,
                          margin: const EdgeInsets.only(right: 1),
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employeeData['employeeCode'] ?? "0000",
                      style: const TextStyle(fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/principal_signature_v2.png',
                      height: 50,
                      width: 90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 1,
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Principal Sign",
                      style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 65, // Fixed label width for perfect vertical alignment
            child: Text(
              "${label.tr}:",
              style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label.tr),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, List<Map<String, dynamic>> employeesData) async {
    final pdf = pw.Document();
    final headerColor = PdfColor.fromInt(0xFF1E40AF);
    final detailTextColor = PdfColor.fromInt(0xFF1E2875);

    // Load assets
    pw.ImageProvider? signatureImage;
    try {
      final signatureBytes = await rootBundle.load('assets/images/principal_signature_v2.png');
      signatureImage = pw.MemoryImage(signatureBytes.buffer.asUint8List());
    } catch (_) {}

    for (var employeeData in employeesData) {
      pw.ImageProvider? studentPhoto;
      final photo = employeeData['photoPath'];
      if (photo != null && File(photo.toString()).existsSync()) {
        studentPhoto = pw.MemoryImage(File(photo.toString()).readAsBytesSync());
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 320,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                border: pw.Border.all(color: PdfColors.grey300, width: 1),
              ),
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  // Header
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: pw.BoxDecoration(
                      color: headerColor,
                      borderRadius: const pw.BorderRadius.only(
                        topLeft: pw.Radius.circular(12),
                        topRight: pw.Radius.circular(12),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              ProfileManager().selectedSchool.value.toUpperCase(),
                              style: pw.TextStyle(color: PdfColors.white, fontWeight: pw.FontWeight.bold, fontSize: 13),
                            ),
                            pw.Text(
                              "Shaping Futures, Building Tomorrow",
                              style: pw.TextStyle(color: PdfColors.white, fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Info
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(16),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          children: [
                            pw.Container(
                              width: 85,
                              height: 105,
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                                border: pw.Border.all(color: PdfColors.grey300, width: 1.5),
                              ),
                              child: studentPhoto != null
                                  ? pw.Image(studentPhoto, fit: pw.BoxFit.cover)
                                  : null,
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text("EMPLOYEE", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: headerColor)),
                          ],
                        ),
                        pw.SizedBox(width: 16),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                employeeData['name'] ?? "",
                                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: detailTextColor),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(top: 2, bottom: 8),
                                child: pw.Divider(color: headerColor, thickness: 1.5),
                              ),
                              _pdfDetailItem("Code", employeeData['employeeCode'] ?? "N/A", detailTextColor),
                              _pdfDetailItem("Gender", employeeData['gender'] ?? "", detailTextColor),
                              _pdfDetailItem("Phone", employeeData['phone'] ?? "", detailTextColor),
                              _pdfDetailItem("Dept.", employeeData['department'] ?? employeeData['designation'] ?? employeeData['role'] ?? 'N/A', detailTextColor),
                              _pdfDetailItem("Exp.", employeeData['experience'] ?? "N/A", detailTextColor),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Divider(height: 1, color: PdfColors.grey300),
                  // Footer
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.BarcodeWidget(
                              data: employeeData['employeeCode'] ?? "0000",
                              width: 70,
                              height: 25,
                              barcode: pw.Barcode.code128(),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              employeeData['employeeCode'] ?? "0000",
                              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                        pw.Column(
                          children: [
                            if (signatureImage != null)
                              pw.Image(signatureImage, height: 50, width: 90),
                            pw.SizedBox(height: 2),
                            pw.Text("Principal Sign", style: pw.TextStyle(fontSize: 8, color: PdfColors.grey, fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 4),
                ],
              ),
            ),
          );
        },
      ),
    );
    }

    return pdf.save();
  }

  pw.Widget _pdfDetailItem(String label, String value, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 45,
            child: pw.Text("${label.tr}:", style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Expanded(
            child: pw.Text(value, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }
}
