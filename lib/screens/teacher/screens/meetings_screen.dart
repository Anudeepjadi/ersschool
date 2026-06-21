import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/teacher_drawer.dart';
import '../widgets/teacher_bottom_nav.dart';
import '../widgets/teacher_app_bar.dart';

enum MeetingStatus { completed, pending, upcoming, cancelled }

class MeetingItem {
  final String title;
  final String category;
  final String date;
  final String time;
  final int participants;
  final MeetingStatus status;
  final String? duration;

  MeetingItem({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.participants,
    this.status = MeetingStatus.upcoming,
    this.duration,
  });
}

class MeetingsScreen extends StatefulWidget {
  final int activeTab;
  final Function(int)? onSubTabSelected;

  const MeetingsScreen({
    super.key,
    this.activeTab = 0,
    this.onSubTabSelected,
  });

  @override
  State<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedDateDay = 24; // Default selected day (May 24)
  String? _selectedStatCategory; // "Completed", "Pending", "Total Participants"
  String? _selectedNavCategory; // "Join Meeting", "My Meetings", "Shared Meetings", "Meeting Logs"

  // 1. General Meetings Data
  final List<MeetingItem> _meetings = [
    MeetingItem(title: "Class 8 - A Parent Teacher Meeting", category: "Parent Teacher Meeting", date: "24 May 2024", time: "10:00 AM", participants: 12, status: MeetingStatus.upcoming),
    MeetingItem(title: "Staff Meeting", category: "Monthly Staff Meeting", date: "25 May 2024", time: "03:00 PM", participants: 18, status: MeetingStatus.pending),
    MeetingItem(title: "Science Department Meeting", category: "Department Meeting", date: "27 May 2024", time: "11:00 AM", participants: 8, status: MeetingStatus.completed, duration: "45m"),
    MeetingItem(title: "Project Discussion - Grade 10", category: "Academic Discussion", date: "29 May 2024", time: "02:30 PM", participants: 6, status: MeetingStatus.completed, duration: "1h 15m"),
    MeetingItem(title: "School Management Meeting", category: "Management Meeting", date: "31 May 2024", time: "04:00 PM", participants: 15, status: MeetingStatus.upcoming),
  ];

  // 2. My Meetings Data
  final List<MeetingItem> _myMeetings = [
    MeetingItem(title: "Grade 10 - Maths Extra Class", category: "Personal", date: "25 May 2024", time: "08:00 AM", participants: 20, status: MeetingStatus.upcoming),
    MeetingItem(title: "Paper Correction Sync", category: "Personal", date: "23 May 2024", time: "04:00 PM", participants: 2, status: MeetingStatus.completed),
    MeetingItem(title: "Doubt Clearing Session", category: "Personal", date: "22 May 2024", time: "05:00 PM", participants: 15, status: MeetingStatus.cancelled),
  ];

  // 3. Shared Meetings Data
  final List<MeetingItem> _sharedMeetings = [
    MeetingItem(title: "Annual Day Planning", category: "Admin Shared", date: "26 May 2024", time: "11:00 AM", participants: 50, status: MeetingStatus.upcoming),
    MeetingItem(title: "New Exam Guidelines", category: "HOD Shared", date: "28 May 2024", time: "02:00 PM", participants: 30, status: MeetingStatus.upcoming),
  ];

