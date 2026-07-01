import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../widgets/admin_drawer.dart';
import 'reports/holidays_list_report_screen.dart';
import 'reports/fee_structure_report_screen.dart';
import 'reports/fee_collection_summary_screen.dart';
import 'reports/fee_due_list_screen.dart';
import 'reports/fee_collection_by_date_screen.dart';
import 'reports/class_attendance_report_screen.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Holidays List',
      'icon': Icons.event_available,
      'screen': const HolidaysListReportScreen(),
    },
    {
      'title': 'Fee Structure',
      'icon': Icons.account_balance_wallet,
      'screen': const FeeStructureReportScreen(),
    },
    {
      'title': 'Fee Collection',
      'icon': Icons.payments,
      'screen': const FeeCollectionSummaryScreen(),
    },
    {
      'title': 'Tuition Fee Due',
      'icon': Icons.money_off,
      'screen': const FeeDueListScreen(reportTitle: "Tuition Fee Due Students"),
    },
    {
      'title': 'Transport Fee Due',
      'icon': Icons.directions_bus,
      'screen': const FeeDueListScreen(reportTitle: "Transport Fee Due Students"),
    },
    {
      'title': 'Collection By Date',
      'icon': Icons.date_range,
      'screen': const FeeCollectionByDateScreen(),
    },
    {
      'title': 'Attendance Report',
      'icon': Icons.co_present,
      'screen': const ClassAttendanceReportScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AdminDrawer(),
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Select a report to view",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final item = _reports[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], color: AppColors.primary),
              ),
              title: Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => item['screen']));
              },
            ),
          );
        },
      ),
    );
  }
}

