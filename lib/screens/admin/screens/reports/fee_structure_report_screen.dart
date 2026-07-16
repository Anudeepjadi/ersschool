import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/scrollable_table_wrapper.dart';

class FeeStructureReportScreen extends StatefulWidget {
  const FeeStructureReportScreen({super.key});
  @override
  State<FeeStructureReportScreen> createState() =>
      _FeeStructureReportScreenState();
}

class _FeeStructureReportScreenState extends State<FeeStructureReportScreen> {
  final _store = AppDataStore.instance;
  final ScrollController _scrollController = ScrollController();

  String _selectedBranch = 'Ecstasy School 1';
  String _selectedYear = '2025-26';
  String _selectedClass = 'Class 1';

  List<Map<String, dynamic>> get _computedTermFees {
    double totalFee = _feeRows.fold(0.0, (sum, r) => sum + ((r['amount'] ?? 0.0) as double));
    double partFee = totalFee / 3;
    return [
      {'term': 'Term 1', 'amount': partFee, 'dueDate': '12/6/2025'},
      {'term': 'Term 2', 'amount': partFee, 'dueDate': '1/9/2025'},
      {'term': 'Term 3', 'amount': partFee, 'dueDate': '1/12/2025'},
    ];
  }

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
    _scrollController.dispose();
    super.dispose();
  }

  void _loadFees() {
    setState(() {
      _feeRows = _store.getFeeStructureItems(
          _selectedBranch, _selectedYear, _selectedClass);
    });
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
    final classList = _classes.isEmpty ? ['Class 1'] : _classes;
    if (!classList.contains(_selectedClass)) {
      _selectedClass = classList.first;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(title: "Reports".tr, subtitle: "Fee Structure".tr),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        child: Column(children: [
          // Filter bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Center(
                child: Text("Fee Structure for Class",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _dd('Branch', _selectedBranch, branchList,
                    (v) => setState(() => _selectedBranch = v!))),
                const SizedBox(width: 12),
                Expanded(child: _dd('Academic Year', _selectedYear, yearList,
                    (v) => setState(() => _selectedYear = v!))),
                const SizedBox(width: 12),
                Expanded(child: _dd('Class', _selectedClass, classList,
                    (v) => setState(() => _selectedClass = v!))),
                const SizedBox(width: 16),
                  Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: ElevatedButton(
                    onPressed: _loadFees,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: Text('Get Fee Details'.tr, style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ]),
            ]),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ScrollableTableWrapper(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FixedColumnWidth(150),
                      1: FixedColumnWidth(100),
                      2: FixedColumnWidth(100),
                      3: FixedColumnWidth(200),
                      4: FixedColumnWidth(120),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: AppColors.primary),
                        children: [
                          Padding(padding: EdgeInsets.all(12), child: Text("Branch", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: EdgeInsets.all(12), child: Text("Academic Year", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: EdgeInsets.all(12), child: Text("Class", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: EdgeInsets.all(12), child: Text("Fee Type", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: EdgeInsets.all(12), child: Text("Fee Amount", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                        ],
                      ),
                      if (_feeRows.isEmpty)
                        TableRow(children: [
                          Container(), Container(), Container(),
                          Padding(padding: const EdgeInsets.all(24), child: Center(child: Text("No records found".tr, style: const TextStyle(color: Colors.grey)))),
                          Container(),
                        ])
                      else
                        ..._feeRows.map((row) => TableRow(
                              children: [
                                Padding(padding: const EdgeInsets.all(12), child: Text(row['branch'], style: const TextStyle(fontSize: 12))),
                                Padding(padding: const EdgeInsets.all(12), child: Text(row['year'], style: const TextStyle(fontSize: 12))),
                                Padding(padding: const EdgeInsets.all(12), child: Text(row['class'], style: const TextStyle(fontSize: 12))),
                                Padding(padding: const EdgeInsets.all(12), child: Text(row['feeType'], style: const TextStyle(fontSize: 12))),
                                Padding(padding: const EdgeInsets.all(12), child: Text(row['amount'].toStringAsFixed(2), style: const TextStyle(fontSize: 12))),
                              ],
                            )),
                      TableRow(
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05)),
                        children: [
                          Container(), Container(), Container(),
                          const Padding(padding: EdgeInsets.all(12), child: Text("Total Fee", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          Padding(padding: const EdgeInsets.all(12), child: Text(_feeRows.fold(0.0, (sum, r) => sum + (r['amount'] as double)).toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Text("Term Fee Details".tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Table(
                            border: TableBorder.all(color: Colors.grey.shade400),
                            columnWidths: const {0: FixedColumnWidth(80), 1: FixedColumnWidth(100), 2: FixedColumnWidth(100)},
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(color: AppColors.primary),
                                children: [
                                  Padding(padding: EdgeInsets.all(8), child: Text("Term", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                                  Padding(padding: EdgeInsets.all(8), child: Text("Amount", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                                  Padding(padding: EdgeInsets.all(8), child: Text("Due Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                                ],
                              ),
                              ..._computedTermFees.map((f) => TableRow(
                                    children: [
                                      Padding(padding: const EdgeInsets.all(8), child: Text(f['term'], style: const TextStyle(fontSize: 11))),
                                      Padding(padding: const EdgeInsets.all(8), child: Text((f['amount'] as double).toStringAsFixed(2), style: const TextStyle(fontSize: 11))),
                                      Padding(padding: const EdgeInsets.all(8), child: Text(f['dueDate'], style: const TextStyle(fontSize: 11))),
                                    ],
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _dd(String label, String value, List<String> items,
      void Function(String?) onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(
              fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
      SizedBox(height: 3),
      DropdownButtonFormField<String>(
        initialValue: items.contains(value) ? value : items.first,
        isExpanded: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          isDense: true,
        ),
        items: items
            .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s,
                    style: TextStyle(fontSize: 11),
                    overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
      ),
    ]);
  }
}