  // Overlay for Live Meeting
  void _showJoinMeetingOverlay(String meetingTitle) {
    bool isMuted = false;
    bool isVideoOff = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meetingTitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const Text("Live Session", style: TextStyle(color: Colors.green, fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                            child: const Text("REC", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const Spacer(),
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                        child: Center(
                          child: isVideoOff
                              ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam_off, color: Colors.white54, size: 48), SizedBox(height: 8), Text("Video is off", style: TextStyle(color: Colors.white70))])
                              : ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.network('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(heroTag: null, backgroundColor: isMuted ? Colors.red : Colors.white24, child: Icon(isMuted ? Icons.mic_off : Icons.mic, color: Colors.white), onPressed: () => setOverlayState(() => isMuted = !isMuted)),
                          FloatingActionButton(heroTag: null, backgroundColor: isVideoOff ? Colors.red : Colors.white24, child: Icon(isVideoOff ? Icons.videocam_off : Icons.videocam, color: Colors.white), onPressed: () => setOverlayState(() => isVideoOff = !isVideoOff)),
                          FloatingActionButton(heroTag: null, backgroundColor: Colors.red, child: const Icon(Icons.call_end, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showJoinMeetingDialog() {
    final idController = TextEditingController();
    final passwordController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Join Meeting"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: "Meeting ID", hintText: "Enter ID"),
                onChanged: (_) {
                  if (errorMessage != null) setDialogState(() => errorMessage = null);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password", hintText: "Enter Password"),
                obscureText: true,
                onChanged: (_) {
                  if (errorMessage != null) setDialogState(() => errorMessage = null);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (idController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                  setDialogState(() {
                    errorMessage = "Please enter credentials";
                  });
                } else {
                  Navigator.pop(context);
                  _showJoinMeetingOverlay("Meeting ${idController.text}");
                }
              },
              child: const Text("Join"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.activeTab > 3 ? 0 : widget.activeTab,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF5F7FF),
        appBar: TeacherAppBar(
          title: "Meetings",
          subtitle: "Manage your schedule",
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        drawer: TeacherDrawer(
          currentIndex: 5,
          onTabSelected: widget.onSubTabSelected,
        ),
        bottomNavigationBar: TeacherBottomNav(
          currentIndex: 5,
          onTabSelected: (idx) {
            Navigator.pop(context); // Close MeetingsScreen
            if (widget.onSubTabSelected != null) {
              widget.onSubTabSelected!(idx);
            }
          },
        ),
        body: Column(
          children: [
            const Material(
              color: Colors.white,
              elevation: 1,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelPadding: EdgeInsets.symmetric(horizontal: 12),
                dividerColor: Colors.transparent,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: [
                  Tab(text: "Today"),
                  Tab(text: "Upcoming"),
                  Tab(text: "Past"),
                  Tab(text: "All Meetings"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildOverviewTab(),
                  _buildOverviewTab(), // Placeholder for Upcoming
                  _buildOverviewTab(), // Placeholder for Past
                  _buildOverviewTab(), // Placeholder for All Meetings
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Overview Stats
          SizedBox(
            height: 135,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                StatCard(
                  title: "Scheduled Meetings", 
                  value: "8", 
                  icon: Icons.calendar_month, 
                  iconColor: Colors.blue, 
                  iconBackgroundColor: Colors.blue.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Completed Meetings", 
                  value: "45", 
                  icon: Icons.check_circle_outline, 
                  iconColor: Colors.green, 
                  iconBackgroundColor: Colors.green.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Upcoming Meetings", 
                  value: "3", 
                  icon: Icons.hourglass_top, 
                  iconColor: Colors.orange, 
                  iconBackgroundColor: Colors.orange.withValues(alpha: 0.1),
                ),
                StatCard(
                  title: "Total Hours", 
                  value: "120h", 
                  icon: Icons.schedule, 
                  iconColor: Colors.purple, 
                  iconBackgroundColor: Colors.purple.withValues(alpha: 0.1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Meetings", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildMeetingList(_meetings, showJoinButton: true),
          
          const SizedBox(height: 24),
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Schedule Meeting", icon: Icons.add_circle_outline, onTap: () {}), 
              QuickActionItem(title: "Join Meeting", icon: Icons.videocam, onTap: () {}), 
              QuickActionItem(title: "Create Zoom Link", icon: Icons.link, onTap: () {})
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatDetailsList() {
    List<MeetingItem> filtered = [];
    if (_selectedStatCategory == "Completed") {
      filtered = _meetings.where((m) => m.status == MeetingStatus.completed).toList();
    } else if (_selectedStatCategory == "Pending") {
      filtered = _meetings.where((m) => m.status == MeetingStatus.pending).toList();
    } else {
      filtered = _meetings;
    }
    return _buildMeetingList(filtered);
  }

  Widget _buildNavDetailsList() {
    if (_selectedNavCategory == "My Meetings") return _buildMeetingList(_myMeetings, showStatusLabel: true);
    if (_selectedNavCategory == "Shared Meetings") return _buildMeetingList(_sharedMeetings, showJoinButton: true);
    if (_selectedNavCategory == "Meeting Logs") return _buildMeetingList(_meetings.where((m) => m.status == MeetingStatus.completed).toList(), isLog: true);
    return const SizedBox();
  }

  Widget _buildMeetingList(List<MeetingItem> meetings, {bool showJoinButton = false, bool isLog = false, bool showStatusLabel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meetings.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final mt = meetings[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _getStatusColor(mt.status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(isLog ? Icons.history : Icons.videocam_outlined, color: _getStatusColor(mt.status), size: 20)),
              title: Text(mt.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B))),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 4),
                Text(isLog ? "Duration: ${mt.duration ?? 'N/A'}" : mt.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.calendar_today, size: 10, color: Colors.grey), const SizedBox(width: 4), Text("${mt.date} • ${mt.time}", style: const TextStyle(fontSize: 10, color: Colors.grey))]),
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.group_outlined, size: 10, color: Colors.grey), const SizedBox(width: 4), Text("${mt.participants}", style: const TextStyle(fontSize: 10, color: Colors.grey))]),
                  ],
                ),
              ]),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showJoinButton) ElevatedButton(onPressed: () => _showJoinMeetingOverlay(mt.title), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white, minimumSize: const Size(50, 26), padding: const EdgeInsets.symmetric(horizontal: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text("Join", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                  if (showStatusLabel) _buildStatusChip(mt.status),
                  if (isLog) const Text("Success", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(MeetingStatus status) {
    Color color = _getStatusColor(status);
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)));
  }

  Color _getStatusColor(MeetingStatus status) {
    switch (status) {
      case MeetingStatus.completed: return Colors.green;
      case MeetingStatus.pending: return Colors.orange;
      case MeetingStatus.upcoming: return Colors.blue;
      case MeetingStatus.cancelled: return Colors.red;
    }
  }

  Widget _buildNavButton(String title, IconData icon, Color color, VoidCallback onTap, {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(color: isSelected ? color.withValues(alpha: 0.05) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? color : Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))]),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)), const SizedBox(width: 8), Expanded(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? color : const Color(0xFF1B263B))))])),
      ),
    );
  }

  Widget _buildScheduleMeetingTab() {
    final List<MeetingItem> upcoming = _meetings.where((m) => m.status == MeetingStatus.upcoming).toList();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming Meetings (${upcoming.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
                TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcoming.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final mt = upcoming[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)), child: Icon(Icons.videocam_outlined, color: Colors.blue[800], size: 20)),
                    title: Text(mt.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B))),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 4),
                      Text(mt.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.calendar_today, size: 10, color: Colors.grey), const SizedBox(width: 4), Text("${mt.date} • ${mt.time}", style: const TextStyle(fontSize: 10, color: Colors.grey))]),
                          Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.group_outlined, size: 10, color: Colors.grey), const SizedBox(width: 4), Text("${mt.participants}", style: const TextStyle(fontSize: 10, color: Colors.grey))]),
                        ],
                      ),
                    ]),
                    trailing: ElevatedButton(onPressed: () => _showJoinMeetingOverlay(mt.title), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white, minimumSize: const Size(50, 26), padding: const EdgeInsets.symmetric(horizontal: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: const Text("Join", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildCalendarSection(),
          const SizedBox(height: 24),
          _buildScheduleSection(),
          const SizedBox(height: 20),
          QuickActionsBar(actions: [QuickActionItem(title: "Schedule Meeting", icon: Icons.add_circle_outline, onTap: () {}), QuickActionItem(title: "View Calendar", icon: Icons.calendar_month, onTap: () {}), QuickActionItem(title: "Meeting History", icon: Icons.history, onTap: () {})]),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarSection(),
          const SizedBox(height: 16),
          _buildScheduleSection(),
          const SizedBox(height: 20),
          QuickActionsBar(actions: [QuickActionItem(title: "View Calendar", icon: Icons.calendar_month, onTap: () {}), QuickActionItem(title: "Meeting History", icon: Icons.history, onTap: () {})]),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Calendar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                child: Row(children: [const Text("May 2024", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(width: 8), Icon(Icons.keyboard_arrow_left, size: 16, color: Colors.grey[600]), Icon(Icons.keyboard_arrow_right, size: 16, color: Colors.grey[600])]),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].map((day) => Expanded(child: Center(child: Text(day, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey))))).toList()),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [19, 20, 21, 22, 23, 24, 25].map((n) => _buildCalendarDayNumber(n)).toList()),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [26, 27, 28, 29, 30, 31, 1].map((n) => _buildCalendarDayNumber(n, isNextMonth: n == 1)).toList()),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    final String selectedDateString = "$selectedDateDay May 2024";
    final selectedDayMeetings = _meetings.where((mt) => mt.date == selectedDateString).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Schedule for $selectedDateString", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          selectedDayMeetings.isEmpty
              ? Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)), child: const Center(child: Text("No meetings scheduled", style: TextStyle(color: Colors.grey, fontSize: 12))))
              : Column(children: selectedDayMeetings.map((mt) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey[200]!)),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(mt.time, style: TextStyle(color: Colors.blue[800], fontSize: 11, fontWeight: FontWeight.bold)), const Text("1h Duration", style: TextStyle(color: Colors.grey, fontSize: 9))]),
              const SizedBox(width: 12),
              Container(height: 24, width: 1, color: Colors.grey[300]),
              const SizedBox(width: 12),
              const Icon(Icons.videocam, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(mt.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))), Text(mt.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.grey))])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)), child: Text("Upcoming", style: TextStyle(color: Colors.blue[800], fontSize: 9, fontWeight: FontWeight.bold))),
            ]),
          )).toList()),
        ],
      ),
    );
  }

  Widget _buildCalendarDayNumber(int num, {bool isNextMonth = false}) {
    final isSelected = num == selectedDateDay && !isNextMonth;
    return Expanded(child: InkWell(onTap: isNextMonth ? null : () => setState(() => selectedDateDay = num), child: Container(alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: isSelected ? Colors.blue[800] : Colors.transparent, shape: BoxShape.circle), child: Text("$num", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isNextMonth ? Colors.grey[300] : (isSelected ? Colors.white : Colors.black87))))));
  }
}