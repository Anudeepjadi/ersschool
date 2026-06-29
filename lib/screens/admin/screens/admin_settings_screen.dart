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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
          title: "Settings", subtitle: "Configure your school system"),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("GENERAL SETTINGS", [
              _item("Holidays", Icons.beach_access_outlined, Colors.red,
                  () => _push(const AdminHolidaysScreen())),
              _item("Branch", Icons.apartment_outlined, Colors.blue,
                  () => _push(const AdminBranchListScreen())),
              _item("Academic Year", Icons.calendar_today_outlined, Colors.green,
                  () => _push(const AdminAcademicYearsScreen())),
            ]),
            const SizedBox(height: 20),
            _section("FEE CONFIGURATION", [
              _item("Fee Types", Icons.payments_outlined, Colors.orange,
                  () => _push(const AdminFeeTypesScreen())),
              _item("Fee Structure for Class", Icons.table_chart_outlined, Colors.purple,
                  () => _push(const AdminFeeStructureScreen())),
              _item("Payment Types", Icons.account_balance_wallet_outlined, Colors.teal,
                  () => _push(AdminActiveListScreen(
                    title: 'Payment Types',
                    columnLabel: 'Payment Type',
                    accentColor: const Color(0xFF0D9488),
                    dataSource: _store.paymentTypes,
                  ))),
            ]),
            const SizedBox(height: 20),
            _section("ACADEMIC CONFIGURATION", [
              _item("Study Class", Icons.school_outlined, Colors.indigo,
                  () => _push(AdminActiveListScreen(
                    title: 'Study Classes',
                    columnLabel: 'Student Class',
                    accentColor: const Color(0xFF4F46E5),
                    dataSource: _store.studyClasses,
                  ))),
              _item("Class Section", Icons.grid_view_outlined, Colors.blueGrey,
                  () => _push(AdminActiveListScreen(
                    title: 'Class Sections',
                    columnLabel: 'Section Name',
                    accentColor: const Color(0xFF475569),
                    dataSource: _store.classSections,
                  ))),
              _item("Subjects", Icons.book_outlined, Colors.brown,
                  () => _push(AdminActiveListScreen(
                    title: 'Subjects',
                    columnLabel: 'Subject Name',
                    accentColor: const Color(0xFF92400E),
                    dataSource: _store.subjects,
                  ))),
              _item("Class Subjects Mapping", Icons.assignment_ind_outlined, Colors.cyan,
                  () => _push(const AdminClassSubjectsMappingScreen())),
              _item("Exam Type", Icons.quiz_outlined, Colors.deepOrange,
                  () => _push(AdminActiveListScreen(
                    title: 'Exam Types',
                    columnLabel: 'Exam Type',
                    accentColor: const Color(0xFFEA580C),
                    dataSource: _store.examTypes,
                  ))),
              _item("Grade System", Icons.grading_outlined, Colors.deepPurple,
                  () => _push(AdminActiveListScreen(
                    title: 'Grade System',
                    columnLabel: 'Grade',
                    accentColor: const Color(0xFF7C3AED),
                    dataSource: _store.gradeSystem,
                  ))),
              _item("Grade Report Design", Icons.design_services_outlined, Colors.pink,
                  () => _push(AdminActiveListScreen(
                    title: 'Grade Report Design',
                    columnLabel: 'Report Template',
                    accentColor: const Color(0xFFDB2777),
                    dataSource: _store.gradeReportDesigns,
                  ))),
            ]),
            const SizedBox(height: 20),
            _section("DATA & USERS", [
              _item("Export Data", Icons.file_download_outlined, Colors.green,
                  () => _showExportDialog()),
              _item("Student/Parent Users", Icons.people_outline, Colors.blue,
                  () => _push(AdminActiveListScreen(
                    title: 'Student/Parent Users',
                    columnLabel: 'User Type',
                    accentColor: const Color(0xFF2563EB),
                    dataSource: _store.studentParentUsers,
                  ))),
              _item("Super Admin Settings", Icons.admin_panel_settings_outlined, Colors.redAccent,
                  () => _showSuperAdminDialog()),
            ]),
            const SizedBox(height: 30),
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
        title: const Text('Export Data',
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
              child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _exportOption(String label, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.download, color: Colors.grey, size: 18),
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
        title: const Text('Super Admin Settings',
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
              child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _adminOption(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 13)),
      trailing:
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _section(String title, List<_SettingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(title,
              style: const TextStyle(
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, index) =>
                Divider(height: 1, color: Colors.grey.shade100, indent: 56),
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                title: Text(item.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875))),
                trailing: const Icon(Icons.chevron_right,
                    size: 18, color: Colors.grey),
                onTap: item.onTap,
              );
            },
          ),
        ),
      ],
    );
  }

  _SettingItem _item(
          String title, IconData icon, Color color, VoidCallback onTap) =>
      _SettingItem(title, icon, color, onTap);
}

class _SettingItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _SettingItem(this.title, this.icon, this.color, this.onTap);
}
