import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

class AdminAttendanceScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminAttendanceScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  String _selectedClass = 'Class 8 - A';
  String _selectedDate = '20 May 2024';
  String _selectedView = 'Daily';
  String _activeFilter = 'All';

  final List<Map<String, dynamic>> _students = [
    {
      'name': 'Rahul Kumar',
      'email': 'rahul.kumar@email.com',
      'phone': '+91 98765 43210',
      'roll': '101',
      'status': 'Present',
      'remarks': '—',
    },
    {
      'name': 'Ananya Sharma',
      'email': 'ananya.sharma@email.com',
      'phone': '+91 98765 43211',
      'roll': '102',
      'status': 'Present',
      'remarks': '—',
    },
    {
      'name': 'Aarav Singh',
      'email': 'aarav.singh@email.com',
      'phone': '+91 98765 43212',
      'roll': '103',
      'status': 'Absent',
      'remarks': 'Medical Leave',
    },
    {
      'name': 'Diya Patel',
      'email': 'diya.patel@email.com',
      'phone': '+91 98765 43213',
      'roll': '104',
      'status': 'Present',
      'remarks': '—',
    },
    {
      'name': 'Kabir Verma',
      'email': 'kabir.verma@email.com',
      'phone': '+91 98765 43214',
      'roll': '105',
      'status': 'Late',
      'remarks': 'Reached at 09:15 AM',
    },
    {
      'name': 'Meera Gupta',
      'email': 'meera.gupta@email.com',
      'phone': '+91 98765 43215',
      'roll': '106',
      'status': 'Present',
      'remarks': '—',
    },
    {
      'name': 'Vivaan Joshi',
      'email': 'vivaan.joshi@email.com',
      'phone': '+91 98765 43216',
      'roll': '107',
      'status': 'Present',
      'remarks': '—',
    },
    {
      'name': 'Ishita Reddy',
      'email': 'ishita.reddy@email.com',
      'phone': '+91 98765 43217',
      'roll': '108',
      'status': 'Present',
      'remarks': '—',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStudents = _students.where((student) {
      if (_activeFilter == 'All') return true;
      return student['status'] == _activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Attendance",
        subtitle: "Track and manage student attendance",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdowns selectors
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: "Class",
                    value: _selectedClass,
                    items: ['Class 8 - A', 'Class 8 - B', 'Class 9 - A'],
                    onChanged: (v) => setState(() => _selectedClass = v!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    label: "Date",
                    value: _selectedDate,
                    items: ['20 May 2024', '21 May 2024'],
                    onChanged: (v) => setState(() => _selectedDate = v!),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown(
                    label: "View By",
                    value: _selectedView,
                    items: ['Daily', 'Weekly', 'Monthly'],
                    onChanged: (v) => setState(() => _selectedView = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card row metrics
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Students", "48", null, Colors.blue),
                  _buildStatCard("Present", "44", "91.67%", const Color(0xFF10B981)),
                  _buildStatCard("Absent", "3", "6.25%", const Color(0xFFEF4444)),
                  _buildStatCard("Late", "1", "2.08%", const Color(0xFFF59E0B)),
                  _buildStatCard("On Leave", "0", "0%", const Color(0xFF9CA3AF)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Charts
            _buildChartsSection(),
            const SizedBox(height: 16),

            // Search bar & buttons
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search students by name...",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF757897)),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', _students.length),
                  _buildFilterChip('Present', 44),
                  _buildFilterChip('Absent', 3),
                  _buildFilterChip('Late', 1),
                  _buildFilterChip('On Leave', 0),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Student list table
            _buildStudentListTable(filteredStudents),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String? percentage, Color color) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          if (percentage != null) ...[
            const SizedBox(height: 4),
            Text(percentage, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Attendance Analysis",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(value: 91.67, color: const Color(0xFF10B981), radius: 12, showTitle: false),
                            PieChartSectionData(value: 6.25, color: const Color(0xFFEF4444), radius: 12, showTitle: false),
                            PieChartSectionData(value: 2.08, color: const Color(0xFFF59E0B), radius: 12, showTitle: false),
                          ],
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("91.67%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Present", style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bar Chart
              Expanded(
                flex: 6,
                child: SizedBox(
                  height: 120,
                  child: BarChart(
                    BarChartData(
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                              if (value.toInt() >= 0 && value.toInt() < days.length) {
                                return Text(days[value.toInt()], style: const TextStyle(fontSize: 9, color: Colors.grey));
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        _buildBarGroup(0, 92),
                        _buildBarGroup(1, 88),
                        _buildBarGroup(2, 96),
                        _buildBarGroup(3, 90),
                        _buildBarGroup(4, 93),
                        _buildBarGroup(5, 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF10B981),
          width: 8,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _activeFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF757897),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF1E2875),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListTable(List<Map<String, dynamic>> students) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Student List (${students.length})",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                ),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final student = students[index];
              Color statusColor;
              switch (student['status']) {
                case 'Present':
                  statusColor = const Color(0xFF10B981);
                  break;
                case 'Absent':
                  statusColor = const Color(0xFFEF4444);
                  break;
                case 'Late':
                  statusColor = const Color(0xFFF59E0B);
                  break;
                default:
                  statusColor = Colors.grey;
              }

              return Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: statusColor.withValues(alpha: 0.1),
                      child: Text(
                        student['name'][0],
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                          Text("Roll No. ${student['roll']}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        student['status'],
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
