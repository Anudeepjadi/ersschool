import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../widgets/app_footer.dart';

class AdminClassTeachersScreen extends StatefulWidget {
  const AdminClassTeachersScreen({super.key});

  @override
  State<AdminClassTeachersScreen> createState() => _AdminClassTeachersScreenState();
}

class _AdminClassTeachersScreenState extends State<AdminClassTeachersScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'Grade 1';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allMappings = [
    {'class': 'Grade 1', 'section': 'A', 'teacher': ''},
    {'class': 'Grade 1', 'section': 'B', 'teacher': 'Ms. Rani'},
    {'class': 'Grade 2', 'section': 'A', 'teacher': 'Mrs. Gayatri Devi'},
    {'class': 'Grade 2', 'section': 'B', 'teacher': 'Mr. Giri Prasad'},
    {'class': 'Grade 2', 'section': 'C', 'teacher': 'Mr. Giri Prasad'},
    {'class': 'Grade 3', 'section': 'A', 'teacher': 'Mrs. Gayatri Devi'},
    {'class': 'Grade 3', 'section': 'B', 'teacher': 'Mrs. Gayatri Devi'},
    {'class': 'Grade 3', 'section': 'C', 'teacher': 'Mr. Giri Prasad'},
    {'class': 'Grade 4', 'section': 'A', 'teacher': 'Ms. Rani'},
    {'class': 'Grade 4', 'section': 'B', 'teacher': 'Mr. Rajesh Kumar'},
    {'class': 'Grade 5', 'section': 'A', 'teacher': 'Mrs. Sunita Devi'},
  ];
  
  List<Map<String, String>> _filteredMappings = [];
  int _itemsPerPage = 25;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _filteredMappings = List.from(_allMappings);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMappings = List.from(_allMappings);
      } else {
        _filteredMappings = _allMappings.where((m) {
          final className = m['class']?.toLowerCase() ?? '';
          final section = m['section']?.toLowerCase() ?? '';
          final teacher = m['teacher']?.toLowerCase() ?? '';
          return className.contains(query) || section.contains(query) || teacher.contains(query);
        }).toList();
      }
      _currentPage = 1;
    });
  }

  void _showEditDialog(int index) {
    final mapping = _filteredMappings[index];
    String? selectedTeacher = mapping['teacher']!.isEmpty ? null : mapping['teacher'];
    final List<String> teachers = ['Ms. Rani', 'Mrs. Gayatri Devi', 'Mr. Giri Prasad', 'Mr. Rajesh Kumar', 'Mrs. Sunita Devi'];

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
            decoration: const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Academic Year", style: TextStyle(color: Colors.white, fontSize: 18)),
                GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white, size: 20)),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Teacher", style: TextStyle(fontSize: 12, color: Colors.black87)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedTeacher,
                    hint: const Text("Select Teacher", style: TextStyle(fontSize: 13)),
                    items: teachers.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) => setModalState(() => selectedTeacher = val),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white), child: const Text("Cancel")),
            ElevatedButton(onPressed: () { setState(() { mapping['teacher'] = selectedTeacher ?? ''; }); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white), child: const Text("Save")),
          ],
        ),
      ),
    );
    });
  }

  void _showDeleteDialog(int index) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Academic Year", style: TextStyle(color: Colors.white, fontSize: 18)),
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, color: Colors.white, size: 20)),
            ],
          ),
        ),
        content: const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Do you want to delete the record?", style: TextStyle(fontSize: 14))),
        actions: [
           ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E2832), foregroundColor: Colors.white), child: const Text("No")),
          ElevatedButton(onPressed: () { setState(() { final item = _filteredMappings[index]; _allMappings.remove(item); _onSearchChanged(); }); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white), child: const Text("Yes")),
        ],
      ),
    );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(title: "Class Teachers", subtitle: "Assign teachers to classes"),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text("Class Teachers", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))),
                  const SizedBox(height: 24),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildMappingTable(),
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
            Row(
              children: [
                Expanded(child: _buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!))),
                const SizedBox(width: 8),
                Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Search")),
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildDropdown(label: "Branch", value: _selectedBranch, items: ['Ecstasy School 1 (ECS001)', 'Ecstasy School 2 (ECS002)', 'Ecstasy School 3 (ECS003)'], onChanged: (v) => setState(() => _selectedBranch = v!))),
          const SizedBox(width: 12),
          Expanded(child: _buildDropdown(label: "Class", value: _selectedClass, items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'], onChanged: (v) => setState(() => _selectedClass = v!))),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))), child: const Text("Search")),
        ],
      );
    });
  }

  Widget _buildDropdown({required String label, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
          border: InputBorder.none,
          icon: const Icon(Icons.search, size: 18, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(icon: const Icon(Icons.clear, size: 18, color: Colors.grey), onPressed: () => _searchController.clear())
              : null,
        ),
      ),
    );
  }

  Widget _buildMappingTable() {
    if (_filteredMappings.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("No records found matching your search", style: TextStyle(color: Colors.grey))));
    }
    final startIndex = ((_currentPage - 1) * _itemsPerPage).clamp(0, _filteredMappings.length);
    final paginatedMappings = _filteredMappings.skip(startIndex).take(_itemsPerPage).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFF1E2875)),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          dataRowMinHeight: 40, dataRowMaxHeight: 40, columnSpacing: 20,
          columns: const [DataColumn(label: Text("Class")), DataColumn(label: Text("Section")), DataColumn(label: Text("Teacher")), DataColumn(label: Text(""))],
          rows: paginatedMappings.asMap().entries.map((entry) {
            final idx = entry.key; final m = entry.value;
            return DataRow(cells: [
              DataCell(Text(m['class']!, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
              DataCell(Text(m['section']!)),
              DataCell(Text(m['teacher']!)),
              DataCell(Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () => _showEditDialog(startIndex + idx), icon: const Icon(Icons.edit, color: Colors.blue, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  const SizedBox(width: 8),
                  if (m['teacher']!.isNotEmpty)
                    IconButton(onPressed: () => _showDeleteDialog(startIndex + idx), icon: const Icon(Icons.delete, color: Colors.red, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaginationBar() {
    int totalItems = _filteredMappings.length;
    int itemsPerPage = _itemsPerPage > 0 ? _itemsPerPage : 1;
    int startIndex = totalItems == 0 ? 0 : (_currentPage - 1) * itemsPerPage + 1;
    int endIndex = (_currentPage * itemsPerPage) > totalItems ? totalItems : (_currentPage * itemsPerPage);
    int totalPages = (totalItems / itemsPerPage).ceil();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFFFDAB9).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(4)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Items per page: ", style: TextStyle(fontSize: 12)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)), child: DropdownButtonHideUnderline(child: DropdownButton<int>(value: _itemsPerPage, isDense: true, items: [10, 25, 50, 100].map((e) => DropdownMenuItem(value: e, child: Text("$e", style: const TextStyle(fontSize: 12)))).toList(), onChanged: (v) => setState(() { _itemsPerPage = v!; _currentPage = 1; })))),
            const SizedBox(width: 24), Text("$startIndex - $endIndex of $totalItems", style: const TextStyle(fontSize: 12)), const SizedBox(width: 16),
            _buildPageArrow(Icons.first_page, _currentPage > 1, () => setState(() => _currentPage = 1)),
            _buildPageArrow(Icons.chevron_left, _currentPage > 1, () => setState(() => _currentPage--)),
            _buildPageArrow(Icons.chevron_right, _currentPage < totalPages, () => setState(() => _currentPage++)),
            _buildPageArrow(Icons.last_page, _currentPage < totalPages, () => setState(() => _currentPage = totalPages)),
          ],
        ),
      ),
    );
  }

  Widget _buildPageArrow(IconData icon, bool enabled, VoidCallback onTap) {
    return IconButton(icon: Icon(icon, size: 20, color: enabled ? Colors.black87 : Colors.grey.shade400), onPressed: enabled ? onTap : null, padding: EdgeInsets.zero, constraints: const BoxConstraints());
  }
}
