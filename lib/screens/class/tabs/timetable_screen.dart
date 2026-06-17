import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ersschool/core/theme/app_theme.dart';

class TimetableScreen extends StatefulWidget {
  final bool showAppBar;
  const TimetableScreen({super.key, this.showAppBar = true});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  DateTime selectedDate = DateTime(2026, 6, 17);

  final List<Map<String, dynamic>> periods = [
    {
      'period': 1,
      'time': '08:00 AM\n– 08:45 AM',
      'subject': 'Mathematics',
      'code': 'MATH',
      'icon': Icons.calculate_outlined,
      'teacher': 'Mr. Amit Verma',
      'room': '101',
      'color': Color(0xFF3B82F6),
    },
    {
      'period': 2,
      'time': '08:45 AM\n– 09:30 AM',
      'subject': 'English',
      'code': 'ENG',
      'icon': Icons.menu_book_outlined,
      'teacher': 'Ms. Priya Sharma',
      'room': '102',
      'color': Color(0xFF8B5CF6),
    },
    {
      'period': 3,
      'time': '09:30 AM\n– 10:15 AM',
      'subject': 'Science',
      'code': 'SCI',
      'icon': Icons.science_outlined,
      'teacher': 'Mr. Rahul Mehta',
      'room': '103',
      'color': Color(0xFF10B981),
    },
    {
      'period': -1, // break
      'time': '10:15 AM - 10:30 AM',
      'subject': 'Break Time',
      'code': '',
      'icon': Icons.coffee_outlined,
      'teacher': '',
      'room': '',
      'color': Color(0xFFF59E0B),
    },
    {
      'period': 4,
      'time': '10:30 AM\n– 11:15 AM',
      'subject': 'Social Science',
      'code': 'SST',
      'icon': Icons.public_outlined,
      'teacher': 'Ms. Neha Gupta',
      'room': '104',
      'color': Color(0xFFEF4444),
    },
    {
      'period': 5,
      'time': '11:15 AM\n– 12:00 PM',
      'subject': 'Hindi',
      'code': 'HIN',
      'icon': Icons.translate_outlined,
      'teacher': 'Mr. Sandeep Yadav',
      'room': '105',
      'color': Color(0xFFF97316),
    },
    {
      'period': 6,
      'time': '12:00 PM\n– 12:45 PM',
      'subject': 'Computer\nScience',
      'code': 'CS',
      'icon': Icons.computer_outlined,
      'teacher': 'Ms. Anjali Singh',
      'room': '106',
      'color': Color(0xFF06B6D4),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: const Text('Full Timetable'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ) : null,
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 20),
            _buildTimetableHeader(),
            const SizedBox(height: 12),
            ...periods.map((period) => _buildPeriodCard(period)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.subtract(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Wednesday, 17 Jun 2026',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 20, color: AppColors.textSecondary),
            ],
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedDate = selectedDate.add(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableHeader() {
    return Text(
      'Timetable',
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPeriodCard(Map<String, dynamic> period) {
    final isBreak = period['period'] == -1;

    if (isBreak) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: Row(
          children: [
            Icon(Icons.coffee_outlined, color: Color(0xFFF59E0B), size: 20),
            const SizedBox(width: 12),
            Text(
              'Break Time',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB45309),
              ),
            ),
            const Spacer(),
            Text(
              period['time'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Color(0xFFB45309),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Period number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: (period['color'] as Color).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${period['period']}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: period['color'],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Time
          SizedBox(
            width: 70,
            child: Text(
              period['time'],
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Subject icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (period['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              period['icon'],
              size: 18,
              color: period['color'],
            ),
          ),
          const SizedBox(width: 10),
          // Subject details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period['subject'],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  period['code'],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Teacher
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: (period['color'] as Color).withValues(alpha: 0.2),
                    child: Icon(Icons.person, size: 16, color: period['color']),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    period['teacher'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ),
          const SizedBox(width: 10),
          // Room
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: (period['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              period['room'],
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: period['color'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
