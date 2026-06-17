import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

// Import sub-screens for quick action routing
import '../screens/admin_attendance_screen.dart';
import '../screens/admin_fees_screen.dart';
import '../screens/admin_communications_screen.dart';
import '../screens/admin_chat_support_screen.dart';

class AdminHomeTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;
  final VoidCallback onOpenProfile;
  final VoidCallback onAddStudent;
  final VoidCallback onAddTeacher;

  const AdminHomeTab({
    super.key,
    required this.onOpenDrawer,
    required this.onOpenProfile,
    required this.onAddStudent,
    required this.onAddTeacher,
  });

  @override
  State<AdminHomeTab> createState() => _AdminHomeTabState();
}

class _AdminHomeTabState extends State<AdminHomeTab> {
  String _selectedSchool = 'Ecstasy School 1';
  String _feeFilter = 'This Month';
  String _attendanceFilter = 'Today';
  String _chartFilter = 'This Year';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _buildChatFab(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Blue curved header
            _buildHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // 2. Date display
                  _buildDateDisplay(),

                  const SizedBox(height: 20),

                  // 3. Stats row
                  _buildStatsRow(),

                  const SizedBox(height: 24),

                  // 4. Quick Actions
                  _buildQuickActions(),

                  const SizedBox(height: 24),

                  // 5. Fee Collection & Attendance Overview
                  _buildFeeAndAttendanceRow(),

                  const SizedBox(height: 24),

                  // 6. Recent Notices & Upcoming Events
                  _buildNoticesAndEvents(),

                  const SizedBox(height: 24),

                  // 7. Fee Collection Overview Line Chart
                  _buildFeeCollectionChart(),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 1. HEADER
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 16, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: widget.onOpenDrawer,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back, Admin 👋",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  "Here's what's happening in your school today.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // School selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSchool,
                    isDense: true,
                    dropdownColor: AppColors.primary,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 16,
                    ),
                    items: ['Ecstasy School 1', 'Ecstasy School 2']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSchool = v!),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          // Notification bell
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    "3",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Profile avatar
          GestureDetector(
            onTap: widget.onOpenProfile,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  Text(
                    dayStr,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 3. STATS ROW
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.people,
            iconBgColor: const Color(0xFF4361EE),
            label: "Students",
            value: "1,245",
            change: "↑ 12 this month",
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.school,
            iconBgColor: const Color(0xFFF59E0B),
            label: "Teachers",
            value: "86",
            change: "↑ 3 this month",
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.business,
            iconBgColor: const Color(0xFFEF4444),
            label: "Branches",
            value: "15",
            change: "↑ 1 this month",
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            iconBgColor: const Color(0xFF10B981),
            label: "Attendance\nToday",
            value: "92%",
            change: "↑ 4% from yesterday",
            changeColor: Colors.green,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875),
            ),
          ),
          const SizedBox(height: 4),
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
            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            Row(
              children: [
                const Text(
                  "Customize",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.settings, size: 14, color: AppColors.primary.withValues(alpha: 0.7)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildQuickActionItem(
                Icons.person_add,
                "Add\nStudent",
                const Color(0xFF4361EE),
                widget.onAddStudent,
              ),
              _buildQuickActionItem(
                Icons.people_alt_outlined,
                "Add\nTeacher",
                const Color(0xFF1E2875),
                widget.onAddTeacher,
              ),
              _buildQuickActionItem(
                Icons.how_to_reg,
                "Mark\nAttendance",
                const Color(0xFFF59E0B),
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
                },
              ),
              _buildQuickActionItem(
                Icons.receipt_long,
                "Collect\nFees",
                const Color(0xFF10B981),
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminFeesScreen()));
                },
              ),
              _buildQuickActionItem(
                Icons.campaign,
                "Notice\nBoard",
                const Color(0xFF3B82F6),
                () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminCommunicationsScreen()));
                },
              ),
              _buildQuickActionItem(
                Icons.more_horiz,
                "More",
                const Color(0xFF6B7280),
                () {
                  widget.onOpenDrawer();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return Container(
      width: 74,
      margin: const EdgeInsets.only(right: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
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
  Widget _buildFeeAndAttendanceRow() {
    return Column(
      children: [
        // Fee Collection card
        _buildFeeCollectionCard(),
        const SizedBox(height: 16),
        // Attendance Overview card
        _buildAttendanceOverviewCard(),
      ],
    );
  }

  Widget _buildFeeCollectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Fee Collection",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
              _buildFilterChip(_feeFilter, ['This Month', 'Last Month', 'This Year'],
                  (v) => setState(() => _feeFilter = v)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Left side - amounts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Collected",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "₹ 2,45,000",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Total Pending",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "₹ 18,75,000",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              // Right side - donut chart
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
                            value: 24,
                            color: const Color(0xFFF59E0B),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 76,
                            color: const Color(0xFFE5E7EB),
                            radius: 18,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "24%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875),
                          ),
                        ),
                        Text(
                          "Collected",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminFeesScreen()));
            },
            child: const Row(
              children: [
                Text(
                  "View detailed report",
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

  Widget _buildAttendanceOverviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Attendance Overview",
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
          const SizedBox(height: 16),
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
                            value: 92,
                            color: const Color(0xFF10B981),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 6.3,
                            color: const Color(0xFFEF4444),
                            radius: 18,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 1.7,
                            color: const Color(0xFF9CA3AF),
                            radius: 18,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "92%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2875),
                          ),
                        ),
                        Text(
                          "Present",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Right side - legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      color: const Color(0xFF10B981),
                      label: "Present",
                      value: "1,145",
                    ),
                    const SizedBox(height: 10),
                    _buildLegendItem(
                      color: const Color(0xFFEF4444),
                      label: "Absent",
                      value: "78",
                    ),
                    const SizedBox(height: 10),
                    _buildLegendItem(
                      color: const Color(0xFF9CA3AF),
                      label: "Leave",
                      value: "22",
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
            },
            child: const Row(
              children: [
                Text(
                  "View attendance report",
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
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
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
        const SizedBox(height: 16),
        // Upcoming Events
        _buildUpcomingEvents(),
      ],
    );
  }

  Widget _buildRecentNotices() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Recent Notices",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNoticeItem(
            icon: Icons.wb_sunny,
            iconColor: const Color(0xFFF59E0B),
            title: "Summer Holiday Announcement",
            subtitle: "Holiday will be from 25 May to 10 June 2026.",
            date: "20 May 2026",
          ),
          const SizedBox(height: 10),
          _buildNoticeItem(
            icon: Icons.people,
            iconColor: const Color(0xFF3B82F6),
            title: "Parent Meeting",
            subtitle: "Parent meeting on 26 May at 10 AM.",
            date: "19 May 2026",
          ),
          const SizedBox(height: 10),
          _buildNoticeItem(
            icon: Icons.assignment,
            iconColor: const Color(0xFF10B981),
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
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Upcoming Events",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "View All",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventItem(
            icon: Icons.groups,
            iconColor: const Color(0xFF3B82F6),
            title: "Parent Meeting",
            datetime: "26 May 2026, 10:00 AM",
          ),
          const SizedBox(height: 10),
          _buildEventItem(
            icon: Icons.science,
            iconColor: const Color(0xFF8B5CF6),
            title: "Science Exhibition",
            datetime: "30 May 2026, 09:00 AM",
          ),
          const SizedBox(height: 10),
          _buildEventItem(
            icon: Icons.sports_soccer,
            iconColor: const Color(0xFFF59E0B),
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
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
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
  Widget _buildFeeCollectionChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Fee Collection Overview",
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
          const SizedBox(height: 8),
          // Legend
          Row(
            children: [
              const Text("₹ (Lakh)", style: TextStyle(fontSize: 10, color: Colors.grey)),
              const SizedBox(width: 16),
              _buildChartLegendDot(const Color(0xFF10B981), "Collected"),
              const SizedBox(width: 12),
              _buildChartLegendDot(const Color(0xFFEF4444), "Pending"),
            ],
          ),
          const SizedBox(height: 16),
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
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
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
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
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
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
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
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 12),
                      FlSpot(2, 15),
                      FlSpot(3, 18),
                      FlSpot(4, 24.5),
                      FlSpot(5, 20),
                      FlSpot(6, 18),
                      FlSpot(7, 15),
                      FlSpot(8, 22),
                      FlSpot(9, 25),
                      FlSpot(10, 20),
                      FlSpot(11, 18),
                    ],
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFF10B981),
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF10B981).withValues(alpha: 0.08),
                    ),
                  ),
                  // Pending line (red)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 8),
                      FlSpot(1, 10),
                      FlSpot(2, 12),
                      FlSpot(3, 14),
                      FlSpot(4, 18.7),
                      FlSpot(5, 16),
                      FlSpot(6, 14),
                      FlSpot(7, 12),
                      FlSpot(8, 10),
                      FlSpot(9, 15),
                      FlSpot(10, 18),
                      FlSpot(11, 22),
                    ],
                    isCurved: true,
                    color: const Color(0xFFEF4444),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: const Color(0xFFEF4444),
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFEF4444).withValues(alpha: 0.08),
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
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHAT FAB
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildChatFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Hi! How can I help you?",
            style: TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        const SizedBox(height: 6),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminChatSupportScreen()));
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // HELPER: FILTER CHIP
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildFilterChip(
      String current, List<String> options, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isDense: true,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF1E2875),
            fontWeight: FontWeight.w600,
          ),
          icon: const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF1E2875)),
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}
