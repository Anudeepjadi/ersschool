import 'package:ersschool/core/data/app_data_store.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'fee_due_list_screen.dart';

class FeeCollectionSummaryScreen extends StatefulWidget {
  const FeeCollectionSummaryScreen({super.key});

  @override
  State<FeeCollectionSummaryScreen> createState() => _FeeCollectionSummaryScreenState();
}

class _FeeCollectionSummaryScreenState extends State<FeeCollectionSummaryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedBranch = 'Ecstasy School 1 (ECS001)';
  String selectedYear = '2025-26';
  String selectedClass = 'All';
  String selectedTerm = 'All';

  String _tempBranch = 'Ecstasy School 1 (ECS001)';
  String _tempYear = '2025-26';
  String _tempClass = 'All';
  String _tempTerm = 'All';

  final List<String> branches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstay School 2 (ECS002)',
    'Ecstasy (ECS003)',
    'Ecstasy (ECS004)',
  ];

  final List<String> years = [
    '2027-2028',
    '2026-27',
    '2025-26',
  ];
  
  final List<String> classes = [
    'All', 'Nursery', 'LKG', 'UKG',
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'
  ];
  
  final List<String> terms = ['All', 'Term 1', 'Term 2', 'Term 3'];
  
  final Map<String, ScrollController> _scrollControllers = {};

  ScrollController _getScrollController(String key) {
    _scrollControllers.putIfAbsent(key, () => ScrollController());
    return _scrollControllers[key]!;
  }

  @override
  void dispose() {
    for (var c in _scrollControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Fee Collection Report",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

          Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(width: 180, child: _buildBodyDropdown("Branch", _tempBranch, branches, (v) => setState(() => _tempBranch = v!))),
              SizedBox(width: 120, child: _buildBodyDropdown("Academic Year", _tempYear, years, (v) => setState(() => _tempYear = v!))),
              SizedBox(width: 100, child: _buildBodyDropdown("Class", _tempClass, classes, (v) => setState(() => _tempClass = v!))),
              SizedBox(width: 100, child: _buildBodyDropdown("Term", _tempTerm, terms, (v) => setState(() => _tempTerm = v!))),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedBranch = _tempBranch;
                    selectedYear = _tempYear;
                    selectedClass = _tempClass;
                    selectedTerm = _tempTerm;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  minimumSize: const Size(80, 38),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text("Search", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ..._buildDynamicSections(context),
        ],
      ),
      ),
    );
  }

  List<Widget> _buildDynamicSections(BuildContext context) {
    final store = AppDataStore.instance;
    String realBranchName = selectedBranch.split(' (')[0];
    
    List<String> classesToCheck = selectedClass == 'All' 
        ? classes.where((c) => c != 'All').toList() 
        : [selectedClass];

    double tuitionTotal = 0.0;
    double transportTotal = 0.0;
    double otherTotal = 0.0;
    
    for (String cls in classesToCheck) {
      final items = store.getFeeStructureItems(realBranchName, selectedYear, cls);
      
      for (var item in items) {
        String type = (item['feeType'] as String).toLowerCase();
        double amt = (item['amount'] as num).toDouble();
        
        bool isTuition = type.contains('tuition');
        bool isTransport = type.contains('transport');
        bool isOther = !isTuition && !isTransport;

        if (isTuition) {
          tuitionTotal += amt;
        } else if (isTransport) {
          transportTotal += amt;
        } else if (isOther) {
          otherTotal += amt;
        }
      }
    }
    
    List<Widget> sections = [];
    
    sections.add(_buildSection("Tuition Fee", _getScrollController("Tuition Fee"), tuitionTotal));
    sections.add(const SizedBox(height: 32));
    sections.add(_buildSection("Other Fee", _getScrollController("Other Fee"), otherTotal));
    sections.add(const SizedBox(height: 32));
    sections.add(_buildSection("Transport Fee", _getScrollController("Transport Fee"), transportTotal));
    sections.add(const SizedBox(height: 32));
    
    return sections;
  }

  Widget _buildBodyDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
              style: const TextStyle(fontSize: 11, color: Colors.black),
              selectedItemBuilder: (BuildContext context) {
                return items.map<Widget>((String item) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(item, style: const TextStyle(color: Colors.black)),
                  );
                }).toList();
              },
              items: items.map((it) => DropdownMenuItem(
                value: it,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  color: it == value ? Colors.blue.shade600 : Colors.transparent,
                  child: Text(
                    it,
                    style: TextStyle(
                      color: it == value ? Colors.white : Colors.black,
                      fontSize: 11,
                    ),
                  ),
                ),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, ScrollController controller, double totalAmount) {
    String _fmt(double val) => val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    double termAmount = totalAmount / 3;
    
    // Mocking paid amounts
    double paidTerm1 = termAmount * 0.10;
    double paidTerm2 = termAmount * 0.04;
    double paidTerm3 = termAmount * 0.05;

    double balTerm1 = termAmount - paidTerm1;
    double balTerm2 = termAmount - paidTerm2;
    double balTerm3 = termAmount - paidTerm3;

    double totalPaid = paidTerm1 + paidTerm2 + paidTerm3;
    double totalBal = totalAmount - totalPaid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            Row(
              children: [
                const Text("Scroll: ", style: TextStyle(fontSize: 10, color: Colors.grey)),
                IconButton(
                  icon: Icon(Icons.arrow_circle_left_outlined, color: AppColors.primary, size: 20),
                  onPressed: () { if (controller.hasClients) controller.animateTo(controller.offset - 200, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.arrow_circle_right_outlined, color: AppColors.primary, size: 20),
                  onPressed: () { if (controller.hasClients) controller.animateTo(controller.offset + 200, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut); },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(80),
                1: FixedColumnWidth(100),
                2: FixedColumnWidth(100),
                3: FixedColumnWidth(100),
                4: FixedColumnWidth(110),
                5: FixedColumnWidth(110),
              },
              border: TableBorder.all(color: Colors.grey.shade300),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  children: [
                    _buildHeaderCell("Term"),
                    _buildHeaderCell("Total Amount"),
                    _buildHeaderCell("Paid Amount"),
                    _buildHeaderCell("Balance Amount"),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
                if (selectedTerm == 'All' || selectedTerm == 'Term 1') _buildDataRow(title, "Term 1", _fmt(termAmount), _fmt(paidTerm1), _fmt(balTerm1)),
                if (selectedTerm == 'All' || selectedTerm == 'Term 2') _buildDataRow(title, "Term 2", _fmt(termAmount), _fmt(paidTerm2), _fmt(balTerm2)),
                if (selectedTerm == 'All' || selectedTerm == 'Term 3') _buildDataRow(title, "Term 3", _fmt(termAmount), _fmt(paidTerm3), _fmt(balTerm3)),
                if (selectedTerm == 'All') TableRow(
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05)),
                  children: [
                    _buildDataCell("Total", isBold: true),
                    _buildDataCell(_fmt(totalAmount), isBold: true, textAlign: TextAlign.right),
                    _buildDataCell(_fmt(totalPaid), isBold: true, textAlign: TextAlign.right),
                    _buildDataCell(_fmt(totalBal), isBold: true, textAlign: TextAlign.right),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Previous year fee due students >>", style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    );
  }

  TableRow _buildDataRow(String sectionTitle, String term, String total, String paid, String balance) {
    return TableRow(
      children: [
        _buildDataCell(term),
        _buildDataCell(total, textAlign: TextAlign.right),
        _buildDataCell(paid, textAlign: TextAlign.right),
        _buildDataCell(balance, textAlign: TextAlign.right),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {
               // Showing unpaid students as requested by user even when tapping fee paid students
               Navigator.push(context, MaterialPageRoute(builder: (_) => FeeDueListScreen(reportTitle: "$sectionTitle Due Students - $term")));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF108A62),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Fee Paid Students", style: TextStyle(fontSize: 8)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ElevatedButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => FeeDueListScreen(reportTitle: "$sectionTitle Due Students - $term")));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 30),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text("Fee Due Students", style: TextStyle(fontSize: 8)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 9))),
    );
  }

  Widget _buildDataCell(String text, {TextAlign textAlign = TextAlign.left, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(fontSize: 9, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
