import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';

class AdminAcademicYearsScreen extends StatefulWidget {
  const AdminAcademicYearsScreen({super.key});
  @override
  State<AdminAcademicYearsScreen> createState() =>
      _AdminAcademicYearsScreenState();
}

class _AdminAcademicYearsScreenState
    extends State<AdminAcademicYearsScreen> {
  final _store = AppDataStore.instance;
  final _yearCtrl = TextEditingController();

  List<Map<String, dynamic>> get _years => _store.academicYears;
  String get _currentYear => _store.currentAcademicYear;

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => setState(() {});

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _yearCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog({int? editIndex}) {
    _yearCtrl.text =
        editIndex != null ? _years[editIndex]['year'] as String : '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          editIndex != null ? 'Edit Academic Year' : 'Add Academic Year',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: TextField(
          controller: _yearCtrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Academic Year (e.g. 2028-29)',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white),
            onPressed: () {
              final yr = _yearCtrl.text.trim();
              if (yr.isEmpty) return;
              if (editIndex != null) {
                _store.updateAcademicYear(
                    editIndex, {..._years[editIndex], 'year': yr});
              } else {
                _store.addAcademicYear({'year': yr, 'isActive': true});
              }
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(editIndex != null
                    ? 'Academic year updated'
                    : 'Academic year added'),
                backgroundColor: const Color(0xFF16A34A),
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
    final yr = _years[index]['year'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Academic Year',
            style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Delete "$yr"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _store.deleteAcademicYear(index);
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
          title: 'Academic Year', subtitle: 'Manage academic years'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // ── Main table ───────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const Text('Academic Years',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45309))),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddDialog(),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                color: const Color(0xFF2D3748),
                child: const Row(children: [
                  Expanded(
                      flex: 3,
                      child: Text('Academic Year',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Text('Is Active',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13))),
                  SizedBox(width: 76),
                ]),
              ),
              ..._years.asMap().entries.map((e) {
                final i = e.key;
                final y = e.value;
                return Column(children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(children: [
                      Expanded(
                          flex: 3,
                          child: Text(y['year'],
                              style: const TextStyle(fontSize: 13))),
                      Expanded(
                        flex: 2,
                        child: Icon(
                          (y['isActive'] as bool? ?? true)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: const Color(0xFF2563EB),
                          size: 20,
                        ),
                      ),
                      Row(children: [
                        InkWell(
                          onTap: () => _showAddDialog(editIndex: i),
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
                    ]),
                  ),
                  if (i < _years.length - 1)
                    Divider(height: 1, color: Colors.grey.shade100),
                ]);
              }),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
                child: Row(children: [
                  const Text('Items per page:',
                      style:
                          TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white),
                    child: const Text('25', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 16),
                  Text('1 - ${_years.length} of ${_years.length}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          // ── Current Year selector ────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Academic Year',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _years.any((y) =>
                                y['year'] == _currentYear)
                            ? _currentYear
                            : (_years.isNotEmpty
                                ? _years.first['year'] as String
                                : null),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        items: _years
                            .map((y) => DropdownMenuItem(
                                  value: y['year'] as String,
                                  child: Text(y['year'] as String,
                                      style:
                                          const TextStyle(fontSize: 13)),
                                ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            _store.setCurrentAcademicYear(v);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Current year set to $_currentYear'),
                        backgroundColor: const Color(0xFFB45309),
                        behavior: SnackBarBehavior.floating,
                      )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB45309),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save'),
                    ),
                  ]),
                ]),
          ),
        ]),
      ),
    );
  }
}
