import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../widgets/app_footer.dart';

class AdminTimeTableScreen extends StatefulWidget {
  const AdminTimeTableScreen({super.key});

  @override
  State<AdminTimeTableScreen> createState() => _AdminTimeTableScreenState();
}

class _AdminTimeTableScreenState extends State<AdminTimeTableScreen> {
  String _selectedBranch = 'Ecstasy School 1 (ECS001)';
  String _selectedClass = 'Grade 1';
  String _selectedSection = 'A';
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  Map<String, List<Map<String, dynamic>>> _timetable = {};

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  void _getDetails() {
    setState(() {
      if (_selectedBranch == 'Ecstasy School 1 (ECS001)') {
        if (_selectedClass == 'Grade 1' && _selectedSection == 'A') {
          _timetable = {
            'Monday': [
              {
                'time': '09:00 AM - 09:30 AM',
                'subject': 'Maths',
                'teacher': ''
              },
              {
                'time': '09:30 AM - 10:00 AM',
                'subject': 'Maths',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Maths',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Hindi',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Maths',
                'teacher': 'Ms. Rani'
              },
              {
                'time': '10:30 AM - 11:00 AM',
                'subject': 'Maths',
                'teacher': 'Ms. Rani'
              },
              {
                'time': '12:00 PM - 12:00 PM',
                'subject': 'Maths',
                'teacher': 'Ms. Rani'
              },
            ],
            'Tuesday': [
              {
                'time': '09:30 AM - 10:00 AM',
                'subject': 'Science',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Telugu',
                'teacher': ''
              },
              {
                'time': '09:00 AM - 09:30 AM',
                'subject': 'English',
                'teacher': ''
              },
              {
                'time': '09:30 AM - 10:00 AM',
                'subject': 'Social',
                'teacher': ''
              },
              {
                'time': '10:15 AM - 10:45 AM',
                'subject': 'Maths',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'English',
                'teacher': ''
              },
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Science',
                'teacher': 'Mr. Giri Prasad'
              },
            ],
            'Wednesday': [
              {
                'time': '08:30 AM - 09:00 AM',
                'subject': 'Hindi',
                'teacher': ''
              },
              {
                'time': '09:00 AM - 09:30 AM',
                'subject': 'English',
                'teacher': ''
              },
              {
                'time': '10:00 AM - 10:30 AM',
                'subject': 'Maths',
                'teacher': 'Mr. Giri Prasad'
              },
            ],
          };
        } else {
          _timetable = {
            'Monday': [
              {
                'time': '09:00 AM - 10:00 AM',
                'subject': 'General',
                'teacher': 'Staff'
              }
            ],
            'Tuesday': [
              {
                'time': '09:00 AM - 10:00 AM',
                'subject': 'General',
                'teacher': 'Staff'
              }
            ],
            'Wednesday': [
              {
                'time': '09:00 AM - 10:00 AM',
                'subject': 'General',
                'teacher': 'Staff'
              }
            ],
          };
        }
      } else if (_selectedBranch == 'Ecstasy School 2 (ECS002)') {
        _timetable = {
          'Monday': [
            {
              'time': '09:00 AM - 10:00 AM',
              'subject': 'Science',
              'teacher': 'Mr. Rao'
            }
          ],
          'Tuesday': [
            {
              'time': '10:00 AM - 11:00 AM',
              'subject': 'History',
              'teacher': 'Ms. Devi'
            }
          ],
          'Wednesday': [
            {
              'time': '11:00 AM - 12:00 PM',
              'subject': 'Music',
              'teacher': 'Mr. Kumar'
            }
          ],
        };
      } else {
        _timetable = {
          'Monday': [],
          'Tuesday': [],
          'Wednesday': [],
          'Thursday': [],
          'Friday': [],
          'Saturday': []
        };
      }
    });
  }

  Future<void> _printTimetable() async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          final pdf = pw.Document();
          pdf.addPage(
            pw.Page(
              pageFormat: format.landscape,
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Center(
                        child: pw.Text("Time Table - $_selectedBranch",
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold))),
                    pw.SizedBox(height: 10),
                    pw.Text("Class: $_selectedClass - $_selectedSection",
                        style: pw.TextStyle(fontSize: 16)),
                    pw.SizedBox(height: 20),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Day",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Text("Schedules",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold))),
                          ],
                        ),
                        ..._days
                            .where((d) => _timetable[d]?.isNotEmpty ?? false)
                            .map((day) {
                          final periods = _timetable[day] ?? [];
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                  padding: const pw.EdgeInsets.all(5),
                                  child: pw.Text(day)),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(5),
                                child: pw.Wrap(
                                  spacing: 10,
                                  runSpacing: 5,
                                  children: periods.map((p) {
                                    if (p['subject'].isEmpty)
                                      return pw.SizedBox();
                                    return pw.Container(
                                      padding: const pw.EdgeInsets.all(5),
                                      decoration: pw.BoxDecoration(
                                          border: pw.Border.all(
                                              color: PdfColors.grey)),
                                      child: pw.Column(
                                        children: [
                                          pw.Text(p['time'],
                                              style: const pw.TextStyle(
                                                  fontSize: 8)),
                                          pw.Text(p['subject'],
                                              style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          if (p['teacher'].isNotEmpty)
                                            pw.Text(p['teacher'],
                                                style: const pw.TextStyle(
                                                    fontSize: 8)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
          return pdf.save();
        },
      );
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error printing: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const AdminAppBar(
          title: "Time Table", subtitle: "Manage class schedules"),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildFilters(),
                  const SizedBox(height: 24),
                  LayoutBuilder(builder: (context, constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Text("$_selectedClass - $_selectedSection",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875)),
                                overflow: TextOverflow.ellipsis)),
                        Row(children: [
                          _buildPrintButton(),
                          const SizedBox(width: 8),
                          _buildAddNewButton()
                        ]),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildTimetableGrid(),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildPrintButton() {
    return ElevatedButton.icon(
        onPressed: _printTimetable,
        icon: const Icon(Icons.print, size: 16),
        label: const Text("Print"),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4))));
  }

  Widget _buildAddNewButton() {
    return ElevatedButton.icon(
        onPressed: () => _showScheduleDialog(),
        icon: const Icon(Icons.add, size: 16),
        label: const Text("Add New"),
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4))));
  }

  Widget _buildFilters() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdown(
                  label: "Branch",
                  value: _selectedBranch,
                  items: [
                    'Ecstasy School 1 (ECS001)',
                    'Ecstasy School 2 (ECS002)',
                    'Ecstasy School 3 (ECS003)'
                  ],
                  onChanged: (v) => setState(() => _selectedBranch = v!)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                    child: _buildDropdown(
                        label: "Class",
                        value: _selectedClass,
                        items: [
                          'Grade 1',
                          'Grade 2',
                          'Grade 3',
                          'Grade 4',
                          'Grade 5'
                        ],
                        onChanged: (v) => setState(() => _selectedClass = v!))),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildDropdown(
                        label: "Section",
                        value: _selectedSection,
                        items: ['A', 'B', 'C', 'D'],
                        onChanged: (v) =>
                            setState(() => _selectedSection = v!))),
              ]),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: _getDetails,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2875),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: const Text("Get Details")),
            ]);
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
            child: _buildDropdown(
                label: "Branch",
                value: _selectedBranch,
                items: [
                  'Ecstasy School 1 (ECS001)',
                  'Ecstasy School 2 (ECS002)',
                  'Ecstasy School 3 (ECS003)'
                ],
                onChanged: (v) => setState(() => _selectedBranch = v!))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildDropdown(
                label: "Class",
                value: _selectedClass,
                items: ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5'],
                onChanged: (v) => setState(() => _selectedClass = v!))),
        const SizedBox(width: 12),
        Expanded(
            child: _buildDropdown(
                label: "Section",
                value: _selectedSection,
                items: ['A', 'B', 'C', 'D'],
                onChanged: (v) => setState(() => _selectedSection = v!))),
        const SizedBox(width: 12),
        ElevatedButton(
            onPressed: _getDetails,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2875),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            child: const Text("Get Details")),
      ]);
    });
  }

  Widget _buildDropdown(
      {required String label,
      required String value,
      required List<String> items,
      required ValueChanged<String?> onChanged}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2875))),
      const SizedBox(height: 4),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: const Color(0xFF1E2875).withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(4)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF1E2875)),
                  iconEnabledColor: const Color(0xFF1E2875),
                  items: items
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, overflow: TextOverflow.ellipsis)))
                      .toList(),
                  onChanged: onChanged))),
    ]);
  }

  Widget _buildTimetableGrid() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
      child: Column(
          children: _days.map((day) {
        final periods = _timetable[day] ?? [];
        return Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                width: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    border:
                        Border(right: BorderSide(color: Colors.grey.shade300))),
                child: Text(day,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF1E2875)))),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                            periods.length,
                            (index) => _buildPeriodCell(
                                day, index, periods[index]))))),
          ]),
        );
      }).toList()),
    );
  }

  Widget _buildPeriodCell(String day, int index, Map<String, dynamic> period) {
    return Container(
        width: 140,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey.shade300))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(period['time'],
              style: const TextStyle(fontSize: 10, color: Colors.black87),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(period['subject'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF1E2875)),
              textAlign: TextAlign.center),
          if (period['teacher'].isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(period['teacher'],
                style: const TextStyle(fontSize: 10, color: Colors.black54),
                textAlign: TextAlign.center)
          ],
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _buildActionButton(
                Icons.edit,
                Colors.blue,
                () => _showScheduleDialog(
                    day: day, index: index, period: period)),
            const SizedBox(width: 8),
            _buildActionButton(Icons.delete, Colors.red,
                () => _showDeleteConfirmation(day, index))
          ]),
        ]));
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, size: 14, color: color)));
  }

  void _showScheduleDialog(
      {String? day, int? index, Map<String, dynamic>? period}) {
    String selectedDay = day ?? _days.first;
    String startH = '08', startM = '30', startP = 'AM';
    String endH = '09', endM = '00', endP = 'AM';
    String? selectedSub = period?['subject'];
    String? selectedTeacher = period?['teacher'];

    if (period != null) {
      final times = period['time'].split(' - ');
      final start = times[0].split(' ');
      final end = times[1].split(' ');
      startH = start[0].split(':')[0];
      startM = start[0].split(':')[1];
      startP = start[1];
      endH = end[0].split(':')[0];
      endM = end[0].split(':')[1];
      endP = end[1];
    }

    final List<String> hours =
        List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
    final List<String> minutes =
        List.generate(60, (i) => i.toString().padLeft(2, '0'));
    final List<String> subjects = [
      'Maths',
      'Science',
      'English',
      'Hindi',
      'Telugu',
      'Social',
      'Art',
      'Yoga',
      'Computer'
    ];
    final List<String> teachers = [
      'Ms. Rani',
      'Mr. Rao',
      'Ms. Devi',
      'Mr. Kumar',
      'Mr. Giri Prasad'
    ];

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setModalState) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titlePadding: EdgeInsets.zero,
            title: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Time Table",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 20))
                    ])),
            content: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Week day",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    _buildDialogDropdown(selectedDay, _days,
                        (v) => setModalState(() => selectedDay = v!)),
                    const SizedBox(height: 12),
                    const Text("Class Start Time",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    Row(children: [
                      Expanded(
                          child: _buildDialogDropdown(startH, hours,
                              (v) => setModalState(() => startH = v!))),
                      const Text(" : "),
                      Expanded(
                          child: _buildDialogDropdown(startM, minutes,
                              (v) => setModalState(() => startM = v!))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildDialogDropdown(startP, ['AM', 'PM'],
                              (v) => setModalState(() => startP = v!))),
                    ]),
                    const SizedBox(height: 12),
                    const Text("Class End Time",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    Row(children: [
                      Expanded(
                          child: _buildDialogDropdown(endH, hours,
                              (v) => setModalState(() => endH = v!))),
                      const Text(" : "),
                      Expanded(
                          child: _buildDialogDropdown(startM, minutes,
                              (v) => setModalState(() => endM = v!))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildDialogDropdown(endP, ['AM', 'PM'],
                              (v) => setModalState(() => endP = v!))),
                    ]),
                    const SizedBox(height: 12),
                    const Text("Subject",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    _buildDialogDropdown(selectedSub, subjects,
                        (v) => setModalState(() => selectedSub = v),
                        hint: ""),
                    const SizedBox(height: 12),
                    const Text("Class Teacher",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF1E2875))),
                    const SizedBox(height: 4),
                    _buildDialogDropdown(selectedTeacher, teachers,
                        (v) => setModalState(() => selectedTeacher = v),
                        hint: ""),
                  ]),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2832),
                      foregroundColor: Colors.white),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (selectedSub == null) return;
                    final newData = {
                      'time': '$startH:$startM $startP - $endH:$endM $endP',
                      'subject': selectedSub,
                      'teacher': selectedTeacher ?? ''
                    };
                    setState(() {
                      if (period == null) {
                        _timetable[selectedDay]?.add(newData);
                      } else {
                        _timetable[day]![index!] = newData;
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2875),
                      foregroundColor: Colors.white),
                  child: const Text("Save")),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDialogDropdown(
      String? value, List<String> items, ValueChanged<String?> onChanged,
      {String? hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border:
              Border.all(color: const Color(0xFF1E2875).withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4)),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(color: Color(0xFF1E2875)),
              iconEnabledColor: const Color(0xFF1E2875),
              items: items
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: const TextStyle(fontSize: 13))))
                  .toList(),
              onChanged: onChanged,
              hint: hint != null
                  ? Text(hint, style: const TextStyle(fontSize: 13))
                  : null)),
    );
  }

  void _showDeleteConfirmation(String day, int index) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("Delete Schedule"),
                  content: const Text(
                      "Are you sure you want to delete this schedule?"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _timetable[day]?.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        child: const Text("Delete"))
                  ]));
    });
  }
}
