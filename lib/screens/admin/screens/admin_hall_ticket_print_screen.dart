import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AdminHallTicketPrintScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final String examination;

  const AdminHallTicketPrintScreen({
    super.key,
    required this.student,
    required this.examination,
  });

  @override
  State<AdminHallTicketPrintScreen> createState() => _AdminHallTicketPrintScreenState();
}

class _AdminHallTicketPrintScreenState extends State<AdminHallTicketPrintScreen> {
  bool _isPrinting = false;

  Future<void> _simulatePrint() async {
    setState(() => _isPrinting = true);
    try {
      pw.ImageProvider? studentPhoto;
      final photo = widget.student['avatar'] ?? widget.student['photoPath'];
      if (!kIsWeb && photo != null && File(photo.toString()).existsSync()) {
        studentPhoto = pw.MemoryImage(File(photo.toString()).readAsBytesSync());
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          final doc = pw.Document();
          doc.addPage(
            pw.Page(
              pageFormat: format,
              margin: const pw.EdgeInsets.all(32),
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                      child: pw.Text("HALL TICKET (${widget.examination})", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(height: 24),
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text("Student Name: ${widget.student['name'] ?? ''}"),
                              pw.Text("Admission Number: ${widget.student['admission'] ?? ''}"),
                              pw.Text("Class & Section: ${widget.student['class'] ?? ''} - ${widget.student['section'] ?? ''}"),
                              pw.Text("Academic Year: 2025-26"),
                            ],
                          ),
                        ),
                        if (studentPhoto != null)
                          pw.Container(
                            width: 80,
                            height: 100,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey300),
                            ),
                            child: pw.Image(studentPhoto, fit: pw.BoxFit.cover),
                          ),
                      ],
                    ),
                    pw.SizedBox(height: 40),
                    pw.Text("EXAMINATION SCHEDULE", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 12),
                    pw.TableHelper.fromTextArray(
                      border: pw.TableBorder.all(),
                      headers: ['Subject', 'Date', 'Time'],
                      data: [
                        ['Telugu', '2/1/2026', '09:00 AM - 10:00 AM'],
                        ['English', '3/1/2026', '09:00 AM - 10:00 AM'],
                        ['Hindi', '5/1/2026', '09:00 AM - 10:00 AM'],
                        ['Maths', '6/1/2026', '09:00 AM - 10:00 AM'],
                      ],
                    ),
                  ],
                );
              },
            ),
          );
          return doc.save();
        },
        name: 'Hall_Ticket_${widget.student['name'] ?? 'student'}',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Print Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> student = widget.student;
    final String schoolName = student['school'] ?? 'Ecstasy School 1';
    final String classAndSec = "${student['class'] ?? 'LKG'} - ${student['section'] ?? 'A'}";
    final photo = student['avatar'] ?? student['photoPath'];
    final bool hasValidPhoto = !kIsWeb && photo != null && File(photo.toString()).existsSync();

    // Mock subject dates for selected examination
    final List<Map<String, String>> timetable = [
      {'subject': 'Telugu', 'date': '2026-07-01', 'time': '09:00 AM - 12:00 PM'},
      {'subject': 'English', 'date': '2026-07-02', 'time': '09:00 AM - 12:00 PM'},
      {'subject': 'Hindi', 'date': '2026-07-03', 'time': '09:00 AM - 12:00 PM'},
      {'subject': 'Mathematics', 'date': '2026-07-04', 'time': '09:00 AM - 12:00 PM'},
      {'subject': 'Science', 'date': '2026-07-06', 'time': '09:00 AM - 12:00 PM'},
      {'subject': 'Social Studies', 'date': '2026-07-07', 'time': '09:00 AM - 12:00 PM'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E2875)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Print Hall Ticket".tr,
          style: const TextStyle(color: Color(0xFF1E2875), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined, color: AppColors.primary),
            onPressed: _isPrinting ? null : _simulatePrint,
            tooltip: "Print".tr,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Print Instruction Banner
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Verify all student information and examination timetable before printing.".tr,
                        style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onPressed: _isPrinting ? null : _simulatePrint,
                      icon: const Icon(Icons.print, size: 16),
                      label: Text("Print".tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // The Hall Ticket Card itself (A4 style ratio aspect or structured paper layout)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // School Letterhead
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  schoolName.toUpperCase().tr,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1E2875),
                                    letterSpacing: 0.5,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Affiliated to State Board | School Code: ${schoolName.contains('1') ? 'ECS001' : schoolName.contains('2') ? 'ECS002' : 'ECS003'}".tr,
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Logo Placeholder
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF1E2875), width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "ECSTASY",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E2875),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFF1E2875), thickness: 2),
                    const SizedBox(height: 10),

                    // Hall Ticket Title
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2875),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "HALL TICKET (${widget.examination})".toUpperCase().tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Student Information
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Information details
                        Expanded(
                          flex: 7,
                          child: Table(
                            columnWidths: const {
                              0: IntrinsicColumnWidth(),
                              1: FixedColumnWidth(15),
                              2: FlexColumnWidth(),
                            },
                            children: [
                              _buildInfoRow("Student Name".tr, student['name'] ?? ''),
                              _buildInfoRow("Admission Number".tr, student['admission'] ?? ''),
                              _buildInfoRow("Roll Number".tr, student['roll']?.toString().replaceAll('Roll No: ', '') ?? ''),
                              _buildInfoRow("Class & Section".tr, classAndSec),
                              _buildInfoRow("Gender".tr, student['gender'] ?? 'Male'),
                              _buildInfoRow("Academic Year".tr, "2025-26"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        // Right Student Photo Box
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 110,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.grey.shade100,
                                ),
                                child: hasValidPhoto
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.file(
                                          File(photo.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(Icons.person, size: 50, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Student Photo".tr,
                                style: const TextStyle(fontSize: 9, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Exam Timetable Table Title
                    Text(
                      "EXAMINATION SCHEDULE".tr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Timetable Table
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(4),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Subject Name".tr,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Date".tr,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Time".tr,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF1E2875)),
                              ),
                            ),
                          ],
                        ),
                        ...timetable.map((row) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(row['subject']!.tr, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(row['date']!, style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 1),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(row['time']!.tr, style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 1),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Instructions to Candidate
                    Text(
                      "INSTRUCTIONS TO THE CANDIDATE:".tr,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildInstructionItem("1. Candidates must carry this Hall Ticket and ID card to the examination hall without fail."),
                    _buildInstructionItem("2. Candidates must occupy their allotted seats at least 15 minutes before the commencement of the exam."),
                    _buildInstructionItem("3. Any electronic gadgets, smartphones, or calculators are strictly prohibited inside the exam hall."),
                    _buildInstructionItem("4. Do not write or scribble anything on this Hall Ticket."),
                    const SizedBox(height: 40),

                    // Signatures
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runSpacing: 20,
                      spacing: 12,
                      children: [
                        Column(
                          children: [
                            Container(width: 80, height: 1, color: Colors.grey.shade400),
                            const SizedBox(height: 6),
                            Text(
                              "Signature of Candidate".tr,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(width: 80, height: 1, color: Colors.grey.shade400),
                            const SizedBox(height: 6),
                            Text(
                              "Signature of Invigilator".tr,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/images/principal_signature_v2.png',
                                height: 40,
                                width: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Text(
                                  "EXSTAGE",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            Container(width: 80, height: 1, color: Colors.grey.shade400),
                            const SizedBox(height: 6),
                            Text(
                              "Principal Signature".tr,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildInfoRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(":"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text.tr,
        style: const TextStyle(fontSize: 9, color: Colors.black54),
      ),
    );
  }
}
