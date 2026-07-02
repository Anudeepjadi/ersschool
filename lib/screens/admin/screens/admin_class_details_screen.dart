import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../widgets/app_footer.dart';

class AdminClassDetailsScreen extends StatefulWidget {
  const AdminClassDetailsScreen({super.key});

  @override
  State<AdminClassDetailsScreen> createState() =>
      _AdminClassDetailsScreenState();
}

class _AdminClassDetailsScreenState extends State<AdminClassDetailsScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'LKG';
  String _selectedSection = 'A';

  String _displayClass = 'LKG';
  String _displaySection = 'A';
  String _displayTeacher = '';
  String _displaySubjects = 'Telugu, Maths, Science, Social, Art work, Physics';

  List<Map<String, String>> _displayStudents = [];
  List<Map<String, String>> _filteredStudents = [];

  final TextEditingController _searchController = TextEditingController();
  int _itemsPerPage = 25;
  int _currentPage = 1;

  List<Map<String, String>> _generateMockData(
      String branch, String className, String section) {
    if (branch == 'Ecstasy School 1 (ECS001)') {
      if (className == 'LKG' && section == 'A') {
        return [
          {
            'roll': '1',
            'admission': '02600056',
            'reg': '617',
            'name': 'Ajay T',
            'father': 'Father D. Siva Krishna',
            'lang1': 'English',
            'lang2': 'Hindi',
            'lang3': 'Telugu'
          },
          {
            'roll': '2',
            'admission': '02600058',
            'reg': '-',
            'name': 'Deepika',
            'father': 'Satya',
            'lang1': 'Telugu',
            'lang2': 'English',
            'lang3': 'Hindi'
          },
          {
            'roll': '3',
            'admission': '02600048',
            'reg': '1',
            'name': 'Deepthi',
            'father': 'Srinivas',
            'lang1': 'Telugu',
            'lang2': 'Hindi',
            'lang3': 'English'
          },
          {
            'roll': '4',
            'admission': '02600046',
            'reg': '-',
            'name': 'Deepthi',
            'father': 'Venki',
            'lang1': 'Telugu',
            'lang2': 'English',
            'lang3': 'Hindi'
          },
        ];
      }
      return [
        {
          'roll': '1',
          'admission': '02600099',
          'reg': '101',
          'name': '$className Student ($section)',
          'father': 'Parent Name',
          'lang1': 'English',
          'lang2': 'Hindi',
          'lang3': 'Telugu'
        }
      ];
    } else if (branch == 'Ecstasy School 2 (ECS002)') {
      return [
        {
          'roll': '1',
          'admission': '02700001',
          'reg': '801',
          'name': 'Rahul V',
          'father': 'Vijay Kumar',
          'lang1': 'Hindi',
          'lang2': 'English',
          'lang3': 'Telugu'
        },
        {
          'roll': '2',
          'admission': '02700002',
          'reg': '802',
          'name': 'Sneha K',
          'father': 'Kiran Rao',
          'lang1': 'English',
          'lang2': 'Hindi',
          'lang3': 'Sanskrit'
        },
      ];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _fetchDetails();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterStudents();
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = List.from(_displayStudents);
      } else {
        _filteredStudents = _displayStudents.where((s) {
          final name = s['name']?.toLowerCase() ?? '';
          final admission = s['admission']?.toLowerCase() ?? '';
          final roll = s['roll']?.toLowerCase() ?? '';
          return name.contains(query) ||
              admission.contains(query) ||
              roll.contains(query);
        }).toList();
      }
      _currentPage = 1;
    });
  }

  void _fetchDetails() {
    setState(() {
      _displayClass = _selectedClass;
      _displaySection = _selectedSection;
      _displayStudents =
          _generateMockData(_selectedBranch, _selectedClass, _selectedSection);
      _filterStudents();
      if (_selectedBranch == 'Ecstasy School 2 (ECS002)') {
        _displayTeacher = 'Mr. Rajesh Kumar';
        _displaySubjects = 'Maths, Science, Computer, Yoga';
      } else {
        _displayTeacher =
            _selectedSection == 'A' ? 'Ms. Rani' : 'Mr. Giri Prasad';
        _displaySubjects = 'Telugu, Maths, Science, Social, Art work, Physics';
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Loading details for $_selectedBranch - $_selectedClass ($_selectedSection)")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(
          title: "Class Details",
          subtitle: "View and manage class information"),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
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
                  _buildSearchAndInfo(),
                  const SizedBox(height: 24),
                  const Text("Students",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2875))),
                  const SizedBox(height: 12),
                  _buildStudentsTable(),
                  const SizedBox(height: 16),
                  _buildPaginationBar(),
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
                items: [
                  'Ecstasy School 1 (ECS001)',
                  'Ecstasy School 2 (ECS002)',
                  'Ecstasy School 3 (ECS003)'
                ],
                onChanged: (v) => setState(() => _selectedBranch = v!)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: _buildDropdown(
                      label: "Class",
                      value: _selectedClass,
                      items: ['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'],
                      onChanged: (v) => setState(() => _selectedClass = v!))),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDropdown(
                      label: "Section",
                      value: _selectedSection,
                      items: ['A', 'B', 'C', 'D'],
                      onChanged: (v) => setState(() => _selectedSection = v!))),
            ]),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _fetchDetails,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text("Get Details")),
          ],
        );
      }
      return Row(children: [
        Expanded(
            flex: 3,
            child: _buildDropdown(
                label: "Branch",
                value: _selectedBranch,
                items: [
                  'Ecstasy School 1 (ECS001)',
                  'Ecstasy School 2 (ECS002)',
                  'Ecstasy School 3 (ECS003)'
                ],
                onChanged: (v) => setState(() => _selectedBranch = v!))),
        const SizedBox(width: 12),
        Expanded(
            flex: 2,
            child: _buildDropdown(
                label: "Class",
                value: _selectedClass,
                items: ['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'],
                onChanged: (v) => setState(() => _selectedClass = v!))),
        const SizedBox(width: 12),
        Expanded(
            flex: 1,
            child: _buildDropdown(
                label: "Section",
                value: _selectedSection,
                items: ['A', 'B', 'C', 'D'],
                onChanged: (v) => setState(() => _selectedSection = v!))),
        const SizedBox(width: 12),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
                onPressed: _fetchDetails,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12)),
                child: const Text("Get Details"))),
      ]);
    });
  }

  Widget _buildDropdown(
      {required String label,
      required String value,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875))),
      const SizedBox(height: 4),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color(0xFF1E2875).withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF1E2875)),
                  iconEnabledColor: const Color(0xFF1E2875),
                  items: items
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: onChanged))),
    ]);
  }

  Widget _buildSearchAndInfo() {
    return Column(children: [
      TextField(
          controller: _searchController,
          decoration: InputDecoration(
              hintText: "Search",
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () => _searchController.clear())
                  : const Icon(Icons.search, color: Color(0xFF1E2875)),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                      color: const Color(0xFF1E2875).withValues(alpha: 0.5))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: Color(0xFF1E2875))))),
      const SizedBox(height: 20),
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Column(children: [
            _buildInfoRowMobile("Class", _displayClass),
            const Divider(),
            _buildInfoRowMobile("Class Teacher", _displayTeacher),
            const Divider(),
            _buildInfoRowMobile("Section", _displaySection),
            const Divider(),
            _buildInfoRowMobile("Class Subjects", _displaySubjects),
          ]);
        }
        return Column(children: [
          _buildInfoRow(
              "Class", _displayClass, "Class Teacher", _displayTeacher),
          const Divider(),
          _buildInfoRow(
              "Section", _displaySection, "Class Subjects", _displaySubjects),
        ]);
      }),
    ]);
  }

  Widget _buildInfoRowMobile(String label, String val) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E2875))),
          Flexible(
              child: Text(val.isEmpty ? "N/A" : val,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  textAlign: TextAlign.end))
        ]));
  }

  Widget _buildInfoRow(String label1, String val1, String label2, String val2) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Expanded(
              flex: 1,
              child: Text(label1,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E2875)))),
          Expanded(
              flex: 2,
              child: Text(val1,
                  style: const TextStyle(fontSize: 13, color: Colors.black87))),
          Expanded(
              flex: 1,
              child: Text(label2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF1E2875)))),
          Expanded(
              flex: 2,
              child: Text(val2.isEmpty ? "N/A" : val2,
                  style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ]));
  }

  Widget _buildStudentsTable() {
    if (_filteredStudents.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("No students found matching your search",
                  style: TextStyle(color: Colors.grey))));
    }
    final startIndex =
        ((_currentPage - 1) * _itemsPerPage).clamp(0, _filteredStudents.length);
    final paginatedStudents =
        _filteredStudents.skip(startIndex).take(_itemsPerPage).toList();
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300)),
            child: DataTable(
                headingRowColor:
                    WidgetStateProperty.all(const Color(0xFF1E2875)),
                headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                dataRowMinHeight: 40,
                dataRowMaxHeight: 40,
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text("Roll #")),
                  DataColumn(label: Text("Admission #")),
                  DataColumn(label: Text("Reg #")),
                  DataColumn(label: Text("Full Name")),
                  DataColumn(label: Text("Father Name")),
                  DataColumn(label: Text("1st Language Subject")),
                  DataColumn(label: Text("2nd Language Subject")),
                  DataColumn(label: Text("3rd Language Subject"))
                ],
                rows: paginatedStudents
                    .map((s) => DataRow(cells: [
                          DataCell(Text(s['roll']!)),
                          DataCell(Text(s['admission']!)),
                          DataCell(Text(s['reg']!)),
                          DataCell(Text(s['name']!)),
                          DataCell(Text(s['father']!)),
                          DataCell(Text(s['lang1']!)),
                          DataCell(Text(s['lang2']!)),
                          DataCell(Text(s['lang3']!))
                        ]))
                    .toList())));
  }

  Widget _buildPaginationBar() {
    int totalItems = _filteredStudents.length;
    int itemsPerPage = _itemsPerPage > 0 ? _itemsPerPage : 1;
    int startIndex =
        totalItems == 0 ? 0 : (_currentPage - 1) * itemsPerPage + 1;
    int endIndex = (_currentPage * itemsPerPage) > totalItems
        ? totalItems
        : (_currentPage * itemsPerPage);
    int totalPages = (totalItems / itemsPerPage).ceil();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: const Color(0xFFFFDAB9).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4)),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              const Text("Items per page: ", style: TextStyle(fontSize: 12)),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              const Color(0xFF1E2875).withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(4)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                          value: _itemsPerPage,
                          isDense: true,
                          items: [10, 25, 50, 100]
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text("$e",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF1E2875)))))
                              .toList(),
                          onChanged: (v) => setState(() {
                                _itemsPerPage = v!;
                                _currentPage = 1;
                              })))),
              const SizedBox(width: 24),
              Text("$startIndex - $endIndex of $totalItems",
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 16),
              _buildPageArrow(Icons.first_page, _currentPage > 1,
                  () => setState(() => _currentPage = 1)),
              _buildPageArrow(Icons.chevron_left, _currentPage > 1,
                  () => setState(() => _currentPage--)),
              _buildPageArrow(Icons.chevron_right, _currentPage < totalPages,
                  () => setState(() => _currentPage++)),
              _buildPageArrow(Icons.last_page, _currentPage < totalPages,
                  () => setState(() => _currentPage = totalPages)),
            ])));
  }

  Widget _buildPageArrow(IconData icon, bool enabled, VoidCallback onTap) {
    return IconButton(
        icon: Icon(icon,
            size: 20,
            color: enabled ? const Color(0xFF1E2875) : Colors.grey.shade400),
        onPressed: enabled ? onTap : null,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints());
  }
}
