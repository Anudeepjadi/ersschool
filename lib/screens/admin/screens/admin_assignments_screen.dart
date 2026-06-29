import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/admin_app_bar.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/app_footer.dart';

class AdminAssignmentsScreen extends StatefulWidget {
  const AdminAssignmentsScreen({super.key});

  @override
  State<AdminAssignmentsScreen> createState() => _AdminAssignmentsScreenState();
}

class _AdminAssignmentsScreenState extends State<AdminAssignmentsScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'A';
  String _displayClass = 'Grade 1';
  String _displaySection = 'A';
  List<Map<String, String>> _assignments = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  void _fetchAssignments() {
    setState(() {
      _displayClass = _selectedClass;
      _displaySection = _selectedSection;
      if (_selectedBranch == 'Ecstasy School 1 (ECS001)' && _selectedClass == 'Grade 1' && _selectedSection == 'A') {
        _assignments = [{'title': 'Creative activity', 'description': 'Complete creative art integration work using cardboard, paper and other props and color the same.', 'assignDate': '4/3/2026', 'dueDate': '9/3/2026'}];
      } else if (_selectedBranch == 'Ecstasy School 2 (ECS002)') {
        _assignments = [{'title': 'Maths Homework', 'description': 'Solve problems from page 45 of the textbook.', 'assignDate': '10/3/2026', 'dueDate': '15/3/2026'}];
      } else {
        _assignments = [{'title': '$_displayClass Assignment ($_displaySection)', 'description': 'Generic assignment details.', 'assignDate': '01/04/2026', 'dueDate': '15/04/2026'}];
      }
    });
  }

  void _showAssignmentDialog({int? index}) {
    final titleController = TextEditingController(text: index != null ? _assignments[index]['title'] : '');
    final descController = TextEditingController(text: index != null ? _assignments[index]['description'] : '');
    DateTime assignDate = DateTime(2026, 3, 4);
    DateTime dueDate = DateTime(2026, 3, 9);
    bool isCompleted = false;
    String? selectedFileName;
    final GlobalKey assignDateKey = GlobalKey();
    final GlobalKey dueDateKey = GlobalKey();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          titlePadding: EdgeInsets.zero,
          title: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.vertical(top: Radius.circular(8))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Class Assignment", style: TextStyle(color: Colors.white, fontSize: 18)), GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white, size: 20))])),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Title", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 4),
                TextField(controller: titleController, decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)))),
                const SizedBox(height: 16),
                const Text("Description", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 4),
                TextField(controller: descController, maxLines: 4, decoration: InputDecoration(isDense: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)))),
                const SizedBox(height: 16),
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 400) {
                    return Column(children: [_buildDateColumn("Assignment Date", assignDate, assignDateKey, (d) => setModalState(() => assignDate = d)), const SizedBox(height: 12), _buildDateColumn("Due Date", dueDate, dueDateKey, (d) => setModalState(() => dueDate = d)), const SizedBox(height: 12), _buildCompletedRow(isCompleted, (v) => setModalState(() => isCompleted = v))]);
                  }
                  return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: _buildDateColumn("Assignment Date", assignDate, assignDateKey, (d) => setModalState(() => assignDate = d))), const SizedBox(width: 8), Expanded(child: _buildDateColumn("Due Date", dueDate, dueDateKey, (d) => setModalState(() => dueDate = d))), const SizedBox(width: 8), _buildCompletedRow(isCompleted, (v) => setModalState(() => isCompleted = v))]);
                }),
                const SizedBox(height: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ElevatedButton.icon(onPressed: () async { try { FilePickerResult? result = await FilePicker.pickFiles(); if (result != null) setModalState(() => selectedFileName = result.files.first.name); } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error picking file"))); } }, icon: const Icon(Icons.attach_file, size: 16), label: const Text("Attachment"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
                  if (selectedFileName != null) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text("Selected: $selectedFileName", style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w500))),
                ]),
              ],
            ),
          ),
          ),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Cancel")),
            ElevatedButton(onPressed: () { setState(() { final data = {'title': titleController.text, 'description': descController.text, 'assignDate': "${assignDate.day}/${assignDate.month}/${assignDate.year}", 'dueDate': "${dueDate.day}/${dueDate.month}/${dueDate.year}"}; if (index == null) { _assignments.add(data); } else { _assignments[index] = data; } }); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Save")),
          ],
        ),
      ),
    );
    });
  }

  Widget _buildDateColumn(String label, DateTime date, GlobalKey key, Function(DateTime) onSelected) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 4), GestureDetector(onTap: () { Future.delayed(const Duration(milliseconds: 100), () => showCustomDatePicker(context: context, anchorKey: key, initialDate: date, onDateSelected: onSelected)); }, child: Container(key: key, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: Row(children: [Expanded(child: Text("${date.day}/${date.month}/${date.year}", style: const TextStyle(fontSize: 12))), const Icon(Icons.calendar_month, size: 18, color: Colors.black54)])))]);
  }

  Widget _buildCompletedRow(bool value, Function(bool) onChanged) {
    return Column(mainAxisSize: MainAxisSize.min, children: [const Text("Is Completed", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)), Checkbox(value: value, onChanged: (val) => onChanged(val!))]);
  }

  void _deleteAssignment(int index) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(context: context, builder: (context) => AlertDialog(title: const Text("Delete Assignment"), content: const Text("Are you sure you want to delete this assignment?"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")), TextButton(onPressed: () { setState(() => _assignments.removeAt(index)); Navigator.pop(context); }, child: const Text("Yes", style: TextStyle(color: Colors.red)))]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(title: "Class Assignments", subtitle: "Manage class assignments"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilters(),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(child: Text("Class: $_displayClass - $_displaySection", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), overflow: TextOverflow.ellipsis)), 
                    _buildAddNewButton(),
                  ]),
                  const SizedBox(height: 16),
                  ..._assignments.asMap().entries.map((entry) => _buildAssignmentCard(entry.key, entry.value)),
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
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!)), const SizedBox(height: 12), Row(children: [Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))), const SizedBox(width: 12), Expanded(child: _buildDropdown(label: "Section", value: _selectedSection, items: ['A', 'B', 'C', 'D'], onChanged: (v) => setState(() => _selectedSection = v!)))]), const SizedBox(height: 16), ElevatedButton(onPressed: _fetchAssignments, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Get Data"))]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(flex: 2, child: _buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))), const SizedBox(width: 8), Expanded(child: _buildDropdown(label: "Section", value: _selectedSection, items: ['A', 'B', 'C', 'D'], onChanged: (v) => setState(() => _selectedSection = v!))), const SizedBox(width: 8), ElevatedButton(onPressed: _fetchAssignments, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Get Data"))]);
    });
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, isExpanded: true, style: const TextStyle(fontSize: 13, color: Colors.black87), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: onChanged)))]);
  }

  Widget _buildAddNewButton() {
    return ElevatedButton.icon(
      onPressed: () => _showAssignmentDialog(),
      icon: const Icon(Icons.add, size: 18),
      label: const Text("Add New"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildAssignmentCard(int index, Map<String, String> assignment) {
    return Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(assignment['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)), const SizedBox(height: 8), Text(assignment['description']!, style: const TextStyle(fontSize: 13, color: Colors.black54)), const SizedBox(height: 16), Row(children: [const Text("Assignment Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)), Text(assignment['assignDate']!, style: const TextStyle(fontSize: 11)), const Spacer(), const Text("Due Date: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)), Text(assignment['dueDate']!, style: const TextStyle(fontSize: 11))]), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.end, children: [IconButton(onPressed: () => _showAssignmentDialog(index: index), icon: const Icon(Icons.edit, color: Colors.blue, size: 20)), IconButton(onPressed: () => _deleteAssignment(index), icon: const Icon(Icons.delete, color: Colors.red, size: 20))])]));
  }
}
