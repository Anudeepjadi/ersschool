import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../../../widgets/custom_date_picker.dart';
import '../../../widgets/app_footer.dart';

class AdminDiaryScreen extends StatefulWidget {
  const AdminDiaryScreen({super.key});

  @override
  State<AdminDiaryScreen> createState() => _AdminDiaryScreenState();
}

class _AdminDiaryScreenState extends State<AdminDiaryScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'A';
  DateTime _selectedDate = DateTime(2026, 6, 24);
  final GlobalKey _dateKey = GlobalKey();
  
  // List to store diary entries
  List<Map<String, String>> _diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _fetchDiaryData();
  }

  void _showDatePicker() {
    Future.delayed(const Duration(milliseconds: 100), () => showCustomDatePicker(
      context: context,
      anchorKey: _dateKey,
      initialDate: _selectedDate,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
          _fetchDiaryData(); // Refetch when date changes
        });
      },
    ));
  }

  void _fetchDiaryData() {
    setState(() {
      // Mock: Load different data based on school/date
      if (_selectedBranch == 'Ecstasy School 1 (ECS001)' && _selectedClass == 'Grade 1' && _selectedSection == 'A') {
        _diaryEntries = [
          {'subject': 'Mathematics', 'message': 'Solve exercise 5.1 questions'},
          {'subject': 'English', 'message': 'Read Chapter 3 and write summary'},
        ];
      } else {
        _diaryEntries = [];
      }
    });
  }

  void _showAddDiaryDialog() {
    final subjectController = TextEditingController();
    final textController = TextEditingController();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          titlePadding: EdgeInsets.zero,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dairy", style: TextStyle(color: Colors.white, fontSize: 18)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", 
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                const SizedBox(height: 16),
                const Text("Subject", style: TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                const SizedBox(height: 4),
                TextField(
                  controller: subjectController,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Dairy Text", style: TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                const SizedBox(height: 4),
                TextField(
                  controller: textController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (subjectController.text.isEmpty || textController.text.isEmpty) return;
                
                setState(() {
                  _diaryEntries.add({
                    'subject': subjectController.text,
                    'message': textController.text,
                  });
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dairy entry saved successfully!")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2875), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(
        title: "Class Dairy",
        subtitle: "Manage daily class updates",
      ),
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
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildGreyButton("Previous", () {
                          setState(() {
                            _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                            _fetchDiaryData();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildBlueButton("Today", () {
                          setState(() {
                            _selectedDate = DateTime.now();
                            _fetchDiaryData();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildGreyButton("Next", () {
                          setState(() {
                            _selectedDate = _selectedDate.add(const Duration(days: 1));
                            _fetchDiaryData();
                          });
                        }),
                        const SizedBox(width: 8),
                        _buildGreenButton("Add New", _showAddDiaryDialog),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  ),
                  const SizedBox(height: 12),
                  _buildDiaryTable(),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown(
              label: "Branch",
              value: _selectedBranch,
              items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'],
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Class",
                    value: _selectedClass,
                    items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'],
                    onChanged: (v) => setState(() => _selectedClass = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: "Section",
                    value: _selectedSection,
                    items: ['A', 'B', 'C', 'D'],
                    onChanged: (v) => setState(() => _selectedSection = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildDatePickerField(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchDiaryData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2875),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: const Text("Get Data"),
            ),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: _buildDropdown(
              label: "Branch",
              value: _selectedBranch,
              items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'],
              onChanged: (v) => setState(() => _selectedBranch = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDropdown(
              label: "Class",
              value: _selectedClass,
              items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'],
              onChanged: (v) => setState(() => _selectedClass = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDropdown(
              label: "Section",
              value: _selectedSection,
              items: ['A', 'B', 'C', 'D'],
              onChanged: (v) => setState(() => _selectedSection = v!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildDatePickerField()),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _fetchDiaryData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2875),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Get Data"),
          ),
        ],
      );
    });
  }

  Widget _buildDatePickerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Date", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            key: _dateKey,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF1E2875).withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.calendar_month, size: 20, color: Color(0xFF1E2875)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF1E2875).withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875)),
              iconEnabledColor: const Color(0xFF1E2875),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreyButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildBlueButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E2875),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildGreenButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildDiaryTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Container(
            color: const Color(0xFF1E2875),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 1, child: Center(child: Text("Subject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                Expanded(flex: 2, child: Center(child: Text("Message", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
              ],
            ),
          ),
          if (_diaryEntries.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text("No Records Found", style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _diaryEntries.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = _diaryEntries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Center(child: Text(entry['subject']!, style: const TextStyle(fontSize: 12, color: Colors.black87)))),
                      Expanded(flex: 2, child: Center(child: Text(entry['message']!, style: const TextStyle(fontSize: 12, color: Colors.black87)))),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
