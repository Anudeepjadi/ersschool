import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────────────────────────────────────
class _Exam {
  final String subject;
  final String date;
  final String time;
  final String room;
  final Color color;
  final IconData icon;

  const _Exam({
    required this.subject,
    required this.date,
    required this.time,
    required this.room,
    required this.color,
    required this.icon,
  });
}

class _Result {
  final String subject;
  final int marks;
  final int total;
  final Color color;
  final IconData icon;

  const _Result({
    required this.subject,
    required this.marks,
    required this.total,
    required this.color,
    required this.icon,
  });

  double get percentage => (marks / total) * 100;

  String get grade {
    final p = percentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B+';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    return 'F';
  }

  Color get gradeColor {
    final p = percentage;
    if (p >= 80) return Colors.green;
    if (p >= 60) return Colors.orange;
    return Colors.red;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Static data
// ─────────────────────────────────────────────────────────────────────────────
const List<_Exam> _exams = [
  _Exam(
    subject: 'Mathematics',
    date: '18 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall A',
    color: Colors.purple,
    icon: Icons.calculate_outlined,
  ),
  _Exam(
    subject: 'Physics',
    date: '20 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall B',
    color: Colors.green,
    icon: Icons.science_outlined,
  ),
  _Exam(
    subject: 'Chemistry',
    date: '23 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Lab 1',
    color: Colors.orange,
    icon: Icons.biotech_outlined,
  ),
  _Exam(
    subject: 'English',
    date: '25 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall C',
    color: Colors.blue,
    icon: Icons.menu_book_outlined,
  ),
  _Exam(
    subject: 'Social Studies',
    date: '27 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Hall A',
    color: Colors.teal,
    icon: Icons.public_outlined,
  ),
  _Exam(
    subject: 'Computer Science',
    date: '30 Jun 2026',
    time: '09:00 AM – 12:00 PM',
    room: 'Lab 2',
    color: Colors.indigo,
    icon: Icons.computer_outlined,
  ),
];

const List<_Result> _results = [
  _Result(
    subject: 'Mathematics',
    marks: 87,
    total: 100,
    color: Colors.purple,
    icon: Icons.calculate_outlined,
  ),
  _Result(
    subject: 'Physics',
    marks: 79,
    total: 100,
    color: Colors.green,
    icon: Icons.science_outlined,
  ),
  _Result(
    subject: 'Chemistry',
    marks: 92,
    total: 100,
    color: Colors.orange,
    icon: Icons.biotech_outlined,
  ),
  _Result(
    subject: 'English',
    marks: 85,
    total: 100,
    color: Colors.blue,
    icon: Icons.menu_book_outlined,
  ),
  _Result(
    subject: 'Social Studies',
    marks: 74,
    total: 100,
    color: Colors.teal,
    icon: Icons.public_outlined,
  ),
  _Result(
    subject: 'Computer Science',
    marks: 95,
    total: 100,
    color: Colors.indigo,
    icon: Icons.computer_outlined,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Main widget
// ─────────────────────────────────────────────────────────────────────────────
class ExamsTab extends StatefulWidget {
  const ExamsTab({super.key});

  @override
  State<ExamsTab> createState() => _ExamsTabState();
}

class _ExamsTabState extends State<ExamsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  // ── Summary stats ──────────────────────────────────────────────────────────
  double get _overallPercentage {
    final total = _results.fold(0, (sum, r) => sum + r.marks);
    final max = _results.fold(0, (sum, r) => sum + r.total);
    return (total / max) * 100;
  }

  String get _overallGrade {
    final p = _overallPercentage;
    if (p >= 90) return 'A+';
    if (p >= 80) return 'A';
    if (p >= 70) return 'B+';
    if (p >= 60) return 'B';
    if (p >= 50) return 'C';
    return 'F';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Exams',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Timetable'),
                Tab(icon: Icon(Icons.bar_chart_rounded), text: 'Results'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _TimetableView(exams: _exams),
            _ResultsView(results: _results),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF3B5BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 56, bottom: 52),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Quarterly Exams 2026',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_exams.length} subjects • Jun 2026',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_overallPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Grade: $_overallGrade',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Timetable Tab
// ─────────────────────────────────────────────────────────────────────────────
class _TimetableView extends StatelessWidget {
  final List<_Exam> exams;
  const _TimetableView({required this.exams});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info banner
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Please carry your hall ticket and ID card to every exam.',
                  style: TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),

        // Exam cards
        ...exams.map((exam) => _ExamCard(exam: exam)),
      ],
    );
  }
}

class _ExamCard extends StatelessWidget {
  final _Exam exam;
  const _ExamCard({required this.exam});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: exam.color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: exam.color, width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: exam.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(exam.icon, color: exam.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        exam.date,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.access_time_outlined,
                          size: 13, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        exam.time,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: exam.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                exam.room,
                style: TextStyle(
                  color: exam.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Results Tab
// ─────────────────────────────────────────────────────────────────────────────
class _ResultsView extends StatelessWidget {
  final List<_Result> results;
  const _ResultsView({required this.results});

  int get _totalMarks => results.fold(0, (s, r) => s + r.marks);
  int get _totalMax => results.fold(0, (s, r) => s + r.total);
  double get _overallPct => (_totalMarks / _totalMax) * 100;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall summary card
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2875), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Performance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_totalMarks / $_totalMax',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _overallPct / 100,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    '${_overallPct.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Percentage',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Rank: 5',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Individual results
        ...results.map((result) => _ResultCard(result: result)),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  final _Result result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: result.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(result.icon, color: result.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  result.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1E2875),
                  ),
                ),
              ),
              // Grade badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: result.gradeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  result.grade,
                  style: TextStyle(
                    color: result.gradeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: result.marks / result.total,
                    backgroundColor: Colors.grey.shade100,
                    valueColor:
                        AlwaysStoppedAnimation(result.color),
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${result.marks}/${result.total}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${result.percentage.toStringAsFixed(0)}%)',
                style:
                    TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
