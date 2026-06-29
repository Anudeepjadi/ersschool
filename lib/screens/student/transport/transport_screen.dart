import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../dashboard/widgets/student_app_bar.dart';
import '../../admin/widgets/ai_bot_fab.dart';
import '../../../widgets/scrollable_table_wrapper.dart';
import '../../../core/utils/profile_manager.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class TransportScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final Function(int)? onTabSelected;

  const TransportScreen({super.key, this.onOpenDrawer, this.onTabSelected});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  int _activeTab = 0; // 0: Transport, 1: Tracking, 2: Route Details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: StudentAppBar(
        title: "Transport",
        subtitle: "View your transport details",
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: AiBotFab(),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              _buildTabItem(0, Icons.directions_bus, "Transport"),
              _buildTabItem(1, Icons.location_on, "Tracking"),
              _buildTabItem(2, Icons.route, "Route Details"),
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isActive = _activeTab == index;
    final Color color = isActive ? AppColors.primary : Color(0xFF6B7280);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 18),
                SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_activeTab == 0) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStudentCard(),
            SizedBox(height: 24),
            _buildLiveTrackingCard(),
            SizedBox(height: 24),
            _buildTransportDetailsSection(),
            SizedBox(height: 24),
            _buildAnnouncementsSection(),
            SizedBox(height: 24),
            _buildQuickActionsSection(),
            SizedBox(height: 16),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_open, size: 48, color: Colors.grey.shade300),
            SizedBox(height: 12),
            Text(
              _activeTab == 1 ? "Live Tracking Map" : "Route Map details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text("This feature is currently under development.".tr,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStudentCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 500;
          Widget imageWidget = Container(
            height: 100,
            width: isWide ? 120 : double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/images/school_bus.png",
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.directions_bus,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
            ),
          );

          final currentStudent = AppDataStore.instance.currentUser;
          final String sName = currentStudent != null
              ? currentStudent['name'] as String
              : ProfileManager().studentName.value;
          final String sClass = currentStudent != null
              ? currentStudent['class'] as String
              : "Class 8 - A";
          final String sPhone = currentStudent != null
              ? "+91 ${currentStudent['phone']}"
              : "+91 98765 12345";

          Widget detailsWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sClass,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildDetailItem(Icons.directions_bus, "Route / Stop", "Route 12 / Green Park Stop"),
                        _buildDetailItem(Icons.badge, "Transport ID", "TRP20260001"),
                        _buildDetailItem(Icons.phone, "Mobile Number", sPhone),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _buildDetailItem(Icons.directions_car, "Vehicle Number", "DL 01 AB 1234"),
                        _buildDetailItem(Icons.person, "Driver Name", "Ramesh Kumar"),
                        _buildDetailItem(Icons.person_outline, "Bus Attendant", "Suresh Yadav"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                SizedBox(width: 16),
                Expanded(child: detailsWidget),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                SizedBox(height: 16),
                detailsWidget,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF1E2875), size: 15),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF1E2875),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("Live Tracking".tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Color(0xFFA7F3D0)),
                    ),
                    child: Row(children: [
                        Icon(Icons.fiber_manual_record, size: 6, color: Color(0xFF10B981)),
                        SizedBox(width: 3),
                        Text("Live".tr,
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _activeTab = 1; // Switch to tracking map tab
                  });
                },
                icon: Icon(Icons.map, size: 12, color: AppColors.primary),
                label: Text("View on Map".tr,
                  style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  side: BorderSide(color: Colors.grey.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
              SizedBox(width: 4),
              Text("Last updated: Today, 09:41 AM".tr,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTrackingTimeline(),
          SizedBox(height: 16),
          // Green Status Banner
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFD1FAE5)),
            ),
            child: Row(children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Your child has been picked up and is on the way to school.".tr,
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    return ScrollableTableWrapper(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineStep(
            Icons.directions_bus,
            "Bus Started",
            "08:10 AM",
            Color(0xFF10B981),
            true,
          ),
          _buildTimelineLine(Color(0xFF10B981)),
          _buildTimelineStep(
            Icons.location_on,
            "Green Park Stop",
            "Picked Up\n08:22 AM",
            Color(0xFF10B981),
            true,
          ),
          _buildTimelineLine(AppColors.primary),
          _buildTimelineStep(
            Icons.location_on,
            "Saket Metro",
            "In Progress\n08:35 AM",
            AppColors.primary,
            true,
          ),
          _buildTimelineLine(Colors.grey.shade300),
          _buildTimelineStep(
            Icons.location_on,
            "AIIMS Signal",
            "Upcoming\n08:50 AM",
            Colors.grey,
            false,
          ),
          _buildTimelineLine(Colors.grey.shade300),
          _buildTimelineStep(
            Icons.school,
            "School",
            "Upcoming\n09:00 AM",
            Colors.grey,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(IconData icon, String title, String subtitle, Color color, bool isActive) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isActive ? color.withValues(alpha: 0.12) : Colors.grey.shade50,
              shape: BoxShape.circle,
              border: Border.all(color: isActive ? color : Colors.grey.shade300, width: 1.5),
            ),
            child: Icon(icon, color: isActive ? color : Colors.grey.shade400, size: 16),
          ),
          SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isActive ? Color(0xFF1E2875) : Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: subtitle.contains("Picked Up") || subtitle.contains("In Progress")
                  ? color
                  : Colors.grey.shade400,
              fontWeight: subtitle.contains("Picked Up") || subtitle.contains("In Progress")
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLine(Color color) {
    return Container(
      margin: EdgeInsets.only(top: 14),
      width: 40,
      height: 2,
      color: color,
    );
  }

  Widget _buildTransportDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Transport Details".tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 550 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.3,
              children: [
                _buildDetailGridItem(Icons.directions_bus, "Bus Type", "AC Bus", Color(0xFF3B82F6)),
                _buildDetailGridItem(Icons.event_seat, "Seat Number", "12", Color(0xFF8B5CF6)),
                _buildDetailGridItem(Icons.alt_route, "Total Stops", "14", Color(0xFF10B981)),
                _buildDetailGridItem(Icons.access_time, "Pickup Time", "08:20 AM", Color(0xFFF59E0B)),
                _buildDetailGridItem(Icons.school, "Drop Time (Est.)", "09:00 AM", Color(0xFFEF4444)),
                _buildDetailGridItem(Icons.straighten, "Distance (Approx.)", "18.6 km", Color(0xFF06B6D4)),
                _buildDetailGridItem(Icons.calendar_today, "Transport Validity", "31 Mar 2027", Color(0xFFEC4899)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailGridItem(IconData icon, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Transport Announcements".tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("All Announcements are up to date.".tr)),
                );
              },
              child: Text("View All".tr,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        _buildAnnouncementTile("Transport Timings Update", "From 20 Jun 2026, pickup time will be 10 minutes earlier.", "18 Jun 2026", Color(0xFF10B981), Color(0xFFECFDF5)),
        _buildAnnouncementTile("Bus Route Change", "Route 12 will take a new route from 25 Jun 2026.", "15 Jun 2026", Color(0xFFF59E0B), Color(0xFFFEF3C7)),
      ],
    );
  }

  Widget _buildAnnouncementTile(String title, String desc, String date, Color color, Color bgColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.campaign, color: color, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(fontSize: 9, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  desc,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Actions".tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildQuickActionItem("Transport ID Card", Icons.badge, Color(0xFFF5F3FF), Color(0xFF7C3AED)),
            _buildQuickActionItem("Report an Issue", Icons.report_problem, Color(0xFFFEE2E2), Color(0xFFEF4444)),
            _buildQuickActionItem("Contact Transport", Icons.phone, Color(0xFFECFDF5), Color(0xFF10B981)),
            _buildQuickActionItem("Transport Rules", Icons.article, Color(0xFFEEF2FF), Color(0xFF3B82F6)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon, Color bgColor, Color iconColor) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opening $title...")),
        );
      },
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
