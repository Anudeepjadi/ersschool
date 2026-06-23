import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';

class AdminAttendanceScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminAttendanceScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  String _selectedClass = 'Class 10';
  String _selectedDate = '20 May 2026';
  String _selectedView = 'Daily';
  String _activeFilter = 'All';

  List<Map<String, dynamic>> get _students => AppDataStore.instance.students
      .where((s) => s['school'] == ProfileManager().selectedSchool.value)
      .toList();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ProfileManager().selectedSchool,
      builder: (context, school, _) {
        final schoolClasses = _students.map((s) => s['class'] as String).toSet().toList();
        schoolClasses.sort();
        if (schoolClasses.isEmpty) {
          schoolClasses.addAll(['Class 10', 'Class 9', 'Class 8']);
        }
        if (!schoolClasses.contains(_selectedClass)) {
          _selectedClass = schoolClasses.first;
        }

        final classStudents = _students.where((s) => s['class'] == _selectedClass).map((s) {
          final dynamicStatus = AppDataStore.instance.getStudentAttendance(school, _selectedDate, s['admission'] as String, s['status'] as String);
          return {
            ...s,
            'status': dynamicStatus,
          };
        }).toList();

        final filteredStudents = classStudents.where((student) {
          if (_activeFilter == 'All') return true;
          final isPresent = student['status'] == 'Active' || student['status'] == 'Present';
          final isAbsent = student['status'] == 'Inactive' || student['status'] == 'Absent';
          if (_activeFilter == 'Present') return isPresent;
          if (_activeFilter == 'Absent') return isAbsent;
          return student['status'] == _activeFilter;
        }).toList();

        final totalCount = classStudents.length;
        final presentCount = classStudents.where((s) => s['status'] == 'Active' || s['status'] == 'Present').length;
        final absentCount = classStudents.where((s) => s['status'] == 'Inactive' || s['status'] == 'Absent').length;
        final lateCount = classStudents.where((s) => s['status'] == 'Late').length;
        final leaveCount = classStudents.where((s) => s['status'] == 'Leave' || s['status'] == 'On Leave').length;

        final presentPercentStr = totalCount > 0 ? "${((presentCount / totalCount) * 100).toStringAsFixed(1)}%" : "0%";
        final absentPercentStr = totalCount > 0 ? "${((absentCount / totalCount) * 100).toStringAsFixed(1)}%" : "0%";
        final latePercentStr = totalCount > 0 ? "${((lateCount / totalCount) * 100).toStringAsFixed(1)}%" : "0%";
        final leavePercentStr = totalCount > 0 ? "${((leaveCount / totalCount) * 100).toStringAsFixed(1)}%" : "0%";

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FF),
          appBar: AdminAppBar(
            title: "Attendance",
            subtitle: "Track and manage student attendance",
            onOpenDrawer: widget.onOpenDrawer,
          ),
          bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdowns selectors
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "Class",
                          value: _selectedClass,
                          items: schoolClasses,
                          onChanged: (v) => setState(() => _selectedClass = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "Date",
                          value: _selectedDate,
                          items: ['20 May 2026', '21 May 2026', '22 May 2026', '23 May 2026', '24 May 2026'],
                          onChanged: (v) => setState(() => _selectedDate = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 140,
                        child: _buildDropdown(
                          label: "View By",
                          value: _selectedView,
                          items: ['Daily', 'Weekly', 'Monthly'],
                          onChanged: (v) => setState(() => _selectedView = v!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Card row metrics
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard("Total Students", "$totalCount", null, Colors.blue),
                      _buildStatCard("Present", "$presentCount", presentPercentStr, const Color(0xFF10B981)),
                      _buildStatCard("Absent", "$absentCount", absentPercentStr, const Color(0xFFEF4444)),
                      _buildStatCard("Late", "$lateCount", latePercentStr, const Color(0xFFF59E0B)),
                      _buildStatCard("On Leave", "$leaveCount", leavePercentStr, const Color(0xFF9CA3AF)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Charts
                _buildChartsSection(totalCount, presentCount, absentCount, lateCount),
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
                      _buildFilterChip('All', totalCount),
                      _buildFilterChip('Present', presentCount),
                      _buildFilterChip('Absent', absentCount),
                      _buildFilterChip('Late', lateCount),
                      _buildFilterChip('On Leave', leaveCount),
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
      },
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
      height: 100,
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
          const SizedBox(height: 4),
          if (percentage != null)
            Text(percentage, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold))
          else
            const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildChartsSection(int total, int present, int absent, int late) {
    final double presentVal = total > 0 ? (present / total) * 100 : 0.0;
    final double absentVal = total > 0 ? (absent / total) * 100 : 0.0;
    final double lateVal = total > 0 ? (late / total) * 100 : 0.0;

    final school = ProfileManager().selectedSchool.value;
    final metrics = AppDataStore.instance.getSchoolMetrics(school);
    final double basePercent = (metrics['presentPercent'] as num).toDouble();

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
                            PieChartSectionData(
                              value: presentVal > 0 ? presentVal : 0.1,
                              color: const Color(0xFF10B981),
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: absentVal > 0 ? absentVal : 0.1,
                              color: const Color(0xFFEF4444),
                              radius: 12,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: lateVal > 0 ? lateVal : 0.1,
                              color: const Color(0xFFF59E0B),
                              radius: 12,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${presentVal.toStringAsFixed(1)}%",
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                          ),
                          const Text("Present", style: TextStyle(fontSize: 8, color: Colors.grey)),
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
                        _buildBarGroup(0, basePercent),
                        _buildBarGroup(1, basePercent - 4 > 0 ? basePercent - 4 : 0),
                        _buildBarGroup(2, basePercent + 4 < 100 ? basePercent + 4 : 100),
                        _buildBarGroup(3, basePercent - 2 > 0 ? basePercent - 2 : 0),
                        _buildBarGroup(4, basePercent + 1 < 100 ? basePercent + 1 : 100),
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
              final isPresent = student['status'] == 'Active' || student['status'] == 'Present';
              final isAbsent = student['status'] == 'Inactive' || student['status'] == 'Absent';
              final isLate = student['status'] == 'Late';
              
              Color statusColor = Colors.grey;
              String displayStatus = 'Present';

              if (isPresent) {
                statusColor = const Color(0xFF10B981);
                displayStatus = 'Present';
              } else if (isAbsent) {
                statusColor = const Color(0xFFEF4444);
                displayStatus = 'Absent';
              } else if (isLate) {
                statusColor = const Color(0xFFF59E0B);
                displayStatus = 'Late';
              }

              final avatarLetter = student['name'] != null && student['name'].toString().isNotEmpty
                  ? student['name'].toString()[0]
                  : 'S';
              final cleanRoll = student['roll'].toString().replaceAll("Roll No: ", "").replaceAll("Roll No. ", "");

              return Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: statusColor.withValues(alpha: 0.1),
                      child: Text(
                        avatarLetter,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['name'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                          Text("Roll No. $cleanRoll", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final newStatus = isPresent ? 'Absent' : 'Present';
                        AppDataStore.instance.setStudentAttendance(ProfileManager().selectedSchool.value, _selectedDate, student['admission'] as String, newStatus);
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              displayStatus,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.swap_horiz, size: 10, color: statusColor),
                          ],
                        ),
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
