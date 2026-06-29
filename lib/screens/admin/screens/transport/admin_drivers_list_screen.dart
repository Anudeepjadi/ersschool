import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import 'admin_add_driver_screen.dart';

class AdminDriversListScreen extends StatefulWidget {
  const AdminDriversListScreen({super.key});

  @override
  State<AdminDriversListScreen> createState() => _AdminDriversListScreenState();
}

class _AdminDriversListScreenState extends State<AdminDriversListScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  int _itemsPerPage = 25;

  List<Map<String, dynamic>> _dummyData = [
    {
      'branch': 'Ecstasy School 1 (ECS001)',
      'role': 'Driver',
      'code': '',
      'name': 'Srinu',
      'mobile': '1398405756',
      'email': '',
    },
    {
      'branch': 'Ecstasy School 1 (ECS001)',
      'role': 'Driver',
      'code': '',
      'name': 'Kumar',
      'mobile': '1652949043',
      'email': '',
    },
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fieldWidth = screenWidth > 600 ? 250 : screenWidth - 32;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(title: "Drivers", subtitle: "Manage your drivers details"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: fieldWidth,
              child: _buildLabeledDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) {
                setState(() => _selectedBranch = val!);
              }),
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: fieldWidth,
                height: 40,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search".tr,
                    suffixIcon: const Icon(Icons.search, color: Colors.green),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                      _currentPage = 1;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminAddDriverScreen()),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      result["branch"] = _selectedBranch;
                      _dummyData = List.from(_dummyData)..add(result);
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text("Add New".tr, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // DataTable
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DataTable(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        headingRowColor: WidgetStateProperty.all(AppColors.primaryDark),
                        dataRowColor: WidgetStateProperty.resolveWith<Color>((states) {
                          return Colors.white;
                        }),
                        headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        dataTextStyle: const TextStyle(color: Colors.black87, fontSize: 12),
                        columnSpacing: 30,
                        columns: [
                          DataColumn(label: Text("Branch".tr)),
                          DataColumn(label: Text("Employee Role".tr)),
                          DataColumn(label: Text("Employee Code".tr)),
                          DataColumn(label: Text("Full Name".tr)),
                          DataColumn(label: Text("Mobile".tr)),
                          DataColumn(label: Text("EmailId".tr)),
                          DataColumn(label: Text("")),
                        ],
                        rows: _getPaginatedData().map((data) {
                          return DataRow(
                            cells: [
                              DataCell(Text(data['branch'])),
                              DataCell(Text(data['role'])),
                              DataCell(Text(data['code'])),
                              DataCell(Text(data['name'])),
                              DataCell(Text(data['mobile'])),
                              DataCell(Text(data['email'])),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => AdminAddDriverScreen(existingData: data)),
                                        );
                                        if (result != null && result is Map<String, dynamic>) {
                                          setState(() {
                                            result["branch"] = _selectedBranch;
                                            _dummyData = List.from(_dummyData);
                                            final index = _dummyData.indexOf(data);
                                            if (index != -1) _dummyData[index] = result;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF1E2875),
                                            shape: BoxShape.circle),
                                        child: const Icon(Icons.remove_red_eye,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => AdminAddDriverScreen(existingData: data)),
                                        );
                                        if (result != null && result is Map<String, dynamic>) {
                                          setState(() {
                                            result["branch"] = _selectedBranch;
                                            _dummyData = List.from(_dummyData);
                                            final index = _dummyData.indexOf(data);
                                            if (index != -1) _dummyData[index] = result;
                                          });
                                        }
                                      },
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
                                      onTap: () {
                                        setState(() {
                                          _dummyData = List.from(_dummyData)..remove(data);
                                        });
                                      },
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
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                
                // Pagination
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8D4),
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Items per page:".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _itemsPerPage,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 2, child: Text("2", style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 25, child: Text("25", style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 50, child: Text("50", style: TextStyle(fontSize: 12))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() { _itemsPerPage = val; _currentPage = 1; });
                          },
                        ),
                        const SizedBox(width: 24),
                        Text("$_currentPage - ${(_filteredData.length / _itemsPerPage).ceil() == 0 ? 1 : (_filteredData.length / _itemsPerPage).ceil()} of ${_filteredData.length}".tr, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: _currentPage > 1 ? () => setState(() => _currentPage = 1) : null,
                          child: Icon(Icons.first_page, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                          child: Icon(Icons.chevron_left, size: 20, color: _currentPage > 1 ? Colors.black87 : Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage++) : null,
                          child: Icon(Icons.chevron_right, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? () => setState(() => _currentPage = (_filteredData.length / _itemsPerPage).ceil()) : null,
                          child: Icon(Icons.last_page, size: 20, color: _currentPage < (_filteredData.length / _itemsPerPage).ceil() ? Colors.black87 : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildLabeledDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item.tr, style: const TextStyle(fontSize: 13)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return _dummyData;
    final query = _searchQuery.toLowerCase();
    return _dummyData.where((item) {
      return item.values.any((val) => val.toString().toLowerCase().contains(query));
    }).toList();
  }

  List<Map<String, dynamic>> _getPaginatedData() {
    final filtered = _filteredData;
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    if (start >= filtered.length) return [];
    if (end > filtered.length) end = filtered.length;
    return filtered.sublist(start, end);
  }


}
