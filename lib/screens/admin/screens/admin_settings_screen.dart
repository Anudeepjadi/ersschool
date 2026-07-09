import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import 'admin_holidays_screen.dart';
import 'admin_branch_list_screen.dart';
import 'admin_academic_years_screen.dart';
import 'admin_fee_types_screen.dart';
import 'admin_fee_structure_screen.dart';
import 'admin_active_list_screen.dart';
import 'admin_class_subjects_mapping_screen.dart';
import '../../../core/localization/language_manager.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _store = AppDataStore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
          title: "Settings", subtitle: "Configure your school system"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("GENERAL SETTINGS".tr, [
              _item("Holidays".tr, Icons.beach_access_outlined, Colors.red,
                  () => _push(AdminHolidaysScreen())),
              _item("Branch".tr, Icons.apartment_outlined, Colors.blue,
                  () => _push(AdminBranchListScreen())),
              _item("Academic Year".tr, Icons.calendar_today_outlined, Colors.green,
                  () => _push(AdminAcademicYearsScreen())),
            ]),
            SizedBox(height: 20),
            _section("FEE CONFIGURATION", [
              _item("Fee Types", Icons.payments_outlined, Colors.orange,
                  () => _push(AdminFeeTypesScreen())),
              _item("Fee Structure for Class", Icons.table_chart_outlined, Colors.purple,
                  () => _push(AdminFeeStructureScreen())),
              _item("Payment Types", Icons.account_balance_wallet_outlined, Colors.teal,
                  () => _push(AdminActiveListScreen(
                    title: 'Payment Types',
                    columnLabel: 'Payment Type',
                    accentColor: Color(0xFF0D9488),
                    dataSource: _store.paymentTypes,
                  ))),
            ]),
            SizedBox(height: 20),
            _section("ACADEMIC CONFIGURATION", [
              _item("Study Class", Icons.school_outlined, Colors.indigo,
                  () => _push(AdminActiveListScreen(
                    title: 'Study Classes',
                    columnLabel: 'Student Class',
                    accentColor: Color(0xFF4F46E5),
                    dataSource: _store.studyClasses,
                  ))),
              _item("Class Section", Icons.grid_view_outlined, Colors.blueGrey,
                  () => _push(AdminActiveListScreen(
                    title: 'Class Sections',
                    columnLabel: 'Section Name',
                    accentColor: Color(0xFF475569),
                    dataSource: _store.classSections,
                  ))),
              _item("Subjects", Icons.book_outlined, Colors.brown,
                  () => _push(AdminActiveListScreen(
                    title: 'Subjects',
                    columnLabel: 'Subject Name',
                    accentColor: Color(0xFF92400E),
                    dataSource: _store.subjects,
                  ))),
              _item("Class Subjects Mapping", Icons.assignment_ind_outlined, Colors.cyan,
                  () => _push(AdminClassSubjectsMappingScreen())),
              _item("Exam Type", Icons.quiz_outlined, Colors.deepOrange,
                  () => _push(AdminActiveListScreen(
                    title: 'Exam Types',
                    columnLabel: 'Exam Type',
                    accentColor: Color(0xFFEA580C),
                    dataSource: _store.examTypes,
                  ))),
              _item("Grade System", Icons.grading_outlined, Colors.deepPurple,
                  () => _push(AdminActiveListScreen(
                    title: 'Grade System',
                    columnLabel: 'Grade',
                    accentColor: Color(0xFF7C3AED),
                    dataSource: _store.gradeSystem,
                  ))),
              _item("Grade Report Design", Icons.design_services_outlined, Colors.pink,
                  () => _push(AdminActiveListScreen(
                    title: 'Grade Report Design',
                    columnLabel: 'Report Template',
                    accentColor: Color(0xFFDB2777),
                    dataSource: _store.gradeReportDesigns,
                  ))),
            ]),
            SizedBox(height: 20),
            _section("DATA & USERS", [
              _item("Export Data", Icons.file_download_outlined, Colors.green,
                  () => _showExportDialog()),
              _item("Student/Parent Users", Icons.people_outline, Colors.blue,
                  () => _push(AdminActiveListScreen(
                    title: 'Student/Parent Users',
                    columnLabel: 'User Type',
                    accentColor: Color(0xFF2563EB),
                    dataSource: _store.studentParentUsers,
                  ))),
              _item("Super Admin Settings", Icons.admin_panel_settings_outlined, Colors.redAccent,
                  () => _showSuperAdminDialog()),
            ]),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _push(Widget screen) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Export Data'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _exportOption('Students Data', Icons.people, Colors.blue),
          _exportOption('Teachers Data', Icons.school, Colors.green),
          _exportOption('Fee Records', Icons.payments, Colors.orange),
          _exportOption('Attendance Report', Icons.calendar_month, Colors.purple),
          _exportOption('Exam Results', Icons.quiz, Colors.red),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Close'.tr)),
        ],
      ),
    );
  }

  Widget _exportOption(String label, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: TextStyle(fontSize: 13)),
      trailing: Icon(Icons.download, color: Colors.grey, size: 18),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$label exported successfully')));
      },
    );
  }

  void _showSuperAdminDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Super Admin Settings'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _adminOption('Change School Name', Icons.edit_outlined),
          _adminOption('Reset All Data', Icons.restore),
          _adminOption('Backup & Restore', Icons.backup),
          _adminOption('System Logs', Icons.list_alt),
          _adminOption('Notification Settings', Icons.notifications_outlined),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Close'.tr)),
        ],
      ),
    );
  }

  Widget _adminOption(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent, size: 22),
      title: Text(label, style: TextStyle(fontSize: 13)),
      trailing:
          Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _section(String title, List<Widget> items) {
    List<Widget> childrenWithDividers = [];
    for (int i = 0; i < items.length; i++) {
      childrenWithDividers.add(items[i]);
      if (i < items.length - 1) {
        childrenWithDividers.add(Divider(height: 1, color: Colors.grey.shade100, indent: 56));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 1.2)),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100)),
          child: Column(
            children: childrenWithDividers,
          ),
        ),
      ],
    );
  }

  Widget _item(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      trailing: Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }



}
