import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';

/// Generic configurable list screen used for:
/// Payment Types, Study Class, Class Section, Subjects,
/// Class Subjects Mapping, Exam Type, Grade System, Grade Report Design,
/// Export Data, Student/Parent Users, Super Admin Settings
class AdminGenericConfigScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> columns;
  final List<Map<String, String>> initialData;
  final IconData icon;
  final Color color;

  const AdminGenericConfigScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.initialData,
    required this.icon,
    required this.color,
  });

  @override
  State<AdminGenericConfigScreen> createState() => _AdminGenericConfigScreenState();
}

class _AdminGenericConfigScreenState extends State<AdminGenericConfigScreen> {
  late List<Map<String, String>> _data;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _data = List.from(widget.initialData);
    _controllers = widget.columns.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  void _showAddDialog({int? editIndex}) {
    for (int i = 0; i < widget.columns.length; i++) {
      _controllers[i].text = editIndex != null ? (_data[editIndex][widget.columns[i]] ?? '') : '';
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(editIndex != null ? 'Edit ${widget.title}' : 'Add New ${widget.title}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            ...widget.columns.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: _controllers[e.key],
                decoration: InputDecoration(labelText: e.value, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
              ),
            )),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: widget.color, foregroundColor: Colors.white),
            onPressed: () {
              if (_controllers.first.text.isEmpty) return;
              setState(() {
                final entry = {for (int i = 0; i < widget.columns.length; i++) widget.columns[i]: _controllers[i].text};
                if (editIndex != null) _data[editIndex] = entry;
                else _data.add(entry);
              });
              Navigator.pop(ctx);
            },
            child: Text(editIndex != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _delete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () { setState(() => _data.removeAt(index)); Navigator.pop(ctx); }, child: const Text('Delete')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: widget.title, subtitle: widget.subtitle),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(child: Column(children: [
            Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(backgroundColor: widget.color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ])),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(color: Color(0xFF2D3748), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                  child: Row(children: [
                    ...widget.columns.map((c) => Expanded(child: Text(c, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)))),
                    const SizedBox(width: 80),
                  ]),
                ),
                _data.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text('No ${widget.title.toLowerCase()} entries yet', style: const TextStyle(color: Colors.grey)),
                      )
                    : Column(children: _data.asMap().entries.map((e) {
                        final i = e.key; final row = e.value;
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(children: [
                              ...widget.columns.map((c) => Expanded(child: Text(row[c] ?? '', style: const TextStyle(fontSize: 13)))),
                              Row(children: [
                                InkWell(onTap: () => _showAddDialog(editIndex: i), child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle), child: const Icon(Icons.edit, color: Colors.white, size: 16))),
                                const SizedBox(width: 8),
                                InkWell(onTap: () => _delete(i), child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.red.shade100, shape: BoxShape.circle), child: Icon(Icons.delete_outline, color: Colors.red.shade700, size: 16))),
                              ]),
                            ]),
                          ),
                          if (i < _data.length - 1) Divider(height: 1, color: Colors.grey.shade100),
                        ]);
                      }).toList()),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12))),
                  child: Row(children: [
                    const Text('Items per page:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(width: 8),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4), color: Colors.white), child: const Text('10', style: TextStyle(fontSize: 12))),
                    const SizedBox(width: 16),
                    Text('1 - ${_data.length} of ${_data.length}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
