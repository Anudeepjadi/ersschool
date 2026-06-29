import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class AdminStudentAttendanceReportScreen extends StatefulWidget {
  final Map<String, dynamic>? student;
  const AdminStudentAttendanceReportScreen({super.key, this.student});

  @override
  State<AdminStudentAttendanceReportScreen> createState() => _AdminStudentAttendanceReportScreenState();
}

class _AdminStudentAttendanceReportScreenState extends State<AdminStudentAttendanceReportScreen> {
  int _itemsPerPage = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _dummyData = [
    {'month': 'May - 2026', 'attendance': '1 / 3'},
    {'month': 'Jun - 2026', 'attendance': '2 / 2'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: "Attendance Report".tr,
        subtitle: "View student attendance",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text("Close".tr),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Student Info Header
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Name:", widget.student?['name'] ?? "Deepthi"),
                  const Divider(height: 1),
                  _buildInfoRow("Class:", "${widget.student?['class'] ?? "Grade 1"} - ${widget.student?['section'] ?? "A"}"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // DataTable
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: 500, // Matching the screenshot's width constraint
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                  Container(
                    color: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: Text("Month".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        Expanded(child: Text("Attendance".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 48), // Space for action button
                      ],
                    ),
                  ),
                  ..._dummyData.map((data) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(child: Text(data['month'])),
                          Expanded(child: Text(data['attendance'])),
                          const Icon(Icons.visibility, color: AppColors.primaryDark),
                        ],
                      ),
                    );
                  }),
                  // Pagination
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: AppColors.primary.withValues(alpha: 0.1), // Light orange
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Items per page:".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _itemsPerPage,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 20, child: Text("20", style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 50, child: Text("50", style: TextStyle(fontSize: 12))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _itemsPerPage = val);
                          },
                        ),
                        const SizedBox(width: 24),
                        Text("1 - ${_dummyData.length} of ${_dummyData.length}".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 16),
                        const Icon(Icons.first_page, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        const Icon(Icons.last_page, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(label.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          Expanded(
            child: Text(value.tr, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
