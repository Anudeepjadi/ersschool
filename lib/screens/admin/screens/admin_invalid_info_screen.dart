import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'admin_invalid_fee_data_screen.dart';
import 'admin_invalid_fee_totals_screen.dart';
import 'admin_fee_not_gen_students_screen.dart';
import 'admin_transaction_logs_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminInvalidInfoScreen extends StatefulWidget {
  const AdminInvalidInfoScreen({super.key});

  @override
  State<AdminInvalidInfoScreen> createState() => _AdminInvalidInfoScreenState();
}

class _AdminInvalidInfoScreenState extends State<AdminInvalidInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Invalid Info",
        subtitle: "Manage data discrepancies",
      ),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, bottom: 12),
              child: Text("DATA DISCREPANCIES".tr,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuItem(
                    title: "Invalid Fee Data",
                    subtitle: "Correct individual record errors",
                    icon: Icons.error_outline,
                    color: Color(0xFFEF4444),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminInvalidFeeDataScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: "Invalid Fee Totals",
                    subtitle: "Reconcile sum mismatch errors",
                    icon: Icons.difference_outlined,
                    color: Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminInvalidFeeTotalsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: "Fee not Gen Students",
                    subtitle: "List students without generated fees",
                    icon: Icons.person_search_outlined,
                    color: Color(0xFF3B82F6),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminFeeNotGenStudentsScreen()),
                    ),
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    title: "Transaction Logs",
                    subtitle: "Review system operations history",
                    icon: Icons.receipt_long,
                    color: Color(0xFF10B981),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AdminTransactionLogsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E2875),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey,
        ),
      ),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade100,
      indent: 56,
    );
  }
}
