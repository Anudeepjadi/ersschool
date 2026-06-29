import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import '../student_management/admin_student_details_screen.dart';
import '../student_management/admin_student_fee_details_screen.dart';
import '../student_management/admin_student_attendance_report_screen.dart';
import '../student_management/admin_register_student_screen.dart';
class AdminTransportStudentsClassScreen extends StatefulWidget {
  const AdminTransportStudentsClassScreen({super.key});

  @override
  State<AdminTransportStudentsClassScreen> createState() => _AdminTransportStudentsClassScreenState();
}

class _AdminTransportStudentsClassScreenState extends State<AdminTransportStudentsClassScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'All';
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  
  final List<Map<String, dynamic>> _dummyData = [
    {
      'name': 'Vihaan Dindi',
      'father': 'father D.Siva Krishna',
      'gender': 'Male',
      'class': 'Grade 2 - A',
      'mobile': '1502375080, 1573754521',
      'address': 'New Road, Hyderabad',
      'transport': 'Two Way',
      'pickup': 'Route# 1 - City Road 1\nStart Time 8:00 AM',
      'drop': 'Route# 2 - City Road 2\nStart Time 8:00 AM',
    },
    {
      'name': 'Jashwanth Krishna',
      'father': 'father J.Raja',
      'gender': 'Male',
      'class': 'Grade 2 - A',
      'mobile': '9885147049, 9885147049',
      'address': 'New Road, Hyderabad',
      'transport': 'Two Way',
      'pickup': 'Route# 2 - City Road 2\nStart Time 8:00 AM',
      'drop': 'Route# 2 - City Road 2\nStart Time 8:00 AM',
    },
    {
      'name': 'Raju rao',
      'father': '',
      'gender': 'Male',
      'class': 'Grade 4 - C',
      'mobile': '9889889881',
      'address': '',
      'transport': 'Two Way',
      'pickup': 'Route# 1 - City Road 1\nStart Time 8:00 AM',
      'drop': 'Route# 2 - City Road 2\nStart Time 8:00 AM',
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
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      backgroundColor: Colors.white,
      appBar: AdminAppBar(title: "Students By Class", subtitle: "Manage your transport students by class"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          
          Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: fieldWidth,
                child: _buildLabeledDropdown("Branch", _selectedBranch, ["All Branches", "Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], (val) {
                  setState(() => _selectedBranch = val!);
                }),
              ),
              SizedBox(
                width: fieldWidth,
                child: _buildLabeledDropdown("Class", _selectedClass, ["All", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "batch1", "Grade 5", "Grade 6", "grade 7"], (val) {
                  setState(() => _selectedClass = val!);
                }),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text("Search".tr, style: const TextStyle(color: Colors.white)),
              ),
            ],
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
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                child: Text("Print".tr, style: const TextStyle(color: Colors.white)),
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
            child: Scrollbar(
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
                    columnSpacing: 20,
                    columns: [
                      DataColumn(label: Text("Full Name".tr)),
                      DataColumn(label: Text("Father Name".tr)),
                      DataColumn(label: Text("Gender".tr)),
                      DataColumn(label: Text("Class".tr)),
                      DataColumn(label: Text("Mobile".tr)),
                      DataColumn(label: Text("Address".tr)),
                      DataColumn(label: Text("Transport\nType".tr)),
                      DataColumn(label: Text("Pickup".tr)),
                      DataColumn(label: Text("Drop".tr)),
                      const DataColumn(label: Text("")), // Actions
                    ],
                    rows: _filteredData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data['name'])),
                          DataCell(Text(data['father'])),
                          DataCell(Text(data['gender'])),
                          DataCell(Text(data['class'])),
                          DataCell(Text(data['mobile'])),
                          DataCell(Text(data['address'])),
                          DataCell(Text(data['transport'])),
                          DataCell(Text(data['pickup'])),
                          DataCell(Text(data['drop'])),
                          DataCell(_buildActionButtons(data)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
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

  Widget _buildActionButtons(Map<String, dynamic> student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconButton(Icons.visibility, AppColors.primaryDark, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentDetailsScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.currency_rupee, AppColors.success, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentFeeDetailsScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.pan_tool, AppColors.primary, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminStudentAttendanceReportScreen(student: student)));
        }),
        const SizedBox(width: 8),
        _iconButton(Icons.edit, AppColors.primaryDark, onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminRegisterStudentScreen(isEditMode: true, student: student)));
        }),
      ],
    );
  }

  Widget _iconButton(IconData icon, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredData {
    if (_searchQuery.isEmpty) return _dummyData;
    final query = _searchQuery.toLowerCase();
    return _dummyData.where((student) {
      return student.values.any((val) => val.toString().toLowerCase().contains(query));
    }).toList();
  }
}
