import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';

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

  void _simulatePrint() {
    setState(() {
      _isPrinting = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Preparing document...".tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Generating PDF and sending to printer.".tr,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close progress dialog
        setState(() {
          _isPrinting = false;
        });
        
        // Show Success Dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
                  const SizedBox(width: 10),
                  Text("Print Status".tr, style: const TextStyle(color: Color(0xFF1E2875))),
                ],
              ),
              content: Text(
                "Hall ticket printed successfully or saved as PDF!".tr,
                style: const TextStyle(color: Color(0xFF1E2875)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK".tr, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> student = widget.student;
    final String schoolName = student['school'] ?? 'Ecstasy School 1';
    final String classAndSec = "${student['class'] ?? 'Grade 1'} - ${student['section'] ?? 'A'}";

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
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schoolName.toUpperCase().tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E2875),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Affiliated to State Board | School Code: ${schoolName.contains('1') ? 'ECS001' : schoolName.contains('2') ? 'ECS002' : 'ECS003'}".tr,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
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
                                child: student['avatar'] != null
                                    ? Center(
                                        child: Text(
                                          student['avatar'],
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E2875),
                                          ),
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
                                child: Text(row['date']!, style: const TextStyle(fontSize: 11, color: Colors.black87)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(row['time']!.tr, style: const TextStyle(fontSize: 11, color: Colors.black87)),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(width: 100, height: 1, color: Colors.grey.shade400),
                            const SizedBox(height: 6),
                            Text(
                              "Signature of Candidate".tr,
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(width: 100, height: 1, color: Colors.grey.shade400),
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
                              height: 25,
                              alignment: Alignment.bottomCenter,
                              child: const Text(
                                "EXSTAGE",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFF0038FF),
                                ),
                              ),
                            ),
                            Container(width: 100, height: 1, color: Colors.grey.shade400),
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
