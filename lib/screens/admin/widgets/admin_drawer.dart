import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../login/login_screen.dart' show LoginScreen;

import '../screens/admin_attendance_screen.dart';
import '../screens/admin_examinations_screen.dart';

import '../screens/admin_id_cards_screen.dart';
import '../screens/admin_invalid_info_screen.dart';
import '../screens/admin_sms_screen.dart';
import '../screens/admin_settings_screen.dart';
import '../screens/admin_help_center_screen.dart';
import '../screens/admin_chat_support_screen.dart';
import '../screens/admin_system_updates_screen.dart';
import '../screens/admin_video_tutorials_screen.dart';
import '../screens/admin_about_us_screen.dart';
import '../screens/admin_meetings_screen.dart';


import '../screens/student_management/admin_student_list_screen.dart';
import '../screens/student_management/admin_register_student_screen.dart';
import '../screens/student_management/admin_student_promotions_screen.dart';
import '../screens/student_management/admin_student_siblings_screen.dart';
import '../screens/admin_employee_list_screen.dart';

import '../screens/admin_employee_id_cards_screen.dart';
import '../screens/admin_assignments_screen.dart';
import '../screens/admin_class_details_screen.dart';
import '../screens/admin_class_teachers_screen.dart';
import '../screens/admin_diary_screen.dart';
import '../screens/admin_time_table_screen.dart';

import '../screens/reports/holidays_list_report_screen.dart';
import '../screens/reports/fee_structure_report_screen.dart';
import '../screens/reports/fee_collection_summary_screen.dart';
import '../screens/reports/fee_due_list_screen.dart';
import '../screens/reports/fee_collection_by_date_screen.dart';
import '../screens/reports/class_attendance_report_screen.dart';
import '../screens/transport/admin_vehicle_details_screen.dart';
import '../screens/transport/admin_drivers_list_screen.dart';
import '../screens/transport/admin_transport_students_route_screen.dart';
import '../screens/transport/admin_transport_students_class_screen.dart';

import '../admin_dashboard_screen.dart';

class AdminDrawer extends StatelessWidget {
  final int? currentIndex;
  final Function(int)? onTabSelected;

  const AdminDrawer({
    super.key,
    this.currentIndex,
    this.onTabSelected,
  });

