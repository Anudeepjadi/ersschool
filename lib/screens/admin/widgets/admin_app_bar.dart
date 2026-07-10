import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../../core/localization/language_manager.dart';
import '../tabs/admin_more_tab.dart';
import '../admin_dashboard_screen.dart';

// Import necessary screens for navigation
import '../screens/student_management/admin_register_student_screen.dart';
import '../screens/student_management/admin_student_list_screen.dart';
import '../screens/student_management/admin_student_promotions_screen.dart';
import '../screens/student_management/admin_student_siblings_screen.dart';
import '../screens/admin_class_details_screen.dart';
import '../screens/admin_class_teachers_screen.dart';
import '../screens/admin_time_table_screen.dart';

import '../screens/admin_employee_list_screen.dart';
import '../screens/admin_employee_id_cards_screen.dart';
import '../screens/admin_id_cards_screen.dart';
import '../screens/admin_meetings_screen.dart';
import '../screens/admin_examinations_screen.dart';
import '../screens/transport/admin_vehicle_details_screen.dart';
import '../screens/transport/admin_drivers_list_screen.dart';
import '../screens/transport/admin_transport_students_class_screen.dart';
import '../screens/transport/admin_transport_students_route_screen.dart';
import '../screens/reports/fee_collection_summary_screen.dart';
import '../screens/reports/class_attendance_report_screen.dart';
import '../screens/admin_attendance_screen.dart';
import '../screens/admin_diary_screen.dart';
import '../screens/admin_assignments_screen.dart';
import '../screens/admin_invalid_info_screen.dart';
import '../screens/admin_sms_screen.dart';
import '../screens/admin_settings_screen.dart';
import '../screens/reports/holidays_list_report_screen.dart';
import '../screens/reports/fee_structure_report_screen.dart';
import '../screens/reports/fee_due_list_screen.dart';
import '../screens/reports/fee_collection_by_date_screen.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;
  final bool showSchoolSelector;

  const AdminAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.onOpenDrawer,
    this.onProfileTap,
    this.actions,
    this.showSchoolSelector = true,
  });

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    if (isDesktop) {
      return AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 72,
        automaticallyImplyLeading: false, // hide back button on web top nav
        title: Row(
          children: [
            // Circular Logo
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/applogo.png',
                  height: 44, // Increased size to make text more visible
                  width: 44,
                  fit: BoxFit.contain, // Use contain to prevent clipping of text
                  errorBuilder: (c, e, s) {
                    return Image.asset(
                      'assets/images/loginscreenlogo.png',
                      height: 44,
                      width: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(Icons.school, color: AppColors.primary, size: 36),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            const Text('Ecstasy School', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
            const SizedBox(width: 24),
            // Navigation Links
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildWebNavItem(context, 'Home', false, () {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen(initialIndex: 0)), (r) => false);
                      }),
                      _buildWebNavDropdown(context, 'Student', [
                        _MenuItem('Register Student', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen()))),
                        _MenuItem('Student List', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentListScreen()))),
                        _MenuItem('Student Promotions', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentPromotionsScreen()))),
                        _MenuItem('Sibling Mapping', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentSiblingsScreen()))),
                      ]),
                      _buildWebNavDropdown(context, 'Class', [
                        _MenuItem('Class Routine', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTimeTableScreen()))),
                        _MenuItem('Attendance', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()))),
                        _MenuItem('Diary', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDiaryScreen()))),
                        _MenuItem('Class Details', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassDetailsScreen()))),
                        _MenuItem('Assignments', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAssignmentsScreen()))),
                        _MenuItem('Class Teachers', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassTeachersScreen()))),
                      ]),
                      _buildWebNavDropdown(context, 'Employee', [
                        _MenuItem('Employees', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Employee')))),
                        _MenuItem('Teachers', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Teacher')))),
                        _MenuItem('Attender/Aaya', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Attender')))),
                      ]),
                      _buildWebNavDropdown(context, 'Meetings', [
                        _MenuItem('Schedule Online Meeting', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMeetingsScreen(initialFeature: MeetingsFeature.schedule)))),
                        _MenuItem('Calendar', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMeetingsScreen(initialFeature: MeetingsFeature.calendar)))),
                      ]),
                      _buildWebNavDropdown(context, 'Examination', [
                        _MenuItem('Exam Details', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examDetails)))),
                        _MenuItem('Exam Timetable', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examTimetable)))),
                        _MenuItem('Exam Hall Tickets', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examHallTickets)))),
                        _MenuItem('Grade Report', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.gradeReport)))),
                        _MenuItem('Grade Report Custom', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.gradeReportCustom)))),
                      ]),
                      _buildWebNavDropdown(context, 'Transport', [
                        _MenuItem('Vehicle Details', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminVehicleDetailsScreen()))),
                        _MenuItem('Drivers List', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDriversListScreen()))),
                        _MenuItem('Students by Route', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTransportStudentsRouteScreen()))),
                        _MenuItem('Students by Class', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTransportStudentsClassScreen()))),
                      ]),
                      _buildWebNavDropdown(context, 'Reports', [
                        _MenuItem('Holidays List', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HolidaysListReportScreen()))),
                        _MenuItem('Fee Structure', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeStructureReportScreen()))),
                        _MenuItem('Fee Collection', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeCollectionSummaryScreen()))),
                        _MenuItem('Tuition Fee Due', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeDueListScreen(reportTitle: "Tuition Fee Due Students")))),
                        _MenuItem('Transport Fee Due', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeDueListScreen(reportTitle: "Transport Fee Due Students")))),
                        _MenuItem('Fee Paid By date', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeCollectionByDateScreen()))),
                        _MenuItem('Students Attendance Rept', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassAttendanceReportScreen()))),
                      ]),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Chat Icon
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white), 
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSmsScreen()));
            },
          ),
          // Monitoring Icon
          IconButton(
            icon: const Icon(Icons.monitor_heart_outlined, color: Colors.white), 
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminInvalidInfoScreen()));
            },
          ),
          // Settings Icon
          IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingsScreen()));
          }),
          // User Profile
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 8),
            child: GestureDetector(
              onTap: onProfileTap ?? () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMoreTab()));
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: ValueListenableBuilder<String?>(
                  valueListenable: ProfileManager().adminProfileImagePath,
                  builder: (context, path, _) {
                    return CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      backgroundImage: (!kIsWeb && path != null) ? FileImage(File(path)) : null,
                      child: (kIsWeb || path == null) ? Icon(Icons.person, color: AppColors.primary, size: 24) : null,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }

    // MOBILE LAYOUT (Current implementation)
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 48,
      leading: leading ?? 
          (onOpenDrawer != null
              ? IconButton(
                  icon: const Icon(Icons.menu, size: 26, color: Colors.white),
                  onPressed: onOpenDrawer,
                )
              : (Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle.tr,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: actions ?? [
        // Notification bell with badge 5
        Stack(
          alignment: Alignment.center,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
              offset: const Offset(0, 45),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'mails',
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mail_outline, color: AppColors.primary, size: 20)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Support Mails'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text('12 unread queries'.tr, style: const TextStyle(fontSize: 11, color: Colors.grey))]),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 6,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                child: Text('5'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        // User profile photo
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: GestureDetector(
            onTap: onProfileTap ?? () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMoreTab()));
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ValueListenableBuilder<String?>(
                valueListenable: ProfileManager().adminProfileImagePath,
                builder: (context, path, _) {
                  return CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: (!kIsWeb && path != null) ? FileImage(File(path)) : null,
                    child: (kIsWeb || path == null) ? Icon(Icons.person, color: AppColors.primary, size: 20) : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
      bottom: showSchoolSelector
          ? PreferredSize(
              preferredSize: const Size.fromHeight(24),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(), // Empty space on left
                    // School Selector Pill moved below notifications
                    PopupMenuButton<String>(
                      onSelected: (String school) {
                        debugPrint('AdminAppBar selected school: $school');
                        ProfileManager().selectedSchool.value = school;
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Ecstasy School 1',
                          child: Text('Ecstasy School 1'.tr, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: ProfileManager().selectedSchool,
                          builder: (context, selectedSchool, _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.school, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  selectedSchool,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  size: 14,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(24),
              child: SizedBox(height: 24),
            ),
    );
  }

  Widget _buildWebNavItem(BuildContext context, String title, bool hasDropdown, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Text(title.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            if (hasDropdown)
              const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildWebNavDropdown(BuildContext context, String title, List<_MenuItem> items) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      color: Colors.white,
      tooltip: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Text(title.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            const Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item.title,
            onTap: item.onTap,
            child: Text(item.title.tr, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          );
        }).toList();
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _MenuItem {
  final String title;
  final VoidCallback onTap;
  _MenuItem(this.title, this.onTap);
}
