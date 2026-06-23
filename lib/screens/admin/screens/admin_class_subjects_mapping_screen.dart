import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';

class AdminClassSubjectsMappingScreen extends StatefulWidget {
  const AdminClassSubjectsMappingScreen({super.key});
  @override
  State<AdminClassSubjectsMappingScreen> createState() =>
      _AdminClassSubjectsMappingScreenState();
}

class _AdminClassSubjectsMappingScreenState
    extends State<AdminClassSubjectsMappingScreen> {
  final _store = AppDataStore.instance;
  final _classCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _teacherCtrl = TextEditingController();

  List<Map<String, String>> get _mappings => _store.classSubjectsMapping;

  // Live class / subject lists from AppDataStore
  List<String> get _classOptions =>
      _store.studyClasses.map((c) => c['name'].toString()).toList();
  List<String> get _subjectOptions =>
      _store.subjects.map((s) => s['name'].toString()).toList();

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => setState(() {});

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _classCtrl.dispose();
    _subjectCtrl.dispose();
    _teacherCtrl.dispose();
    super.dispose();
  }

  void _showDialog({int? editIndex}) {
    _classCtrl.text =
        editIndex != null ? (_mappings[editIndex]['class'] ?? '') : '';
    _subjectCtrl.text =
        editIndex != null ? (_mappings[editIndex]['subject'] ?? '') : '';
    _teacherCtrl.text =
        editIndex != null ? (_mappings[editIndex]['teacher'] ?? '') : '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          editIndex != null ? 'Edit Mapping' : 'Add Class-Subject Mapping',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          // Class dropdown (from StudyClasses)
          _classOptions.isEmpty
              ? TextField(
                  controller: _classCtrl,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              : DropdownButtonFormField<String>(
                  value: _classOptions.contains(_classCtrl.text)
                      ? _classCtrl.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: _classOptions
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => _classCtrl.text = v ?? '',
                ),
          const SizedBox(height: 10),
          // Subject dropdown (from Subjects)
          _subjectOptions.isEmpty
              ? TextField(
                  controller: _subjectCtrl,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )
              : DropdownButtonFormField<String>(
                  value: _subjectOptions.contains(_subjectCtrl.text)
                      ? _subjectCtrl.text
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  items: _subjectOptions
                      .map((s) =>
                          DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => _subjectCtrl.text = v ?? '',
                ),
          const SizedBox(height: 10),
          TextField(
            controller: _teacherCtrl,
            decoration: InputDecoration(
              labelText: 'Teacher',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
            ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white),
            onPressed: () {
              if (_classCtrl.text.isEmpty) return;
              final entry = {
                'class': _classCtrl.text,
                'subject': _subjectCtrl.text,
                'teacher': _teacherCtrl.text,
              };
              if (editIndex != null) {
                _store.updateClassSubjectMapping(editIndex, entry);
              } else {
                _store.addClassSubjectMapping(entry);
              }
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(editIndex != null
                    ? 'Mapping updated'
                    : 'Mapping added'),
                backgroundColor: const Color(0xFF0891B2),
                behavior: SnackBarBehavior.floating,
              ));
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Mapping',
            style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _store.deleteClassSubjectMapping(index);
              setState(() {});
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
          title: 'Class Subjects Mapping',
          subtitle: 'Map subjects to classes'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(children: [
              const Text('Class Subjects Mapping',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45309))),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _showDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0891B2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ),
        ),
        // ── Table header ─────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF2D3748),
          child: const Row(children: [
            Expanded(
                child: Text('Class  /  Subject  /  Teacher',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
            SizedBox(width: 76),
          ]),
        ),

        Expanded(
          child: _mappings.isEmpty
              ? const Center(
                  child: Text('No mappings added yet.',
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _mappings.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (_, i) {
                    final m = _mappings[i];
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // ── Info column ──────────────────────────────────
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Class badge + Subject name on one line
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E2875)
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      m['class'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E2875)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      m['subject'] ?? '',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFFB45309)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 4),
                                // Teacher name below
                                Row(children: [
                                  const Icon(Icons.person_outline,
                                      size: 13, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    m['teacher'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                              ],
                            ),
                          ),
                          // ── Action buttons ───────────────────────────────
                          Row(children: [
                            InkWell(
                              onTap: () => _showDialog(editIndex: i),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF2563EB),
                                    shape: BoxShape.circle),
                                child: const Icon(Icons.edit,
                                    color: Colors.white, size: 16),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _delete(i),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.delete_outline,
                                    color: Colors.red.shade700, size: 16),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFFFEF3C7),
          child: Row(children: [
            const Text('Items per page:',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white),
              child: const Text('10', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 16),
            Text('1 - ${_mappings.length} of ${_mappings.length}',
                style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
