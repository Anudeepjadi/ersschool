import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ersschool/core/theme/app_theme.dart';

class AssignmentsScreen extends StatefulWidget {
  final bool showAppBar;
  const AssignmentsScreen({super.key, this.showAppBar = true});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> pendingAssignments = [
    {
      'subject': 'Mathematics',
      'title': 'Chapter 5 Exercise',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'Solve exercise questions from chapter 5. Focus on quadratic equations.',
      'dueDate': 'Due Today',
      'dueTime': '11:59 PM',
      'isUrgent': true,
      'icon': Icons.calculate_outlined,
      'color': Color(0xFF3B82F6),
      'marks': '20 Marks',
      'attachments': 2,
    },
    {
      'subject': 'Science',
      'title': 'Lab Report – Plant Cell',
      'type': 'Practical',
      'typeIcon': Icons.biotech_outlined,
      'typeColor': Color(0xFFEF4444),
      'description': 'Write a report on the plant cell experiment. Include diagrams and observations.',
      'dueDate': 'Due Tomorrow',
      'dueTime': '11:59 PM',
      'isUrgent': false,
      'icon': Icons.science_outlined,
      'color': Color(0xFF10B981),
      'marks': '15 Marks',
      'attachments': 1,
    },
    {
      'subject': 'English',
      'title': 'Essay – My Best Friend',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'Write an essay on "My Best Friend" in 500 words using proper grammar.',
      'dueDate': 'Due 22 Jun',
      'dueTime': '11:59 PM',
      'isUrgent': false,
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFF8B5CF6),
      'marks': '10 Marks',
      'attachments': 0,
    },
    {
      'subject': 'Hindi',
      'title': 'निबंध – मेरा विद्यालय',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'हिंदी में "मेरा विद्यालय" पर 300 शब्दों में निबंध लिखें।',
      'dueDate': 'Due 23 Jun',
      'dueTime': '11:59 PM',
      'isUrgent': false,
      'icon': Icons.translate_outlined,
      'color': Color(0xFFF97316),
      'marks': '10 Marks',
      'attachments': 0,
    },
    {
      'subject': 'Social Science',
      'title': 'Map Work – Rivers of India',
      'type': 'Project',
      'typeIcon': Icons.folder_outlined,
      'typeColor': Color(0xFF10B981),
      'description': 'Mark the major rivers of India on a physical map. Label all tributaries.',
      'dueDate': 'Due 25 Jun',
      'dueTime': '11:59 PM',
      'isUrgent': false,
      'icon': Icons.public_outlined,
      'color': Color(0xFFEF4444),
      'marks': '25 Marks',
      'attachments': 3,
    },
    {
      'subject': 'Computer Science',
      'title': 'Python – Calculator Program',
      'type': 'Practical',
      'typeIcon': Icons.biotech_outlined,
      'typeColor': Color(0xFFEF4444),
      'description': 'Write a Python program for a basic calculator with +, -, ×, ÷ operations.',
      'dueDate': 'Due 26 Jun',
      'dueTime': '11:59 PM',
      'isUrgent': false,
      'icon': Icons.computer_outlined,
      'color': Color(0xFF06B6D4),
      'marks': '20 Marks',
      'attachments': 1,
    },
  ];

  final List<Map<String, dynamic>> completedAssignments = [
    {
      'subject': 'Hindi',
      'title': 'पत्र लेखन – प्रधानाचार्य को',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'अवकाश के लिए प्रधानाचार्य को औपचारिक पत्र लिखें।',
      'dueDate': 'Submitted',
      'dueTime': '18 Jun',
      'isUrgent': false,
      'icon': Icons.translate_outlined,
      'color': Color(0xFFF97316),
      'grade': 'A+',
      'gradeIcon': Icons.star,
      'score': '9/10',
      'feedback': 'Excellent letter format and grammar!',
    },
    {
      'subject': 'English',
      'title': 'Grammar – Tenses Worksheet',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'Complete the tense transformation exercise from page 45-48.',
      'dueDate': 'Submitted',
      'dueTime': '17 Jun',
      'isUrgent': false,
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFF8B5CF6),
      'grade': 'A',
      'gradeIcon': Icons.star,
      'score': '18/20',
      'feedback': 'Good work! Review past perfect tense.',
    },
    {
      'subject': 'Computer Science',
      'title': 'Python – Hello World',
      'type': 'Practical',
      'typeIcon': Icons.biotech_outlined,
      'typeColor': Color(0xFFEF4444),
      'description': 'Write a Python program to print Hello World and basic variables.',
      'dueDate': 'Submitted',
      'dueTime': '15 Jun',
      'isUrgent': false,
      'icon': Icons.computer_outlined,
      'color': Color(0xFF06B6D4),
      'grade': 'A',
      'gradeIcon': Icons.star,
      'score': '19/20',
      'feedback': 'Clean code, well commented!',
    },
    {
      'subject': 'Mathematics',
      'title': 'Chapter 4 – Linear Equations',
      'type': 'Homework',
      'typeIcon': Icons.home_work_outlined,
      'typeColor': Color(0xFF3B82F6),
      'description': 'Solve all problems from exercise 4.1 and 4.2.',
      'dueDate': 'Submitted',
      'dueTime': '14 Jun',
      'isUrgent': false,
      'icon': Icons.calculate_outlined,
      'color': Color(0xFF3B82F6),
      'grade': 'B+',
      'gradeIcon': Icons.star_half,
      'score': '15/20',
      'feedback': 'Good attempt. Practice more word problems.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: _tabController,
      indicatorColor: widget.showAppBar ? Colors.white : AppColors.primary,
      indicatorWeight: 3,
      labelColor: widget.showAppBar ? Colors.white : AppColors.primary,
      unselectedLabelColor: widget.showAppBar ? Colors.white60 : Colors.grey.shade600,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pending_actions_outlined, size: 18),
              const SizedBox(width: 6),
              const Text('Pending'),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.showAppBar 
                      ? Colors.white.withValues(alpha: 0.2) 
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${pendingAssignments.length}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 18),
              const SizedBox(width: 6),
              const Text('Completed'),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.showAppBar 
                      ? Colors.white.withValues(alpha: 0.2) 
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${completedAssignments.length}',
                  style: GoogleFonts.poppins(
                      fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Assignments'),
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list_outlined),
                ),
              ],
              bottom: tabBar,
            )
          : null,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          if (!widget.showAppBar)
            Container(
              color: Colors.white,
              child: tabBar,
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingList(),
                _buildCompletedList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingAssignments.length,
      itemBuilder: (context, index) {
        return _buildPendingCard(pendingAssignments[index]);
      },
    );
  }

  Widget _buildCompletedList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedAssignments.length,
      itemBuilder: (context, index) {
        return _buildCompletedCard(completedAssignments[index]);
      },
    );
  }

  Widget _buildPendingCard(Map<String, dynamic> a) {
    final color = a['color'] as Color;
    final isUrgent = a['isUrgent'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: isUrgent
            ? Border.all(color: AppColors.error.withValues(alpha: 0.3), width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // Urgent banner
          if (isUrgent)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_outlined,
                      size: 14, color: AppColors.error),
                  const SizedBox(width: 4),
                  Text(
                    'Due Today – Submit before deadline!',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(a['icon'], size: 20, color: color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a['subject'],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            a['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Type badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (a['typeColor'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(a['typeIcon'], size: 12, color: a['typeColor']),
                          const SizedBox(width: 3),
                          Text(
                            a['type'],
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: a['typeColor'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Description
                Text(
                  a['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // Footer
                Row(
                  children: [
                    // Marks
                    _buildInfoChip(Icons.grade_outlined, a['marks'], color),
                    const SizedBox(width: 8),
                    // Attachments
                    if ((a['attachments'] as int) > 0)
                      _buildInfoChip(Icons.attach_file_outlined,
                          '${a['attachments']} files', AppColors.textSecondary),
                    const Spacer(),
                    // Due date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          a['dueDate'],
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isUrgent ? AppColors.error : AppColors.primary,
                          ),
                        ),
                        Text(
                          a['dueTime'],
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right,
                        size: 20, color: AppColors.textSecondary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedCard(Map<String, dynamic> a) {
    final color = a['color'] as Color;
    final gradeColor = a['grade'] == 'A+' || a['grade'] == 'A'
        ? AppColors.success
        : const Color(0xFFF59E0B);

    return Container(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(a['icon'], size: 20, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['subject'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      a['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Grade badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(a['gradeIcon'], size: 16, color: gradeColor),
                    const SizedBox(height: 2),
                    Text(
                      a['grade'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: gradeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            a['description'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          // Score and feedback
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: gradeColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, size: 16, color: gradeColor),
                const SizedBox(width: 6),
                Text(
                  'Score: ${a['score']}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: gradeColor,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    a['feedback'],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Footer
          Row(
            children: [
              Icon(Icons.check_circle, size: 14, color: AppColors.success),
              const SizedBox(width: 4),
              Text(
                'Submitted on ${a['dueTime']}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
