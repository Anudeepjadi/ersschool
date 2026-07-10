import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import '../widgets/admin_drawer.dart';

enum MeetingsFeature {
  menu,
  schedule,
  calendar,
}

class AdminMeetingsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final MeetingsFeature initialFeature;

  const AdminMeetingsScreen({
    super.key,
    this.onOpenDrawer,
    this.initialFeature = MeetingsFeature.menu,
  });

  @override
  State<AdminMeetingsScreen> createState() => AdminMeetingsScreenState();
}

class AdminMeetingsScreenState extends State<AdminMeetingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late MeetingsFeature _selectedFeature;
  MeetingsFeature _previousFeature = MeetingsFeature.menu;

  // Schedule Meeting states
  String _selectedBranch = 'Ecstasy School 1';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _startDate = DateTime(2026, 6, 29);
  DateTime _endDate = DateTime(2026, 6, 29);

  String _startHour = '09';
  String _startMinute = '00';
  String _startPeriod = 'AM';

  String _endHour = '10';
  String _endMinute = '00';
  String _endPeriod = 'AM';

  String _requiredPeople = 'Everyone';
  bool _reqAllEmployee = false;
  bool _reqAllTeachers = false;
  bool _reqAllStudents = false;
  String _reqClass = 'All';
  String _reqSection = 'All';

  // Calendar states
  String _calendarBranch = 'Ecstasy School 1 (ECS001)';
  DateTime _calendarMonth = DateTime(2026, 6);

  // List of events (mocked)
  final List<Map<String, dynamic>> _events = [
    {
      'date': DateTime(2026, 6, 2),
      'title': '09:00 AM - 10:00 AM meeting',
    }
  ];

  // Options
  final List<String> _branches = [
    'Ecstasy School 1',
    'Ecstasy School 2',
    'Ecstasy School 3'
  ];
  final List<String> _calendarBranches = [
    'Ecstasy School 1 (ECS001)',
    'Ecstasy School 2 (ECS002)',
    'Ecstasy School 3 (ECS003)'
  ];

  @override
  void initState() {
    super.initState();
    _selectedFeature = widget.initialFeature;
  }

  void selectFeature(MeetingsFeature feature) {
    setState(() {
      _selectedFeature = feature;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _getFeatureTitle() {
    switch (_selectedFeature) {
      case MeetingsFeature.menu:
        return "Meetings";
      case MeetingsFeature.schedule:
        return "Meeting Schedule";
      case MeetingsFeature.calendar:
        return "Events/Meetings";
    }
  }

  String _getFeatureSubtitle() {
    switch (_selectedFeature) {
      case MeetingsFeature.menu:
        return "Select a feature to continue";
      case MeetingsFeature.schedule:
        return "Schedule new online meetings and alerts";
      case MeetingsFeature.calendar:
        return "Interactive events and meetings calendar";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F7FF),
      bottomNavigationBar: widget.onOpenDrawer == null
          ? AdminBottomNavBar(currentIndex: 4)
          : null,
      drawer: const AdminDrawer(),
      appBar: AdminAppBar(
        title: _getFeatureTitle(),
        subtitle: _getFeatureSubtitle(),
        leading: _selectedFeature != MeetingsFeature.menu
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedFeature = MeetingsFeature.menu;
                  });
                },
              )
            : null,
        onOpenDrawer: widget.onOpenDrawer ??
            () => _scaffoldKey.currentState?.openDrawer(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildSelectedBody(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedBody() {
    switch (_selectedFeature) {
      case MeetingsFeature.menu:
        return _buildMainMenuView();
      case MeetingsFeature.schedule:
        return _buildScheduleView();
      case MeetingsFeature.calendar:
        return _buildCalendarView();
    }
  }

  Widget _buildMainMenuView() {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'Schedule Online Meeting', 'feature': MeetingsFeature.schedule},
      {'title': 'Calendar', 'feature': MeetingsFeature.calendar},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menuItems.map((item) {
          final index = menuItems.indexOf(item);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                title: Text(
                  (item['title'] as String).tr,
                  style: const TextStyle(
                    color: Color(0xFF1E2875),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
                onTap: () {
                  setState(() {
                    _previousFeature = MeetingsFeature.menu;
                    _selectedFeature = item['feature'] as MeetingsFeature;
                  });
                },
              ),
              if (index < menuItems.length - 1)
                Divider(height: 1, color: Colors.grey.shade200),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ─── 1. SCHEDULE ONLINE MEETING ────────────────────────────────────────────
  Widget _buildScheduleView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row with Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Dark slate/black
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  setState(() {
                    _selectedFeature = _previousFeature;
                  });
                },
                child: Text("Close".tr,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade600,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  if (_titleController.text.isNotEmpty) {
                    setState(() {
                      _events.add({
                        'date': _startDate,
                        'title':
                            "$_startHour:$_startMinute $_startPeriod ${_titleController.text}",
                      });
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Meeting scheduled successfully!".tr),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  setState(() {
                    _selectedFeature = _previousFeature;
                    _titleController.clear();
                    _descriptionController.clear();
                  });
                },
                child: Text("Save".tr,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Branch Dropdown
          _buildFormDropdown(
            label: "Branch",
            value: _selectedBranch,
            items: _branches,
            onChanged: (val) => setState(() => _selectedBranch = val!),
          ),
          const SizedBox(height: 16),

          // Title
          _buildFormTextField(
            label: "Title",
            controller: _titleController,
            hint: "Enter meeting title".tr,
          ),
          const SizedBox(height: 16),

          // Description
          _buildFormTextField(
            label: "Description",
            controller: _descriptionController,
            hint: "Enter meeting details/agenda".tr,
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          // Dates & Timings - stacked vertically to avoid overflow
          _buildFormDatePicker(
            label: "Start Date",
            date: _startDate,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _startDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => _startDate = date);
              }
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Start Time",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildTimeDropdown('start'),
                ],
              )),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormDatePicker(
            label: "End Date",
            date: _endDate,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _endDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                setState(() => _endDate = date);
              }
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("End Time",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildTimeDropdown('end'),
                ],
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Required People section
          Text(
            "Required People".tr,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Radio buttons
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRadioOption('Everyone'),
                    _buildRadioOption('Specific People'),
                    _buildRadioOption('Class Students'),
                  ],
                ),
              ),
              // Right side: Conditionally rendered options
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_requiredPeople == 'Specific People') ...[
                      _buildCheckboxOption('All Employee', _reqAllEmployee,
                          (v) => setState(() => _reqAllEmployee = v!)),
                      _buildCheckboxOption('All Teachers', _reqAllTeachers,
                          (v) => setState(() => _reqAllTeachers = v!)),
                      _buildCheckboxOption('All Students', _reqAllStudents,
                          (v) => setState(() => _reqAllStudents = v!)),
                    ],
                    if (_requiredPeople == 'Class Students') ...[
                      _buildFormDropdown(
                        label: "Class",
                        value: _reqClass,
                        items: ['All', 'Class 1', 'Class 2', 'Class 3'],
                        onChanged: (val) => setState(() => _reqClass = val!),
                      ),
                      const SizedBox(height: 12),
                      _buildFormDropdown(
                        label: "Section",
                        value: _reqSection,
                        items: ['All', 'A', 'B', 'C'],
                        onChanged: (val) => setState(() => _reqSection = val!),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    final isSelected = _requiredPeople == value;
    return GestureDetector(
      onTap: () => setState(() => _requiredPeople = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Text(value.tr,
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(title.tr,
              style: const TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildTimeDropdown(String prefix) {
    final List<String> hours =
        List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
    final List<String> minutes =
        List.generate(12, (i) => (i * 5).toString().padLeft(2, '0'));
    final List<String> periods = ['AM', 'PM'];

    final isStart = prefix == 'start';
    final selectedHour = isStart ? _startHour : _endHour;
    final selectedMinute = isStart ? _startMinute : _endMinute;
    final selectedPeriod = isStart ? _startPeriod : _endPeriod;

    return Row(
      children: [
        // Hour
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedHour,
                style: const TextStyle(fontSize: 11, color: Colors.black),
                onChanged: (v) =>
                    setState(() => isStart ? _startHour = v! : _endHour = v!),
                items: hours
                    .map((h) => DropdownMenuItem(value: h, child: Text(h)))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(":"),
        const SizedBox(width: 4),
        // Minute
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedMinute,
                style: const TextStyle(fontSize: 11, color: Colors.black),
                onChanged: (v) => setState(
                    () => isStart ? _startMinute = v! : _endMinute = v!),
                items: minutes
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Period
        Expanded(
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedPeriod,
                style: const TextStyle(fontSize: 11, color: Colors.black),
                onChanged: (v) => setState(
                    () => isStart ? _startPeriod = v! : _endPeriod = v!),
                items: periods
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormDatePicker({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${date.day}/${date.month}/${date.year}",
                    style: const TextStyle(fontSize: 12)),
                Icon(Icons.calendar_month,
                    color: Colors.grey.shade600, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr,
            style: const TextStyle(
                fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.tr),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ─── 2. CALENDAR VIEW ──────────────────────────────────────────────────────
  Widget _buildCalendarView() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final year = _calendarMonth.year;
    final month = _calendarMonth.month;

    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final weekdayOfFirst = firstDay.weekday % 7;

    final weeksCount = ((daysInMonth + weekdayOfFirst) / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormDropdown(
            label: "Branch",
            value: _calendarBranch,
            items: _calendarBranches,
            onChanged: (val) => setState(() => _calendarBranch = val!),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB308),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          onPressed: () {
                            setState(() {
                              _calendarMonth = DateTime(_calendarMonth.year,
                                  _calendarMonth.month - 1);
                            });
                          },
                          child: Text("< Previous".tr,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          onPressed: () {
                            setState(() {
                              _calendarMonth = DateTime(2026, 6);
                            });
                          },
                          child: Text("Current Month".tr,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB308),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          onPressed: () {
                            setState(() {
                              _calendarMonth = DateTime(_calendarMonth.year,
                                  _calendarMonth.month + 1);
                            });
                          },
                          child: Text("Next >".tr,
                              style: const TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC2410C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      setState(() {
                        _previousFeature = MeetingsFeature.calendar;
                        _selectedFeature = MeetingsFeature.schedule;
                        _titleController.clear();
                        _descriptionController.clear();
                      });
                    },
                    child: Text("Add New".tr,
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "${months[month - 1].tr} $year",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            border: TableBorder.all(color: Colors.grey.shade200),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade50),
                children: [
                  _buildWeekHeaderCell("Sun"),
                  _buildWeekHeaderCell("Mon"),
                  _buildWeekHeaderCell("Tue"),
                  _buildWeekHeaderCell("Wed"),
                  _buildWeekHeaderCell("Thu"),
                  _buildWeekHeaderCell("Fri"),
                  _buildWeekHeaderCell("Sat"),
                ],
              ),
              ...List.generate(weeksCount, (weekIdx) {
                return TableRow(
                  children: List.generate(7, (dayIdx) {
                    final dayCellNum =
                        weekIdx * 7 + dayIdx - weekdayOfFirst + 1;
                    final isValidDay =
                        dayCellNum > 0 && dayCellNum <= daysInMonth;

                    if (!isValidDay) {
                      return TableCell(
                        child: Container(
                          height: 80,
                          color: Colors.grey.shade50,
                        ),
                      );
                    }

                    final cellDate = DateTime(year, month, dayCellNum);
                    final cellEvents = _events.where((e) {
                      final eDate = e['date'] as DateTime;
                      return eDate.year == cellDate.year &&
                          eDate.month == cellDate.month &&
                          eDate.day == cellDate.day;
                    }).toList();

                    return TableCell(
                      child: Container(
                        height: 90,
                        padding: const EdgeInsets.all(4),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$dayCellNum",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: cellDate.day == DateTime.now().day &&
                                        cellDate.month ==
                                            DateTime.now().month &&
                                        cellDate.year == DateTime.now().year
                                    ? AppColors.primary
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ...cellEvents.map((evt) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  evt['title'] as String,
                                  style: const TextStyle(
                                      fontSize: 8, color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeaderCell(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        day,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
