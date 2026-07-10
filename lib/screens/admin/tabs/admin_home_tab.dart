import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/localization/language_manager.dart';
import '../../../widgets/calendar_popup.dart';

// Import sub-screens for quick action routing
import '../screens/admin_attendance_screen.dart';
import '../screens/admin_fees_screen.dart';
import '../screens/admin_communications_screen.dart';
import '../screens/reports/class_attendance_report_screen.dart';
import '../screens/admin_events_screen.dart';
import '../../ai_assistant/ai_assistant_screen.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';

class AdminHomeTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenProfile;
  final VoidCallback onAddStudent;
  final VoidCallback onAddTeacher;
  final ValueChanged<int>? onTabSelected;

  const AdminHomeTab({
    super.key,
    required this.onOpenDrawer,
    required this.onOpenProfile,
    required this.onAddStudent,
    required this.onAddTeacher,
    this.onTabSelected,
  });

  @override
  State<AdminHomeTab> createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  String _attendanceFilter = 'Today';
  String _chartFilter = 'This Year';
  
  late List<Map<String, dynamic>> _quickActions;

  @override
  void initState() {
    super.initState();
    _quickActions = [
      {'id': 'add_student', 'icon': Icons.person_add, 'label': "Add Student".tr.replaceAll(' ', '\n'), 'color': AppColors.primary},
      {'id': 'add_teacher', 'icon': Icons.person_add, 'label': "Add Teacher".tr.replaceAll(' ', '\n'), 'color': Color(0xFF10B981)},
      {'id': 'mark_attendance', 'icon': Icons.calendar_today, 'label': "Mark Attendance".tr.replaceAll(' ', '\n'), 'color': Color(0xFF8B5CF6)},
      {'id': 'collect_fees', 'icon': Icons.receipt_long, 'label': "Collect Fees".tr.replaceAll(' ', '\n'), 'color': Color(0xFFF59E0B)},
      {'id': 'notice_board', 'icon': Icons.campaign, 'label': "Notice Board".tr.replaceAll(' ', '\n'), 'color': AppColors.primary},
      {'id': 'more', 'icon': Icons.more_horiz, 'label': "More".tr, 'color': Color(0xFF6B7280)},
    ];
  }

  VoidCallback _getQuickActionCallback(String id) {
    switch (id) {
      case 'add_student': return widget.onAddStudent;
      case 'add_teacher': return widget.onAddTeacher;
      case 'mark_attendance': return () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAttendanceScreen()));
      case 'collect_fees': return () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminFeesScreen()));
      case 'notice_board': return () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminCommunicationsScreen()));
      case 'ai_assistant': return () => Navigator.push(context, MaterialPageRoute(builder: (_) => AiAssistantScreen()));
      case 'more': return widget.onOpenDrawer;
      default: return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: ValueListenableBuilder<String>(
          valueListenable: ProfileManager().adminName,
          builder: (context, name, _) {
            return AdminAppBar(
              title: "${"Welcome".tr} $name 👋",
              subtitle: "Here's what's happening today.".tr,
              onOpenDrawer: widget.onOpenDrawer,
              onProfileTap: widget.onOpenProfile,
              showSchoolSelector: false,
            );
          },
        ),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: ProfileManager().selectedSchool,
        builder: (context, school, _) {
          final metrics = AppDataStore.instance.getSchoolMetrics(school);
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                      child: _buildDateDisplay(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 12),

                          // 3. Stats row
                          _buildStatsRowForSchool(school),

                          SizedBox(height: 24),

                          // 4. Quick Actions
                          _buildQuickActions(),

                          SizedBox(height: 24),

                          // 5. Fee Collection & Attendance Overview
                          _buildFeeAndAttendanceRowForSchool(school, metrics),

                          SizedBox(height: 24),

                          // 6. Recent Notices & Upcoming Events
                          _buildNoticesAndEvents(),

                          SizedBox(height: 24),

                          // 7. Fee Collection Overview Line Chart
                          _buildFeeCollectionChartForSchool(school, metrics),

                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AiBotFab(),
    );
  }  // ══════════════════════════════════════════════════════════════════════════
  // 2. DATE DISPLAY
  // ══════════════════════════════════════════════════════════════════════════


  Widget _buildDateDisplay() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    final dateStr = "${now.day} ${months[now.month - 1]} ${now.year}";
    final dayStr = days[now.weekday - 1];
    final shortDay = dayStr.substring(0, 3);
    final combinedDate = "$shortDay, $dateStr";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // School Selector
        Expanded(
          child: Material(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: AppColors.primary.withValues(alpha: 0.2),
                highlightColor: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: PopupMenuButton<String>(
                onSelected: (String school) {
                ProfileManager().selectedSchool.value = school;
              },
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Ecstasy School 1',
                  child: Text('Ecstasy School 1'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                ),
                PopupMenuItem<String>(
                  value: 'Ecstasy School 2',
                  child: Text('Ecstasy School 2'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                ),
                PopupMenuItem<String>(
                  value: 'Ecstasy School 3',
                  child: Text('Ecstasy School 3'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                ),
              ],
              child: Container(
                height: 44,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ValueListenableBuilder<String>(
                  valueListenable: ProfileManager().selectedSchool,
                  builder: (context, selectedSchool, _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.school, color: AppColors.primary, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          selectedSchool,
                          style: const TextStyle(
                            color: Color(0xFF1E2875),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 14,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashColor: AppColors.primary.withValues(alpha: 0.2),
              highlightColor: AppColors.primary.withValues(alpha: 0.1),
              onTap: () {
                showCalendarPopup(context);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 44,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      combinedDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 3. STATS ROW
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStatsRowForSchool(String school) {
    final studentsCount = 1234 + AppDataStore.instance.students.where((s) => s['school'] == school).length;
    final teachersCount = 76 + AppDataStore.instance.teachers.where((t) => t['school'] == school).length;
    final branchesCount = AppDataStore.instance.branches.where((b) => b['school'] == school).length;
    final metrics = AppDataStore.instance.getSchoolMetrics(school);
    final presentPercent = metrics['presentPercent'];

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            iconBgColor: AppColors.primary,
            label: "Total Students".tr,
            value: studentsCount.toString(),
            change: "↑ 12 this month",
            changeColor: Colors.green,
            onTap: () => widget.onTabSelected?.call(1),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.school,
            iconBgColor: Color(0xFFF59E0B),
            label: "Total Teachers".tr,
            value: teachersCount.toString(),
            change: "↑ 3 this month",
            changeColor: Colors.green,
            onTap: () => widget.onTabSelected?.call(2),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.business,
            iconBgColor: Color(0xFFEF4444),
            label: "Branches",
            value: branchesCount.toString(),
            change: "↑ 1 this month",
            changeColor: Colors.green,
            onTap: () => widget.onTabSelected?.call(3),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            iconBgColor: Color(0xFF10B981),
            label: "Attendance\nToday".tr,
            value: "$presentPercent%",
            change: metrics['attendanceChange'] as String,
            changeColor: metrics['attendanceChangeColor'] as Color,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClassAttendanceReportScreen()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconBgColor,
    required String label,
    required String value,
    required String change,
    required Color changeColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBgColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconBgColor, size: 20),
                  ),
                  SizedBox(height: 6),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    change,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8,
                      color: changeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 4. QUICK ACTIONS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Quick Actions".tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            InkWell(
              onTap: _showCustomizeBottomSheet,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text("Customize".tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.settings, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _quickActions.map((action) {
                return _buildQuickActionItem(
                  action['icon'] as IconData,
                  action['label'] as String,
                  action['color'] as Color,
                  _getQuickActionCallback(action['id'] as String),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomizeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              height: 450,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Customize Quick Actions".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Drag to reorder the icons below.".tr, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ReorderableListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = _quickActions.removeAt(oldIndex);
                          _quickActions.insert(newIndex, item);
                        });
                        setModalState(() {});
                      },
                      children: _quickActions.map((action) {
                        return ListTile(
                          key: ValueKey(action['id']),
                          leading: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: (action['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 20),
                          ),
                          title: Text((action['label'] as String).replaceAll('\n', ' '), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875))),
                          trailing: Icon(Icons.drag_handle, color: Colors.grey),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 74,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E2875),
                  height: 1.2,
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 5. FEE COLLECTION & ATTENDANCE OVERVIEW
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFeeAndAttendanceRowForSchool(String school, Map<String, dynamic> metrics) {
    return Column(
      children: [
        // Fee Collection card
        _buildFeeCollectionCardForSchool(school, metrics),
        SizedBox(height: 16),
        // Attendance Overview card
        _buildAttendanceOverviewCardForSchool(school, metrics),
      ],
    );
  }

  Widget _buildFeeCollectionCardForSchool(String school, Map<String, dynamic> metrics) {
    final double tuitionPaid = metrics['tuitionPaidPercent'] as double;
    final double tuitionPending = metrics['tuitionPendingPercent'] as double;
    final double transportPaid = metrics['transportPaidPercent'] as double;
    final double transportPending = metrics['transportPendingPercent'] as double;
    
    String branchCode = "ECS001";
    if (school == "Ecstasy School 2") branchCode = "ECS002";
    if (school == "Ecstasy School 3") branchCode = "ECS003";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Branch Selector Dropdown Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade50,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Branch".tr,
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: school,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF1E2875)),
                  style: TextStyle(fontSize: 14, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
                  items: [
                    DropdownMenuItem(value: 'All Branches', child: Text("All Branches".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 1', child: Text("Ecstasy School 1 (ECS001)".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 2', child: Text("Ecstasy School 2 (ECS002)".tr)),
                    DropdownMenuItem(value: 'Ecstasy School 3', child: Text("Ecstasy School 3 (ECS003)".tr)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ProfileManager().selectedSchool.value = v;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // 2. Side-by-Side Pie Charts
        LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 360;
            if (isNarrow) {
              return Column(
                children: [
                  _buildTuitionFeeCard(school, branchCode, tuitionPaid, tuitionPending),
                  SizedBox(height: 16),
                  _buildTransportFeeCard(school, branchCode, transportPaid, transportPending),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildTuitionFeeCard(school, branchCode, tuitionPaid, tuitionPending)),
                SizedBox(width: 12),
                Expanded(child: _buildTransportFeeCard(school, branchCode, transportPaid, transportPending)),
              ],
            );
          },
        ),
        SizedBox(height: 16),

        // 3. Fee Due Students Section
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade50,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$school ($branchCode)", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Text("Fee Due Students".tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildLegendBlock(Color(0xFF1E3A8A), "Total Students"),
                  _buildLegendBlock(Color(0xFF0F5A35), "Term 1 Paid"),
                  _buildLegendBlock(Color(0xFFB3241F), "Term 1 Due"),
                  _buildLegendBlock(Color(0xFF10B981), "Term 2 Paid"),
                  _buildLegendBlock(Color(0xFFF59E0B), "Term 2 Due"),
                  _buildLegendBlock(Color(0xFFA7F3D0), "Term 3 Paid"),
                  _buildLegendBlock(Color(0xFFFCA5A5), "Term 3 Due"),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0: return Text("Total".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 1: return Text("Term 1".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 2: return Text("Term 2".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                              case 3: return Text("Term 3".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey));
                            }
                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                    barGroups: _buildFeeDueBarGroups(school),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),

        // 4. School Fee Structures Card
        _buildSchoolFeeStructuresCard(),
      ],
    );
  }

  Widget _buildTuitionFeeCard(String school, String branchCode, double paid, double pending) {
    return Container(
      height: 250,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$school ($branchCode)", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text("Tuition Fee Collection".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildDotLegend(Color(0xFF0F5A35), "Paid ${paid.toInt()}%"),
              _buildDotLegend(Color(0xFFB3241F), "Pending ${pending.toInt()}%"),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 36,
                    sections: [
                      PieChartSectionData(value: paid, color: Color(0xFF0F5A35), radius: 14, showTitle: false),
                      PieChartSectionData(value: pending, color: Color(0xFFB3241F), radius: 14, showTitle: false),
                    ],
                  ),
                ),
                Text("${paid.toInt()}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportFeeCard(String school, String branchCode, double paid, double pending) {
    return Container(
      height: 250,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade50, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$school ($branchCode)", style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text("Transport Fee Collection".tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildDotLegend(Color(0xFF0F5A35), "Paid ${paid.toInt()}%"),
              _buildDotLegend(Color(0xFFB3241F), "Pending ${pending.toInt()}%"),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 36,
                    sections: [
                      PieChartSectionData(value: paid, color: Color(0xFF0F5A35), radius: 14, showTitle: false),
                      PieChartSectionData(value: pending, color: Color(0xFFB3241F), radius: 14, showTitle: false),
                    ],
                  ),
                ),
                Text("${paid.toInt()}%", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotLegend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildLegendBlock(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF757897))),
      ],
    );
  }

  List<BarChartGroupData> _buildFeeDueBarGroups(String school) {
    double scale = 1.0;
    if (school == "Ecstasy School 2") scale = 0.6;
    if (school == "Ecstasy School 3") scale = 0.4;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: 100 * scale, color: Color(0xFF1E3A8A), width: 14, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: 85 * scale, color: Color(0xFF0F5A35), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 15 * scale, color: Color(0xFFB3241F), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(toY: 70 * scale, color: Color(0xFF10B981), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 30 * scale, color: Color(0xFFF59E0B), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(toY: 55 * scale, color: Color(0xFFA7F3D0), width: 10, borderRadius: BorderRadius.circular(4)),
          BarChartRodData(toY: 45 * scale, color: Color(0xFFFCA5A5), width: 10, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    ];
  }

  Widget _buildSchoolFeeStructuresCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
              Icon(Icons.table_chart_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text("School Fee Structures (Annual)".tr,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
            ],
          ),
          SizedBox(height: 12),
          Table(
            border: TableBorder.all(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
            columnWidths: const {
              0: FlexColumnWidth(2.6),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2.0),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.6),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("School".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Tuition".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Transport".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Exam".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("Total".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Color(0xFF1E2875)))),
                ],
              ),
              ...AppDataStore.instance.feeStructures.map((fee) {
                return TableRow(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("${fee['school']}\n(${fee['branchCode']})", style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF757897)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['tuition']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['transport']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['exam']}", style: TextStyle(fontSize: 9, color: Color(0xFF1E2875)))),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0), child: Text("₹ ${fee['total']}", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOverviewCardForSchool(String school, Map<String, dynamic> metrics) {
    final int presentPercent = metrics['presentPercent'] as int;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attendance Overview".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              _buildFilterChip(_attendanceFilter, ['Today', 'This Week', 'This Month'],
                  (v) => setState(() => _attendanceFilter = v)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              // Left side - donut chart
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: presentPercent.toDouble(),
                            color: Color(0xFF10B981),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: (100 - presentPercent) * 0.78,
                            color: Color(0xFFEF4444),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: (100 - presentPercent) * 0.22,
                            color: Color(0xFF9CA3AF),
                            radius: 18,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "$presentPercent%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875),
                          ),
                        ),
                        Text("Present".tr,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              // Right side - legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      color: Color(0xFF10B981),
                      label: "Present",
                      value: metrics['presentCount'] as String,
                    ),
                    SizedBox(height: 10),
                    _buildLegendItem(
                      color: Color(0xFFEF4444),
                      label: "Absent",
                      value: metrics['absentCount'] as String,
                    ),
                    SizedBox(height: 10),
                    _buildLegendItem(
                      color: Color(0xFF9CA3AF),
                      label: "Leave",
                      value: metrics['leaveCount'] as String,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassAttendanceReportScreen()));
            },
            child: Row(children: [
                Text("View attendance report".tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 6. NOTICES & EVENTS
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildNoticesAndEvents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Recent Notices
        _buildRecentNotices(),
        SizedBox(height: 16),
        // Upcoming Events
        _buildUpcomingEvents(),
      ],
    );
  }

  Widget _buildRecentNotices() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Recent Notices".tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminCommunicationsScreen()));
                },
                child: Text("View All".tr,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildNoticeItem(
            icon: Icons.wb_sunny,
            iconColor: Color(0xFFF59E0B),
            title: "Summer Holiday Announcement",
            subtitle: "Holiday will be from 25 May to 10 June 2026.",
            date: "20 May 2026",
          ),
          SizedBox(height: 10),
          _buildNoticeItem(
            icon: Icons.people,
            iconColor: Color(0xFF3B82F6),
            title: "Parent Meeting",
            subtitle: "Parent meeting on 26 May at 10 AM.",
            date: "19 May 2026",
          ),
          SizedBox(height: 10),
          _buildNoticeItem(
            icon: Icons.assignment,
            iconColor: Color(0xFF10B981),
            title: "Exam Schedule",
            subtitle: "Mid term exam schedule released.",
            date: "18 May 2026",
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String date,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text("Upcoming Events".tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminEventsScreen()));
                },
                child: Text("View All".tr,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildEventItem(
            icon: Icons.groups,
            iconColor: Color(0xFF3B82F6),
            title: "Parent Meeting",
            datetime: "26 May 2026, 10:00 AM",
          ),
          SizedBox(height: 10),
          _buildEventItem(
            icon: Icons.science,
            iconColor: Color(0xFF8B5CF6),
            title: "Science Exhibition",
            datetime: "30 May 2026, 09:00 AM",
          ),
          SizedBox(height: 10),
          _buildEventItem(
            icon: Icons.sports_soccer,
            iconColor: Color(0xFFF59E0B),
            title: "Annual Sports Day",
            datetime: "17 June 2026, 08:00 AM",
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String datetime,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                datetime,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 7. FEE COLLECTION OVERVIEW LINE CHART
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFeeCollectionChartForSchool(String school, Map<String, dynamic> metrics) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Fee Collection Overview".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              _buildFilterChip(_chartFilter, ['This Year', 'Last Year'],
                  (v) => setState(() => _chartFilter = v)),
            ],
          ),
          SizedBox(height: 8),
          // Legend
          Row(
            children: [
              Text("₹ (Lakh)".tr, style: TextStyle(fontSize: 10, color: Colors.grey)),
              SizedBox(width: 16),
              _buildChartLegendDot(Color(0xFF10B981), "Collected"),
              SizedBox(width: 12),
              _buildChartLegendDot(Color(0xFFEF4444), "Pending"),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.shade200,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 10,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 9, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                        ];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 40,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final isCollected = spot.barIndex == 0;
                        return LineTooltipItem(
                          '${isCollected ? "Collected" : "Pending"}: ₹ ${spot.y.toStringAsFixed(1)} Lakh',
                          TextStyle(
                            color: isCollected
                                ? Color(0xFF10B981)
                                : Color(0xFFEF4444),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Collected line (green)
                  LineChartBarData(
                    spots: metrics['chartCollected'] as List<FlSpot>,
                    isCurved: true,
                    color: Color(0xFF10B981),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Color(0xFF10B981),
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF10B981).withValues(alpha: 0.08),
                    ),
                  ),
                  // Pending line (red)
                  LineChartBarData(
                    spots: metrics['chartPending'] as List<FlSpot>,
                    isCurved: true,
                    color: Color(0xFFEF4444),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Color(0xFFEF4444),
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFEF4444).withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER: FILTER CHIP
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFilterChip(
      String current, List<String> options, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isDense: true,
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF1E2875),
            fontWeight: FontWeight.w600,
          ),
          icon: Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF1E2875)),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}
