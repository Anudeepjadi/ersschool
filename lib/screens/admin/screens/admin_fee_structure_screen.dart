import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';

class AdminFeeStructureScreen extends StatefulWidget {
  const AdminFeeStructureScreen({super.key});
  @override
  State<AdminFeeStructureScreen> createState() =>
      _AdminFeeStructureScreenState();
}

class _AdminFeeStructureScreenState extends State<AdminFeeStructureScreen> {
  final _store = AppDataStore.instance;

  String _selectedBranch = 'Ecstasy School 1';
  String _selectedYear = '2025-26';
  String _selectedClass = 'Grade 1';

  // These are pulled live from AppDataStore so adding a new class/year shows up here
  List<String> get _branches => _store.branches
      .map((b) => (b['name'] ?? '').toString())
      .where((n) => n.isNotEmpty)
      .toSet()
      .toList();

  List<String> get _years =>
      _store.academicYears.map((y) => y['year'].toString()).toList();

  List<String> get _classes =>
      _store.studyClasses.map((c) => c['name'].toString()).toList();

  List<Map<String, dynamic>> _feeRows = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
    // Set defaults to first available
    if (_years.isNotEmpty) _selectedYear = _store.currentAcademicYear;
    if (_classes.isNotEmpty &&
        !_classes.contains(_selectedClass)) {
      _selectedClass = _classes.first;
    }
    _loadFees();
  }

  void _onStoreChanged() {
    setState(() {
      // Ensure selection is still valid after config changes
      if (_years.isNotEmpty && !_years.contains(_selectedYear)) {
        _selectedYear = _years.first;
      }
      if (_classes.isNotEmpty && !_classes.contains(_selectedClass)) {
        _selectedClass = _classes.first;
      }
    });
  }

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _loadFees() {
    setState(() {
      _feeRows = _store.getFeeStructureItems(
          _selectedBranch, _selectedYear, _selectedClass);
      _loaded = true;
    });
  }

  void _showAddDialog({int? editIndex}) {
    // Find the global index in feeStructureItems
    final globalIndex = editIndex != null
        ? _store.feeStructureItems.indexOf(_feeRows[editIndex])
        : -1;

    final typeCtrl = TextEditingController(
        text: editIndex != null ? _feeRows[editIndex]['feeType'] : '');
    final amtCtrl = TextEditingController(
        text: editIndex != null
            ? (_feeRows[editIndex]['amount'] as double).toString()
            : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          editIndex != null ? 'Edit Fee Structure' : 'Add Fee Structure',
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: typeCtrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Fee Type',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: amtCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Fee Amount (\u20B9)',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white),
            onPressed: () {
              final amt = double.tryParse(amtCtrl.text) ?? 0;
              final entry = {
                'branch': _selectedBranch,
                'year': _selectedYear,
                'class': _selectedClass,
                'feeType': typeCtrl.text.trim(),
                'amount': amt,
              };
              if (editIndex != null && globalIndex >= 0) {
                _store.updateFeeStructureItem(globalIndex, entry);
              } else {
                _store.addFeeStructureItem(entry);
              }
              _loadFees();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(editIndex != null
                    ? 'Fee structure updated'
                    : 'Fee structure added'),
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
    final globalIndex = _store.feeStructureItems.indexOf(_feeRows[index]);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Entry',
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
              if (globalIndex >= 0) {
                _store.deleteFeeStructureItem(globalIndex);
              }
              _loadFees();
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
    final branchList = _branches.isEmpty
        ? ['Ecstasy School 1', 'Ecstasy School 2']
        : _branches;
    if (!branchList.contains(_selectedBranch)) {
      _selectedBranch = branchList.first;
    }
    final yearList = _years.isEmpty ? ['2025-26'] : _years;
    if (!yearList.contains(_selectedYear)) _selectedYear = yearList.first;
    final classList = _classes.isEmpty ? ['Grade 1'] : _classes;
    if (!classList.contains(_selectedClass)) {
      _selectedClass = classList.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
          title: 'Fee Structure', subtitle: 'Fee structure for each class'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(children: [
        // Filter bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [
              Expanded(child: _dd('Branch', _selectedBranch, branchList,
                  (v) => setState(() => _selectedBranch = v!))),
              const SizedBox(width: 8),
              Expanded(child: _dd('Year', _selectedYear, yearList,
                  (v) => setState(() => _selectedYear = v!))),
              const SizedBox(width: 8),
              Expanded(child: _dd('Class', _selectedClass, classList,
                  (v) => setState(() => _selectedClass = v!))),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: _loadFees,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB45309),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
                child: const Text('Get Fee Details',
                    style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(),
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Add New', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                ),
              ),
            ]),
          ]),
        ),
        // Table header
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF2D3748),
          child: const Row(children: [
            Expanded(flex: 2, child: Text('Branch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 56, child: Text('Year', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 56, child: Text('Class', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            Expanded(flex: 2, child: Text('Fee Type', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 60, child: Text('Amount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 68),
          ]),
        ),
        // Rows
        Expanded(
          child: !_loaded
              ? const Center(child: CircularProgressIndicator())
              : _feeRows.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.table_chart_outlined,
                              size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text(
                              'No fee structure for this selection.\nTap "Add New" to add one.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: _feeRows.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade100),
                      itemBuilder: (_, i) {
                        final row = _feeRows[i];
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(children: [
                            Expanded(
                                flex: 2,
                                child: Text(row['branch'],
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)),
                            SizedBox(
                                width: 56,
                                child: Text(row['year'],
                                    style: const TextStyle(fontSize: 11))),
                            SizedBox(
                              width: 56,
                              child: Text(row['class'],
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFB45309),
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                                flex: 2,
                                child: Text(row['feeType'],
                                    style: const TextStyle(fontSize: 11),
                                    maxLines: 2)),
                            SizedBox(
                              width: 60,
                              child: Text(
                                (row['amount'] as double)
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(children: [
                              InkWell(
                                onTap: () => _showAddDialog(editIndex: i),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF2563EB),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.edit,
                                      color: Colors.white, size: 14),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () => _delete(i),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.red.shade700,
                                      size: 14),
                                ),
                              ),
                            ]),
                          ]),
                        );
                      },
                    ),
        ),
        // Footer
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
            Text('1 - ${_feeRows.length} of ${_feeRows.length}',
                style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }

  Widget _dd(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
      const SizedBox(height: 3),
      DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          isDense: true,
        ),
        items: items
            .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s,
                    style: const TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
      ),
    ]);
  }
}