  void _navigateOrChangeTab(BuildContext context, int index) {
    if (onTabSelected != null) {
      onTabSelected!(index);
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (_) => AdminDashboardScreen(initialIndex: index)),
        (route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              bottom: 18,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ValueListenableBuilder<String?>(
                        valueListenable: ProfileManager().adminProfileImagePath,
                        builder: (context, path, _) {
                          return CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            backgroundImage: path != null ? FileImage(File(path)) : null,
                            child: path == null ? const Icon(Icons.person, color: AppColors.primary, size: 36) : null,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: ProfileManager().adminName,
                            builder: (context, name, _) {
                              return Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Super Administrator",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PopupMenuButton<String>(
                  onSelected: (String school) {
                    debugPrint("AdminDrawer selected school: $school");
                    ProfileManager().selectedSchool.value = school;
                  },
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Ecstasy School 1',
                      child: Text('Ecstasy School 1', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Ecstasy School 2',
                      child: Text('Ecstasy School 2', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Ecstasy School 3',
                      child: Text('Ecstasy School 3', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: ValueListenableBuilder<String>(
                      valueListenable: ProfileManager().selectedSchool,
                      builder: (context, selectedSchool, _) {
                        return Row(
                          children: [
                            const Icon(Icons.school_outlined, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedSchool,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 18,
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
          
          // MAIN Section
          _buildDrawerSectionTitle("MAIN"),
          _buildDrawerItem(Icons.grid_view_outlined, "Dashboard", currentIndex == 0, () {
            _navigateOrChangeTab(context, 0);
          }),
          


          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.people_alt_outlined, color: Color(0xFF757897)),
              title: const Text("Students", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Students List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentListScreen()));
                }),
                _buildDrawerSubItem("Register New Student", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRegisterStudentScreen()));
                }),
                _buildDrawerSubItem("Student Promotions", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentPromotionsScreen()));
                }),
                _buildDrawerSubItem("Student Siblings", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentSiblingsScreen()));
                }),
                _buildDrawerSubItem("Student ID Cards", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
                }),
              ],
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.people_outline, color: Color(0xFF757897)),
              title: const Text("Employee", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Employees List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Employee')));
                }),
                _buildDrawerSubItem("Teachers List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Teacher')));
                }),
                _buildDrawerSubItem("Attender/Aaya List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeListScreen(staffType: 'Attender')));
                }),
                _buildDrawerSubItem("Employee ID Cards", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeIDCardsScreen()));
                }),
              ],
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.corporate_fare_outlined, color: Color(0xFF757897)),
              title: const Text("Branches", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Branches List", false, () {
                  _navigateOrChangeTab(context, 3);
                }),
              ],
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.class_outlined, color: Color(0xFF757897)),
              title: const Text("Classes", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Assignments", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAssignmentsScreen()));
                }),
                _buildDrawerSubItem("Attendance", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
                }),
                _buildDrawerSubItem("Class Details", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassDetailsScreen()));
                }),
                _buildDrawerSubItem("Class Teachers", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassTeachersScreen()));
                }),
                _buildDrawerSubItem("Diary", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDiaryScreen()));
                }),
                _buildDrawerSubItem("Time Table", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTimeTableScreen()));
                }),
              ],
            ),
          ),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.calendar_today_outlined, color: Color(0xFF757897)),
              title: const Text("Attendance", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Attendance View", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAttendanceScreen()));
                }),
              ],
            ),
          ),
          
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.video_camera_front_outlined, color: Color(0xFF757897)),
              title: const Text("Meetings", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Schedule Online Meeting", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AdminMeetingsScreen(initialFeature: MeetingsFeature.schedule),
                  ));
                }),
                _buildDrawerSubItem("Calendar", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const AdminMeetingsScreen(initialFeature: MeetingsFeature.calendar),
                  ));
                }),
              ],
            ),
          ),
          

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.assignment_outlined, color: Color(0xFF757897)),
              title: const Text("Examination", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Exam Details", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examDetails)));
                }),
                _buildDrawerSubItem("Exam Timetable", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examTimetable)));
                }),
                _buildDrawerSubItem("Exam Hall Tickets", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.examHallTickets)));
                }),
                _buildDrawerSubItem("Grade Report", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.gradeReport)));
                }),
                _buildDrawerSubItem("Grade Report Custom", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminExaminationsScreen(initialFeature: ExaminationFeature.gradeReportCustom)));
                }),
              ],
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.directions_bus_outlined, color: Color(0xFF757897)),
              title: const Text("Transport", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Vehicle Details", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminVehicleDetailsScreen()));
                }),
                _buildDrawerSubItem("Drivers", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDriversListScreen()));
                }),
                _buildDrawerSubItem("Students by Route", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTransportStudentsRouteScreen()));
                }),
                _buildDrawerSubItem("Students by Class", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTransportStudentsClassScreen()));
                }),
              ],
            ),
          ),

          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.badge_outlined, color: Color(0xFF757897)),
              title: const Text("ID Card", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Student ID Cards", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminIDCardsScreen()));
                }),
                _buildDrawerSubItem("Employee ID Cards", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeIDCardsScreen()));
                }),
              ],
            ),
          ),

          
          // Reports Item
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.assessment_outlined, color: Color(0xFF757897)),
              title: const Text("Reports", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [

                _buildDrawerSubItem("Holidays List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HolidaysListReportScreen()));
                }),
                _buildDrawerSubItem("Fee Structure", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeStructureReportScreen()));
                }),
                _buildDrawerSubItem("Fee Collection", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeCollectionSummaryScreen()));
                }),
                _buildDrawerSubItem("Tuition Fee Due", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeDueListScreen(reportTitle: "Tuition Fee Due Students")));
                }),
                _buildDrawerSubItem("Transport Fee Due", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeDueListScreen(reportTitle: "Transport Fee Due Students")));
                }),
                _buildDrawerSubItem("Collection By Date", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeeCollectionByDateScreen()));
                }),
                _buildDrawerSubItem("Attendance Report", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassAttendanceReportScreen()));
                }),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.error_outline, color: Color(0xFF757897)),
              title: const Text("Invalid Info", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("Invalid Info List", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminInvalidInfoScreen()));
                }),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.sms_outlined, color: Color(0xFF757897)),
              title: const Text("SMS", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("SMS Settings", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSmsScreen()));
                }),
              ],
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: const Icon(Icons.settings_outlined, color: Color(0xFF757897)),
              title: const Text("Settings", style: TextStyle(
                color: Color(0xFF1E2875),
                fontWeight: FontWeight.w500,
                fontSize: 13,
              )),
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              childrenPadding: EdgeInsets.zero,
              children: [
                _buildDrawerSubItem("App Settings", false, () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingsScreen()));
                }),
              ],
            ),
          ),

          const Divider(height: 20),

          // SUPPORT Section
          _buildDrawerSectionTitle("SUPPORT"),
          _buildDrawerItem(Icons.help_outline, "Help Center", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminHelpCenterScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.headset_mic_outlined, "Chat Support", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminChatSupportScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.cloud_download_outlined, "System Updates", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSystemUpdatesScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.play_circle_outline, "Video Tutorials", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminVideoTutorialsScreen()));
          }, showChevron: false),
          _buildDrawerItem(Icons.info_outline, "About Us", false, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAboutUsScreen()));
          }, showChevron: false),

          const Divider(height: 20),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback onTap, {
    bool showChevron = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : const Color(0xFF757897), size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
      trailing: showChevron
          ? const Icon(Icons.chevron_right, size: 16, color: Colors.grey)
          : null,
      selected: selected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      minLeadingWidth: 24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildDrawerSubItem(String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 5, color: Color(0xFF9098B1)),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primary : const Color(0xFF1E2875),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 12.5,
        ),
      ),
      onTap: onTap,
      dense: true,
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      minLeadingWidth: 24,
      visualDensity: const VisualDensity(vertical: -2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

}
