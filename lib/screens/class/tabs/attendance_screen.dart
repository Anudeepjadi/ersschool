import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ersschool/core/theme/app_theme.dart';

class AttendanceScreen extends StatelessWidget {
  final bool showAppBar;
  const AttendanceScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: const Text('Attendance'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ) : null,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallSummary(),
            const SizedBox(height: 20),
            _buildMonthlyChart(),
            const SizedBox(height: 20),
            _buildSubjectAttendance(),
            const SizedBox(height: 20),
            _buildCalendarView(),
            const SizedBox(height: 20),
            _buildRecentHistory(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ============================================
  // OVERALL SUMMARY CARDS
  // ============================================
  Widget _buildOverallSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pie_chart_outline, size: 20, color: Colors.white70),
              const SizedBox(width: 8),
              Text(
                'Attendance Summary',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryCard(
                Icons.calendar_month_outlined,
                'Total Classes',
                '120',
                Colors.white,
              ),
              const SizedBox(width: 10),
              _buildSummaryCard(
                Icons.check_circle_outline,
                'Present',
                '108',
                const Color(0xFF34D399),
              ),
              const SizedBox(width: 10),
              _buildSummaryCard(
                Icons.cancel_outlined,
                'Absent',
                '8',
                const Color(0xFFFBBF24),
              ),
              const SizedBox(width: 10),
              _buildSummaryCard(
                Icons.percent,
                'Attendance',
                '90%',
                const Color(0xFFA78BFA),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.9,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF34D399)),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.info_outline, size: 12, color: Colors.white60),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Minimum required: 75% | You are above the requirement ✓',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      IconData icon, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // MONTHLY BAR CHART
  // ============================================
  Widget _buildMonthlyChart() {
    final months = [
      {'month': 'Jan', 'percentage': 95, 'present': 19, 'total': 20},
      {'month': 'Feb', 'percentage': 88, 'present': 21, 'total': 24},
      {'month': 'Mar', 'percentage': 92, 'present': 23, 'total': 25},
      {'month': 'Apr', 'percentage': 85, 'present': 17, 'total': 20},
      {'month': 'Jun', 'percentage': 90, 'present': 28, 'total': 31},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bar_chart_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Monthly Overview',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 190,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: months.map((m) {
                final percentage = m['percentage'] as int;
                final barColor = percentage >= 90
                    ? AppColors.presentGreen
                    : percentage >= 80
                        ? AppColors.absentOrange
                        : AppColors.error;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$percentage%',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: barColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: (percentage * 1.1).toDouble(),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            barColor,
                            barColor.withValues(alpha: 0.5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      m['month'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${m['present']}/${m['total']}',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // SUBJECT-WISE ATTENDANCE
  // ============================================
  Widget _buildSubjectAttendance() {
    final subjects = [
      {
        'subject': 'Mathematics',
        'icon': Icons.calculate_outlined,
        'present': 20,
        'total': 22,
        'color': Color(0xFF3B82F6),
      },
      {
        'subject': 'English',
        'icon': Icons.menu_book_outlined,
        'present': 19,
        'total': 20,
        'color': Color(0xFF8B5CF6),
      },
      {
        'subject': 'Science',
        'icon': Icons.science_outlined,
        'present': 21,
        'total': 22,
        'color': Color(0xFF10B981),
      },
      {
        'subject': 'Hindi',
        'icon': Icons.translate_outlined,
        'present': 16,
        'total': 18,
        'color': Color(0xFFF97316),
      },
      {
        'subject': 'Social Science',
        'icon': Icons.public_outlined,
        'present': 18,
        'total': 20,
        'color': Color(0xFFEF4444),
      },
      {
        'subject': 'Computer Science',
        'icon': Icons.computer_outlined,
        'present': 14,
        'total': 18,
        'color': Color(0xFF06B6D4),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Subject-wise Attendance',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...subjects.map((s) {
            final percentage =
                ((s['present'] as int) / (s['total'] as int) * 100).round();
            final color = s['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  // Subject icon
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(s['icon'] as IconData, size: 16, color: color),
                  ),
                  const SizedBox(width: 10),
                  // Subject name and progress
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              s['subject'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${s['present']}/${s['total']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$percentage%',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: color.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation(color),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================
  // CALENDAR VIEW (mini)
  // ============================================
  Widget _buildCalendarView() {
    // June 2026 attendance data
    final attendanceMap = {
      1: 'present', 2: 'present', 3: 'present', 4: 'present', 5: 'present',
      6: 'weekend', 7: 'weekend',
      8: 'absent', 9: 'present', 10: 'present', 11: 'present', 12: 'present',
      13: 'weekend', 14: 'weekend',
      15: 'absent', 16: 'present', 17: 'present',
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_view_month_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'June 2026',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_left, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: 14),
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((d) => SizedBox(
                      width: 36,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Calendar grid (June 2026 starts on Monday)
          _buildCalendarWeek([1, 2, 3, 4, 5, 6, 7], attendanceMap),
          _buildCalendarWeek([8, 9, 10, 11, 12, 13, 14], attendanceMap),
          _buildCalendarWeek([15, 16, 17, 18, 19, 20, 21], attendanceMap),
          _buildCalendarWeek([22, 23, 24, 25, 26, 27, 28], attendanceMap),
          _buildCalendarWeek([29, 30, 0, 0, 0, 0, 0], attendanceMap),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.presentGreen, 'Present'),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.error, 'Absent'),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.textLight.withValues(alpha: 0.3), 'Weekend'),
              const SizedBox(width: 16),
              _buildLegendItem(AppColors.primary, 'Today'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWeek(
      List<int> days, Map<int, String> attendanceMap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          if (day == 0) {
            return const SizedBox(width: 36, height: 36);
          }
          final status = attendanceMap[day] ?? 'future';
          final isToday = day == 17;

          Color bgColor;
          Color textColor;
          IconData? icon;

          if (isToday) {
            bgColor = AppColors.primary;
            textColor = Colors.white;
          } else if (status == 'present') {
            bgColor = AppColors.presentGreen.withValues(alpha: 0.15);
            textColor = AppColors.presentGreen;
            icon = Icons.check;
          } else if (status == 'absent') {
            bgColor = AppColors.error.withValues(alpha: 0.15);
            textColor = AppColors.error;
            icon = Icons.close;
          } else if (status == 'weekend') {
            bgColor = AppColors.textLight.withValues(alpha: 0.08);
            textColor = AppColors.textLight;
          } else {
            bgColor = Colors.transparent;
            textColor = AppColors.textSecondary;
          }

          return Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$day',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (icon != null && !isToday)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Icon(icon, size: 8, color: textColor),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================
  // RECENT HISTORY
  // ============================================
  Widget _buildRecentHistory() {
    final history = [
      {
        'date': '17 Jun',
        'day': 'Wednesday',
        'status': 'Present',
        'icon': Icons.check_circle,
        'color': AppColors.presentGreen,
        'time': '07:55 AM',
        'periods': '6/6',
      },
      {
        'date': '16 Jun',
        'day': 'Tuesday',
        'status': 'Present',
        'icon': Icons.check_circle,
        'color': AppColors.presentGreen,
        'time': '08:00 AM',
        'periods': '6/6',
      },
      {
        'date': '15 Jun',
        'day': 'Monday',
        'status': 'Absent',
        'icon': Icons.cancel,
        'color': AppColors.error,
        'time': '—',
        'periods': '0/6',
        'reason': 'Sick Leave',
      },
      {
        'date': '12 Jun',
        'day': 'Friday',
        'status': 'Present',
        'icon': Icons.check_circle,
        'color': AppColors.presentGreen,
        'time': '07:50 AM',
        'periods': '6/6',
      },
      {
        'date': '11 Jun',
        'day': 'Thursday',
        'status': 'Present',
        'icon': Icons.check_circle,
        'color': AppColors.presentGreen,
        'time': '07:58 AM',
        'periods': '5/6',
      },
      {
        'date': '10 Jun',
        'day': 'Wednesday',
        'status': 'Present',
        'icon': Icons.check_circle,
        'color': AppColors.presentGreen,
        'time': '08:02 AM',
        'periods': '6/6',
      },
      {
        'date': '9 Jun',
        'day': 'Tuesday',
        'status': 'Half Day',
        'icon': Icons.timelapse,
        'color': AppColors.absentOrange,
        'time': '07:55 AM',
        'periods': '3/6',
        'reason': 'Left early – doctor appointment',
      },
      {
        'date': '8 Jun',
        'day': 'Monday',
        'status': 'Absent',
        'icon': Icons.cancel,
        'color': AppColors.error,
        'time': '—',
        'periods': '0/6',
        'reason': 'Family function',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Recent History',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...history.map((h) {
            final color = h['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(h['icon'] as IconData, color: color, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${h['day']}, ${h['date']}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (h.containsKey('reason'))
                          Row(
                            children: [
                              Icon(Icons.info_outline,
                                  size: 11, color: AppColors.textLight),
                              const SizedBox(width: 3),
                              Text(
                                h['reason'] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Arrival time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            h['time'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.class_outlined, size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            h['periods'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 6),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      h['status'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
