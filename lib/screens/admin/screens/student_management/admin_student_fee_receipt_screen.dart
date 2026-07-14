import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AdminStudentFeeReceiptScreen extends StatefulWidget {
  final Map<String, dynamic>? student;
  const AdminStudentFeeReceiptScreen({super.key, this.student});

  @override
  State<AdminStudentFeeReceiptScreen> createState() => _AdminStudentFeeReceiptScreenState();
}

class _AdminStudentFeeReceiptScreenState extends State<AdminStudentFeeReceiptScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatClass(Map<String, dynamic>? student) {
    if (student == null) return "Grade 1";
    String c = student['class'] ?? "Grade 1";
    String s = student['section'] ?? "";
    if (s.isEmpty) return c;
    if (c.endsWith(s) || c.contains(" - ")) return c;
    return "$c - $s";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Fee Receipt".tr,
        subtitle: "View fee receipt",
      ),
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Container(
                width: 800,
                margin: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // Top Action Bar
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C757D), foregroundColor: Colors.white, minimumSize: const Size(60, 32), padding: const EdgeInsets.symmetric(horizontal: 16)),
                        child: Text("Close".tr, style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await Printing.layoutPdf(
                              onLayout: (PdfPageFormat format) => _generateReceiptPdf(format),
                              name: 'Fee_Receipt_${widget.student?['name'] ?? 'student'}',
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF212529), foregroundColor: Colors.white, minimumSize: const Size(60, 32), padding: const EdgeInsets.symmetric(horizontal: 16)),
                        child: Text("Print".tr, style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
              // Receipt Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                      padding: const EdgeInsets.all(24.0),
                      child: _buildReceipt(context, ""),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
                      padding: const EdgeInsets.all(24.0),
                      child: _buildReceipt(context, "(Office Copy)"),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("V1.0 Developed by Ecstasy Consulting And Solutions Pvt Ltd.", style: TextStyle(fontSize: 9, color: Colors.black54)),
                    const Text("Copyright © 2026 All rights reserved", style: TextStyle(fontSize: 9, color: Colors.black54)),
                    const Text("Please visit ecstasysolutions.org for details", style: TextStyle(fontSize: 9, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
                ),
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildReceipt(BuildContext context, String copyType) {
    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and Address
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.all_inclusive, size: 32, color: AppColors.secondary),
                      Text("ecstasy", style: TextStyle(fontSize: 14, color: AppColors.secondary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Text("Ecstasy School 1", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Hyderabad", style: TextStyle(fontSize: 11, color: Colors.black87)),
              const SizedBox(height: 2),
              const Text("Ph: 7382279090, Email: ecstasysolution123@gmail.org", style: TextStyle(fontSize: 11, color: Colors.black87)),
              const SizedBox(height: 12),
              const Text("RECEIPT", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.black)),
              if (copyType.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(copyType, style: const TextStyle(fontSize: 11, color: Colors.black)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Student Info Grid
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Receipt Number:".tr, "2646461"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Admission No:".tr, widget.student?['admission'] ?? widget.student?['admNo'] ?? "02600046"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Name:".tr, widget.student?['name'] ?? "Deepthi"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Father Name:".tr, widget.student?['father'] ?? "Venki"),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Date:".tr, dateStr),
                  const SizedBox(height: 12),
                  _buildInfoRow("Academic Year:".tr, widget.student?['academic_year'] ?? "2025-26"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Class:".tr, _formatClass(widget.student)),
                  const SizedBox(height: 12),
                  _buildInfoRow("Mother Name:".tr, widget.student?['mother'] ?? "Tulasi"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Fee Table
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1.5),
          },
          children: [
            TableRow(
              children: [
                _buildTableCell("Tuition Fee - Term 1", align: TextAlign.left),
                _buildTableCell("13,000.00", align: TextAlign.right),
                _buildTableCell("11,000.00", align: TextAlign.right),
                _buildTableCell("28/5/2026", align: TextAlign.center),
                _buildTableCell("2,000.00", align: TextAlign.right),
              ],
            ),
            TableRow(
              children: [
                _buildTableCell("Tuition Fee - Term 2", align: TextAlign.left),
                _buildTableCell("13,000.00", align: TextAlign.right),
                _buildTableCell("11,000.00", align: TextAlign.right),
                _buildTableCell("28/5/2026", align: TextAlign.center),
                _buildTableCell("2,000.00", align: TextAlign.right),
              ],
            ),
            TableRow(
              children: [
                _buildTableCell("Tuition Fee - Term 3", align: TextAlign.left),
                _buildTableCell("4,000.00", align: TextAlign.right),
                _buildTableCell("3,500.00", align: TextAlign.right),
                _buildTableCell("28/5/2026", align: TextAlign.center),
                _buildTableCell("500.00", align: TextAlign.right),
              ],
            ),
            TableRow(
              children: [
                _buildTableCell("Total", align: TextAlign.left, isBold: true),
                _buildTableCell("30,000.00", align: TextAlign.right, isBold: true),
                _buildTableCell("25,500.00", align: TextAlign.right, isBold: true),
                _buildTableCell("", align: TextAlign.center, isBold: true),
                _buildTableCell("4,500.00", align: TextAlign.right, isBold: true),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Total Amount Received (in words): Eleven Thousand Rupees Only.", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 4),
        const Text("Note: Fee once paid will not be refunded.", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 48),
        // Signature
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Authorised Signature", style: TextStyle(fontSize: 11, color: Colors.black)),
            const SizedBox(width: 32),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 200, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.black))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: Colors.black))),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isBold = false, TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 11, color: Colors.black),
        textAlign: align,
      ),
    );
  }

  Future<Uint8List> _generateReceiptPdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = "${now.day}/${now.month}/${now.year}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _pwReceipt(dateStr, ""),
            pw.SizedBox(height: 40),
            pw.Divider(thickness: 1, borderStyle: pw.BorderStyle.dashed),
            pw.SizedBox(height: 40),
            _pwReceipt(dateStr, "(Office Copy)"),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _pwReceipt(String dateStr, String copyType) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text("Ecstasy School 1", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text("Hyderabad", style: pw.TextStyle(fontSize: 10)),
              pw.Text("Ph: 7382279090, Email: ecstasysolution123@gmail.org", style: pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 12),
              pw.Text("RECEIPT", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, decoration: pw.TextDecoration.underline)),
              if (copyType.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(copyType, style: pw.TextStyle(fontSize: 10)),
              ],
            ],
          ),
        ),
        pw.SizedBox(height: 24),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _pwInfoRow("Receipt Number:", "2646461"),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Admission No:", widget.student?['admission'] ?? widget.student?['admNo'] ?? "02600046"),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Name:", widget.student?['name'] ?? "Deepthi"),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Father Name:", widget.student?['father'] ?? "Venki"),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _pwInfoRow("Date:", dateStr),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Academic Year:", widget.student?['academic_year'] ?? "2025-26"),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Class:", "${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}"),
                  pw.SizedBox(height: 8),
                  _pwInfoRow("Mother Name:", widget.student?['mother'] ?? "Tulasi"),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 24),
        pw.TableHelper.fromTextArray(
          headerAlignment: pw.Alignment.center,
          cellAlignment: pw.Alignment.centerLeft,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          cellStyle: const pw.TextStyle(fontSize: 10),
          headers: ['Particulars', 'Total Amount', 'Received', 'Date', 'Balance'],
          data: [
            ['Tuition Fee - Term 1', '13,000.00', '11,000.00', '28/5/2026', '2,000.00'],
            ['Tuition Fee - Term 2', '13,000.00', '0.00', '', '13,000.00'],
            ['Tuition Fee - Term 3', '12,000.00', '0.00', '', '12,000.00'],
            ['Total Amount', '38,000.00', '11,000.00', '', '27,000.00'],
          ],
        ),
        pw.SizedBox(height: 16),
        pw.Text("Total Amount Received (in words): Eleven Thousand Rupees Only.", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text("Note: Fee once paid will not be refunded.", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 40),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text("Authorised Signature", style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(width: 32),
          ],
        ),
      ],
    );
  }

  pw.Widget _pwInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.SizedBox(width: 80, child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
        pw.Text(value, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }
}
