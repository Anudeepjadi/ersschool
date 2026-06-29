import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/teacher_drawer.dart';
import '../widgets/teacher_bottom_nav.dart';
import '../widgets/teacher_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

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


  // 1. General Meetings Data
  final List<MeetingItem> _meetings = [
    MeetingItem(title: "Class 8 - A Parent Teacher Meeting", category: "Parent Teacher Meeting", date: "24 May 2024", time: "10:00 AM", participants: 12, status: MeetingStatus.upcoming),
    MeetingItem(title: "Staff Meeting", category: "Monthly Staff Meeting", date: "25 May 2024", time: "03:00 PM", participants: 18, status: MeetingStatus.pending),
    MeetingItem(title: "Science Department Meeting", category: "Department Meeting", date: "27 May 2024", time: "11:00 AM", participants: 8, status: MeetingStatus.completed, duration: "45m"),
    MeetingItem(title: "Project Discussion - Grade 10", category: "Academic Discussion", date: "29 May 2024", time: "02:30 PM", participants: 6, status: MeetingStatus.completed, duration: "1h 15m"),
    MeetingItem(title: "School Management Meeting", category: "Management Meeting", date: "31 May 2024", time: "04:00 PM", participants: 15, status: MeetingStatus.upcoming),
  ];




  // Overlay for Live Meeting
  void _showJoinMeetingOverlay(String meetingTitle) {
    bool isMuted = false;
    bool isVideoOff = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setOverlayState) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(meetingTitle, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("Live Session".tr, style: TextStyle(color: Colors.green, fontSize: 12)),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                            child: Text("REC".tr, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: 0.2))),
                        child: Center(
                          child: isVideoOff
                              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam_off, color: Colors.white54, size: 48), SizedBox(height: 8), Text("Video is off".tr, style: TextStyle(color: Colors.white70))])
                              : ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.network('https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400', fit: BoxFit.cover, width: double.infinity, height: double.infinity)),
                        ),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(heroTag: null, backgroundColor: isMuted ? Colors.red : Colors.white24, child: Icon(isMuted ? Icons.mic_off : Icons.mic, color: Colors.white), onPressed: () => setOverlayState(() => isMuted = !isMuted)),
                          FloatingActionButton(heroTag: null, backgroundColor: isVideoOff ? Colors.red : Colors.white24, child: Icon(isVideoOff ? Icons.videocam_off : Icons.videocam, color: Colors.white), onPressed: () => setOverlayState(() => isVideoOff = !isVideoOff)),
                          FloatingActionButton(heroTag: null, backgroundColor: Colors.red, child: Icon(Icons.call_end, color: Colors.white), onPressed: () => Navigator.pop(context)),
                        ],
                      ),
                      SizedBox(height: 24),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: widget.activeTab > 3 ? 0 : widget.activeTab,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFFF5F7FF),
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
            Material(
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
          SizedBox(height: 16),
          // Overview Stats
          SizedBox(
            height: 135,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
          SizedBox(height: 24),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Meetings", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B263B))),
                TextButton(onPressed: () {}, child: Text("View All".tr, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          SizedBox(height: 12),
          _buildMeetingList(_meetings, showJoinButton: true),
          
          SizedBox(height: 24),
          QuickActionsBar(
            actions: [
              QuickActionItem(title: "Schedule Meeting", icon: Icons.add_circle_outline, onTap: () {}), 
              QuickActionItem(title: "Join Meeting", icon: Icons.videocam, onTap: () {}), 
              QuickActionItem(title: "Create Zoom Link", icon: Icons.link, onTap: () {})
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMeetingList(List<MeetingItem> meetings, {bool showJoinButton = false, bool isLog = false, bool showStatusLabel = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: meetings.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final mt = meetings[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              leading: Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: _getStatusColor(mt.status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(isLog ? Icons.history : Icons.videocam_outlined, color: _getStatusColor(mt.status), size: 20)),
              title: Text(mt.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B263B))),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 4),
                Text(isLog ? "Duration: ${mt.duration ?? 'N/A'}" : mt.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calendar_today, size: 10, color: Colors.grey), SizedBox(width: 4), Text("${mt.date} | ${mt.time}", style: TextStyle(fontSize: 10, color: Colors.grey))]),
                    Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.group_outlined, size: 10, color: Colors.grey), SizedBox(width: 4), Text("${mt.participants}", style: TextStyle(fontSize: 10, color: Colors.grey))]),
                  ],
                ),
              ]),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showJoinButton) ElevatedButton(onPressed: () => _showJoinMeetingOverlay(mt.title), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white, minimumSize: Size(50, 26), padding: EdgeInsets.symmetric(horizontal: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))), child: Text("Join".tr, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                  if (showStatusLabel) _buildStatusChip(mt.status),
                  if (isLog) Text("Success".tr, style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
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
    return Container(padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(status.name.toUpperCase(), style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold)));
  }

  Color _getStatusColor(MeetingStatus status) {
    switch (status) {
      case MeetingStatus.completed: return Colors.green;
      case MeetingStatus.pending: return Colors.orange;
      case MeetingStatus.upcoming: return Colors.blue;
      case MeetingStatus.cancelled: return Colors.red;
    }
  }




}
