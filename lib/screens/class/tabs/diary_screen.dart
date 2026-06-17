import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ersschool/core/theme/app_theme.dart';

class DiaryScreen extends StatefulWidget {
  final bool showAppBar;
  const DiaryScreen({super.key, this.showAppBar = true});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime(2026, 6, 17);

  final List<Map<String, dynamic>> diaryEntries = [
    {
      'date': '17 Jun 2026',
      'day': 'Wednesday',
      'entries': [
        {
          'subject': 'Mathematics',
          'icon': Icons.calculate_outlined,
          'color': Color(0xFF3B82F6),
          'title': 'Complete Exercise 5.3',
          'description': 'Solve all problems from exercise 5.3 of the textbook. Focus on quadratic equations and factorization.',
          'teacher': 'Mr. Amit Verma',
          'type': 'Homework',
          'typeIcon': Icons.home_work_outlined,
          'period': '1st Period',
        },
        {
          'subject': 'English',
          'icon': Icons.menu_book_outlined,
          'color': Color(0xFF8B5CF6),
          'title': 'Essay – My Best Friend',
          'description': 'Write an essay on "My Best Friend" in 500 words. Use proper grammar and vocabulary.',
          'teacher': 'Ms. Priya Sharma',
          'type': 'Assignment',
          'typeIcon': Icons.assignment_outlined,
          'period': '2nd Period',
        },
        {
          'subject': 'Science',
          'icon': Icons.science_outlined,
          'color': Color(0xFF10B981),
          'title': 'Lab Report – Plant Cell',
          'description': 'Submit the lab report on plant cell experiment. Include diagrams and observations.',
          'teacher': 'Mr. Rahul Mehta',
          'type': 'Practical',
          'typeIcon': Icons.biotech_outlined,
          'period': '3rd Period',
        },
        {
          'subject': 'Hindi',
          'icon': Icons.translate_outlined,
          'color': Color(0xFFF97316),
          'title': 'निबंध – मेरा विद्यालय',
          'description': 'हिंदी में "मेरा विद्यालय" पर 300 शब्दों में निबंध लिखें। व्याकरण पर ध्यान दें।',
          'teacher': 'Mr. Sandeep Yadav',
          'type': 'Homework',
          'typeIcon': Icons.home_work_outlined,
          'period': '5th Period',
        },
        {
          'subject': 'Computer Science',
          'icon': Icons.computer_outlined,
          'color': Color(0xFF06B6D4),
          'title': 'Python Program – Calculator',
          'description': 'Write a Python program for a basic calculator with +, -, ×, ÷ operations.',
          'teacher': 'Ms. Anjali Singh',
          'type': 'Practical',
          'typeIcon': Icons.biotech_outlined,
          'period': '6th Period',
        },
      ],
    },
    {
      'date': '15 Jun 2026',
      'day': 'Monday',
      'entries': [
        {
          'subject': 'Social Science',
          'icon': Icons.public_outlined,
          'color': Color(0xFFEF4444),
          'title': 'Chapter 7 – The French Revolution',
          'description': 'Read Chapter 7 and prepare detailed notes. Mark important dates and events on timeline.',
          'teacher': 'Ms. Neha Gupta',
          'type': 'Study',
          'typeIcon': Icons.auto_stories_outlined,
          'period': '4th Period',
        },
        {
          'subject': 'English',
          'icon': Icons.menu_book_outlined,
          'color': Color(0xFF8B5CF6),
          'title': 'Grammar – Tenses Practice',
          'description': 'Complete the tense transformation exercises on page 45-48. Practice past, present and future tenses.',
          'teacher': 'Ms. Priya Sharma',
          'type': 'Homework',
          'typeIcon': Icons.home_work_outlined,
          'period': '2nd Period',
        },
        {
          'subject': 'Hindi',
          'icon': Icons.translate_outlined,
          'color': Color(0xFFF97316),
          'title': 'पत्र लेखन – प्रधानाचार्य को',
          'description': 'अवकाश के लिए प्रधानाचार्य को औपचारिक पत्र लिखें। सही प्रारूप का पालन करें।',
          'teacher': 'Mr. Sandeep Yadav',
          'type': 'Assignment',
          'typeIcon': Icons.assignment_outlined,
          'period': '5th Period',
        },
      ],
    },
    {
      'date': '12 Jun 2026',
      'day': 'Friday',
      'entries': [
        {
          'subject': 'Mathematics',
          'icon': Icons.calculate_outlined,
          'color': Color(0xFF3B82F6),
          'title': 'Revision – Chapter 4 & 5',
          'description': 'Revise chapters 4 and 5 for the upcoming class test. Practice all solved examples.',
          'teacher': 'Mr. Amit Verma',
          'type': 'Revision',
          'typeIcon': Icons.refresh_outlined,
          'period': '1st Period',
        },
        {
          'subject': 'English',
          'icon': Icons.menu_book_outlined,
          'color': Color(0xFF8B5CF6),
          'title': 'Poem Recitation – The Road Not Taken',
          'description': 'Prepare the poem "The Road Not Taken" by Robert Frost for recitation. Memorize all stanzas.',
          'teacher': 'Ms. Priya Sharma',
          'type': 'Activity',
          'typeIcon': Icons.mic_outlined,
          'period': '2nd Period',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: const Text('Diary'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_outlined),
          ),
        ],
      ) : null,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Date selector
          _buildDateSelector(),
          // Diary entries
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final dayEntry = diaryEntries[index];
                return _buildDaySection(dayEntry);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chevron_left, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.primary),
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
              Icon(Icons.keyboard_arrow_down,
                  size: 20, color: AppColors.textSecondary),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.chevron_right, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(Map<String, dynamic> dayEntry) {
    final entries = dayEntry['entries'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          margin: const EdgeInsets.only(top: 12, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                '${dayEntry['day']}, ${dayEntry['date']}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${entries.length} entries',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Entries with timeline
        ...List.generate(entries.length, (i) {
          return _buildDiaryCard(entries[i], isLast: i == entries.length - 1);
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildDiaryCard(Map<String, dynamic> entry, {required bool isLast}) {
    final color = entry['color'] as Color;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: color.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          ),
          // Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border(
                  left: BorderSide(color: color, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(entry['icon'], size: 18, color: color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['subject'],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person_outline,
                                    size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    entry['teacher'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.access_time_outlined,
                                    size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 3),
                                Text(
                                  entry['period'],
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
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(entry['typeIcon'], size: 12, color: color),
                            const SizedBox(width: 4),
                            Text(
                              entry['type'],
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Row(
                    children: [
                      Icon(Icons.bookmark_outline, size: 14, color: color),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          entry['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      entry['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
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
}
