import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/app_footer.dart';

class AdminAttendanceScreen extends StatefulWidget {
  const AdminAttendanceScreen({super.key});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'A';
  DateTime _selectedDate = DateTime(2026, 6, 25);
  final GlobalKey _dateKey = GlobalKey();
  String _displayClass = 'Grade 1';
  String _displaySection = 'A';
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  void _showDatePicker() {
    Future.delayed(const Duration(milliseconds: 100), () => showCustomDatePicker(context: context, anchorKey: _dateKey, initialDate: _selectedDate, onDateSelected: (date) => setState(() => _selectedDate = date)));
  }

  void _fetchAttendanceData() {
    setState(() {
      _displayClass = _selectedClass; _displaySection = _selectedSection;
      if (_selectedBranch == 'Ecstasy School 1 (ECS001)' && _selectedClass == 'Grade 1' && _selectedSection == 'A') {
        _students = [{'name': 'Deepthi', 'present': true}, {'name': 'Priya', 'present': true}, {'name': 'Deepthi', 'present': true}, {'name': 'suresh', 'present': true}, {'name': 'Rimsa', 'present': true}, {'name': 'tony', 'present': true}, {'name': 'lakshmi', 'present': true}, {'name': 'Vijaya', 'present': true}, {'name': 'phani', 'present': true}, {'name': 'vinitha', 'present': true}, {'name': 'raju', 'present': true}, {'name': 'dhurandarrr', 'present': true}, {'name': 'MadiviliNaresh', 'present': true}, {'name': 'ECSTASY SOLUTIONS PVT LTD', 'present': true}];
      } else {
        _students = List.generate(5, (i) => {'name': '$_displayClass Student ${i+1} ($_displaySection)', 'present': true});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(title: "Class Attendance", subtitle: "Track and manage student attendance"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  Center(child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Attendance saved successfully!"))); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2875), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Save"))),
                  const SizedBox(height: 24),
                  Text("Class: $_displayClass - $_displaySection", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  const SizedBox(height: 12),
                  _buildAttendanceTable(),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))),
            const SizedBox(width: 12),
            Expanded(child: _buildDropdown(label: "Section", value: _selectedSection, items: ['A', 'B', 'C', 'D'], onChanged: (v) => setState(() => _selectedSection = v!))),
          ]),
          const SizedBox(height: 12),
          _buildDatePickerField(),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _fetchAttendanceData, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2875), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Get Data")),
        ]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(flex: 2, child: _buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!))),
        const SizedBox(width: 8),
        Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))),
        const SizedBox(width: 8),
        Expanded(child: _buildDropdown(label: "Section", value: _selectedSection, items: ['A', 'B', 'C', 'D'], onChanged: (v) => setState(() => _selectedSection = v!))),
        const SizedBox(width: 8),
        Expanded(flex: 2, child: _buildDatePickerField()),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: _fetchAttendanceData, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2875), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Get Data")),
      ]);
    });
  }

  Widget _buildDatePickerField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      const Text("Date", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      const SizedBox(height: 4),
      GestureDetector(onTap: _showDatePicker, child: Container(key: _dateKey, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF1E2875).withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(4)), child: Row(children: [Expanded(child: Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875)), overflow: TextOverflow.ellipsis)), const Icon(Icons.calendar_month, size: 20, color: Color(0xFF1E2875))]))),
    ]);
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      const SizedBox(height: 4),
      Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFF1E2875).withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875)), iconEnabledColor: const Color(0xFF1E2875), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: onChanged))),
    ]);
  }

  Widget _buildAttendanceTable() {
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Container(decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300)), child: DataTable(headingRowColor: WidgetStateProperty.all(const Color(0xFF1E2875)), headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), dataRowMinHeight: 40, dataRowMaxHeight: 40, columnSpacing: 20, columns: const [DataColumn(label: Text("#")), DataColumn(label: Text("Student Name")), DataColumn(label: Text("Present"))], rows: List.generate(_students.length, (index) { final s = _students[index]; return DataRow(cells: [DataCell(Text("${index + 1}")), DataCell(Text(s['name']!)), DataCell(Checkbox(value: s['present'], activeColor: const Color(0xFF1E2875), onChanged: (val) => setState(() => s['present'] = val!)))]); }))));
  }
}
