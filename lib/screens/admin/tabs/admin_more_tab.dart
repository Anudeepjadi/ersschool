import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../login/login_screen.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/ai_bot_fab.dart';
import '../screens/admin_attendance_screen.dart';
import '../screens/admin_examinations_screen.dart';
import '../screens/admin_transport_screen.dart';
import '../screens/admin_id_cards_screen.dart';
import '../screens/admin_reports_screen.dart';
import '../screens/admin_invalid_info_screen.dart';
import '../screens/admin_sms_screen.dart';
import '../screens/admin_settings_screen.dart';
import '../screens/admin_classes_screen.dart';
import '../screens/admin_meetings_screen.dart';
import 'admin_students_tab.dart';
import 'admin_teachers_tab.dart';
import 'admin_branches_tab.dart';
import '../screens/admin_employee_id_cards_screen.dart';
import 'package:ersschool/core/localization/language_manager.dart';
class AdminMoreTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onOpenProfile;

  const AdminMoreTab({super.key, this.onOpenDrawer, this.onOpenProfile});

  @override
  State<AdminMoreTab> createState() => _AdminMoreTabState();
}

class _AdminMoreTabState extends State<AdminMoreTab> {
  // Profile state variables
  String _adminName = 'Admin User';
  String _adminEmail = 'admin@ecstasyschool.com';
  String _adminPhone = '+91 98765 43210';
  String _adminLocation = 'Hyderabad, Telangana, India';
  
  File? _selectedLocalImage;
  String? _networkImageUrl;
  
  bool _tfaEnabled = true;
  bool _pushNotificationsEnabled = true;
  bool _emailAlertsEnabled = false;
  bool _smsUpdatesEnabled = true;
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _adminName = ProfileManager().adminName.value;
    final path = ProfileManager().adminProfileImagePath.value;
    if (path != null) {
      _selectedLocalImage = File(path);
    }
  }

  // Pick image helper
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedLocalImage = File(image.path);
        });
        ProfileManager().setAdminProfileImage(image.path);
        _showToast("Profile image updated successfully!");
      }
    } catch (e) {
      _showToast("Error picking image: $e");
    }
  }

  // Toast notifier
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Simulated Camera view overlay
  void _openSimulatedCamera() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  // Viewfinder container
                  Positioned.fill(
                    child: Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 120, color: Colors.white24),
                            SizedBox(height: 16),
                            Text("CAMERA VIEWFINDER ACTIVE".tr,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Grid Overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white12, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(height: 1, color: Colors.white12),
                            Container(height: 1, color: Colors.white12),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(width: 1, color: Colors.white12),
                          Container(width: 1, color: Colors.white12),
                        ],
                      ),
                    ),
                  ),

                  // Autofocus frame indicator
                  Center(
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.greenAccent, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Header bar
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 10,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                            Icon(Icons.flash_off, color: Colors.white),
                            SizedBox(width: 16),
                            Icon(Icons.hdr_on, color: Colors.white),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  // Camera Shutter Button Bar
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text("Focus locked. Tap shutter to capture.".tr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Gallery Icon
                            Icon(Icons.photo_library, color: Colors.white, size: 28),
                            // Shutter
                            GestureDetector(
                              onTap: () {
                                // Close simulated camera, update profile photo to a different portrait matching the layout
                                Navigator.pop(context);
                                setState(() {
                                  _selectedLocalImage = null; // Clear picked
                                  _networkImageUrl = null; // Removed demo image
                                });
                                _showToast("Photo captured successfully via simulated camera!");
                              },
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            // Switch camera
                            Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Camera access bottom sheet picker
  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Choose Profile Picture Source".tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppColors.primary),
                  title: Text("Take Photo (Physical Camera)".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: AppColors.primary),
                  title: Text("Choose from Gallery".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.linked_camera_outlined, color: Colors.blue),
                  title: Text("Simulate Camera Viewfinder".tr),
                  subtitle: Text("Interactive mock camera capture".tr),
                  onTap: () {
                    Navigator.pop(context);
                    _openSimulatedCamera();
                  },
                ),
                if (_selectedLocalImage != null)
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text("Remove Photo".tr, style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedLocalImage = null;
                        _networkImageUrl = null;
                      });
                      ProfileManager().setAdminProfileImage(null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Profile Details Editor Bottom Sheet
  void _openEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _adminName);
    final emailCtrl = TextEditingController(text: _adminEmail);
    final phoneCtrl = TextEditingController(text: _adminPhone);
    final locCtrl = TextEditingController(text: _adminLocation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Edit Admin Details".tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _adminName = nameCtrl.text;
                    _adminEmail = emailCtrl.text;
                    _adminPhone = phoneCtrl.text;
                    _adminLocation = locCtrl.text;
                  });
                  ProfileManager().setAdminName(nameCtrl.text.trim());
                  Navigator.pop(context);
                  _showToast("Admin profile details saved!");
                },
                child: Text("Save Details".tr, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: 'Admin Profile',
        subtitle: 'Manage your account details',
        onOpenDrawer: widget.onOpenDrawer,
        onProfileTap: widget.onOpenProfile,
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Top details card
            _buildProfileHeaderCard(),
            SizedBox(height: 20),

            // Admin Modules Grid
            _buildAdminMenuGrid(),
            SizedBox(height: 20),

            // Account Information
            Text("Account Information".tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            SizedBox(height: 10),
            _buildAccountInfoCard(),
            SizedBox(height: 20),

            // Security Settings
            Text("Security".tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            SizedBox(height: 10),
            _buildSecurityCard(),
            SizedBox(height: 20),

            // Preferences
            Text("Preferences".tr,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            SizedBox(height: 10),
            _buildPreferencesCard(),
            SizedBox(height: 24),

            // Logout row
            _buildLogoutRow(),
            SizedBox(height: 30),
          ],
        ),
      ),
      floatingActionButton: AiBotFab(),
    );
  }

  // 1. Admin Modules Grid
  Widget _buildAdminMenuGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Admin Modules".tr,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.8,
          children: [
            _buildGridItem(Icons.people_alt, "Students", Colors.teal, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminStudentsTab()));
            }),
            _buildGridItem(Icons.people_outline, "Employee", Colors.indigo, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminTeachersTab()));
            }),
            _buildGridItem(Icons.corporate_fare, "Branches", Colors.deepPurple, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminBranchesTab()));
            }),
            _buildGridItem(Icons.class_, "Classes", Colors.amber, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminClassesScreen()));
            }),
            _buildGridItem(Icons.video_camera_front, "Meetings", Colors.redAccent, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMeetingsScreen(initialFeature: MeetingsFeature.schedule)));
            }),
            _buildGridItem(Icons.how_to_reg, "Attendance", Colors.blue, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminAttendanceScreen()));
            }),

            _buildGridItem(Icons.assignment, "Examination", Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminExaminationsScreen()));
            }),

            _buildGridItem(Icons.directions_bus, "Transport", Colors.indigo, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminTransportScreen()));
            }),

            _buildGridItem(Icons.badge, "Student ID Cards", Colors.brown, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminIDCardsScreen()));
            }),
            _buildGridItem(Icons.badge_outlined, "Employee ID Cards", Colors.brown.shade400, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminEmployeeIDCardsScreen()));
            }),

            _buildGridItem(Icons.assessment, "Reports", Colors.red, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminReportsScreen()));
            }),
            _buildGridItem(Icons.error_outline, "Invalid Info", Colors.deepOrange, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminInvalidInfoScreen()));
            }),
            _buildGridItem(Icons.sms_outlined, "SMS", Colors.blueAccent, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSmsScreen()));
            }),
            _buildGridItem(Icons.settings, "Settings", Colors.grey, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminSettingsScreen()));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 12),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E2875),
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Profile Header Card
  Widget _buildProfileHeaderCard() {
    ImageProvider? avatarImage;
    if (_selectedLocalImage != null) {
      avatarImage = FileImage(_selectedLocalImage!);
    } else if (_networkImageUrl != null) {
      avatarImage = NetworkImage(_networkImageUrl!);
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circular Avatar with camera badge
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: avatarImage,
                  child: avatarImage == null
                      ? Icon(Icons.person, size: 48, color: AppColors.primary)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourcePicker,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _adminName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2875),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        minimumSize: Size(0, 26),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: _openEditProfileDialog,
                      icon: Icon(Icons.edit, size: 12, color: AppColors.primary),
                      label: Text("Edit".tr,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Super Admin badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("Super Administrator".tr,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Phone number
                Row(
                  children: [
                    Icon(Icons.phone, size: 13, color: Colors.grey),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _adminPhone,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Email
                Row(
                  children: [
                    Icon(Icons.email, size: 13, color: Colors.grey),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _adminEmail,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    Icon(Icons.location_on, size: 13, color: Colors.grey),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _adminLocation,
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Account Information Card
  Widget _buildAccountInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person_outline, "Full Name", _adminName),
          Divider(height: 1),
          _buildInfoRow(Icons.email_outlined, "Email Address", _adminEmail),
          Divider(height: 1),
          _buildInfoRow(Icons.phone_outlined, "Mobile Number", _adminPhone),
          Divider(height: 1),
          _buildInfoRow(Icons.badge_outlined, "Role", "Super Administrator"),
          Divider(height: 1),
          _buildInfoRow(Icons.calendar_today_outlined, "Date of Joining", "01 Jan 2024, 09:00 AM"),
          Divider(height: 1),
          _buildInfoRow(Icons.language, "Language", "English", trailing: Icon(Icons.chevron_right, size: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF757897)),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          if (trailing != null) ...[
            SizedBox(width: 6),
            trailing,
          ]
        ],
      ),
    );
  }

  // 3. Security Settings Card
  Widget _buildSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildSettingsRow(
            Icons.lock_outline,
            "Change Password",
            "Update your account password",
            onTap: () => _showChangePasswordDialog(context),
          ),
          Divider(height: 1),
          SwitchListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            secondary: Icon(Icons.security_outlined, color: AppColors.primary, size: 18),
            title: Text("Two-Factor Authentication".tr,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            subtitle: Text("Add an extra layer of security".tr,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            value: _tfaEnabled,
            onChanged: (v) => setState(() => _tfaEnabled = v),
          ),
          Divider(height: 1),
          _buildSettingsRow(
            Icons.devices_outlined,
            "Active Sessions",
            "Manage your active login sessions",
            onTap: () => _showActiveSessionsDialog(context),
          ),
        ],
      ),
    );
  }

  // 4. Preferences Card
  Widget _buildPreferencesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _buildSettingsRow(
            Icons.notifications_none_outlined,
            "Notification Settings",
            "Manage notification preferences",
            onTap: () => _showNotificationsDialog(context),
          ),
          Divider(height: 1),
          _buildSettingsRow(
            Icons.palette_outlined,
            "Theme",
            "System Default",
            onTap: () => _showThemeSelectorDialog(context),
          ),
          Divider(height: 1),
          _buildSettingsRow(
            Icons.public,
            "Region & Time Zone",
            "Asia/Kolkata (IST)",
            onTap: () => _showRegionSelectorDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 18),
      title: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: Colors.grey),
      ),
      trailing: Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Dialog implementations
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Password'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Current Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password', border: OutlineInputBorder()),
            ),
            SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm New Password', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showToast("Password updated successfully!");
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: Text('Save'.tr),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Active Sessions'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone_android, color: Colors.green),
              title: Text('iPhone 13 (Current)'.tr),
              subtitle: Text('Active now'.tr),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.computer, color: Colors.grey),
              title: Text('MacBook Pro'.tr),
              subtitle: Text('Last active: 2 hours ago'.tr),
              trailing: IconButton(
                icon: Icon(Icons.logout, color: Colors.red),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showToast("Session terminated.");
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Close'.tr)),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Notification Settings'.tr),
        content: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: Text('Push Notifications'.tr),
                  value: _pushNotificationsEnabled,
                  onChanged: (v) {
                    setModalState(() => _pushNotificationsEnabled = v);
                    setState(() => _pushNotificationsEnabled = v);
                  },
                ),
                SwitchListTile(
                  title: Text('Email Alerts'.tr),
                  value: _emailAlertsEnabled,
                  onChanged: (v) {
                    setModalState(() => _emailAlertsEnabled = v);
                    setState(() => _emailAlertsEnabled = v);
                  },
                ),
                SwitchListTile(
                  title: Text('SMS Updates'.tr),
                  value: _smsUpdatesEnabled,
                  onChanged: (v) {
                    setModalState(() => _smsUpdatesEnabled = v);
                    setState(() => _smsUpdatesEnabled = v);
                  },
                ),
              ],
            );
          }
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Close'.tr)),
        ],
      ),
    );
  }

  void _showThemeSelectorDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Theme'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.brightness_auto),
              title: Text('System Default'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.system;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('Light Theme'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.light;
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Theme'.tr),
              onTap: () {
                ProfileManager().themeMode.value = ThemeMode.dark;
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRegionSelectorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Region & Time Zone'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Asia/Kolkata (IST)'.tr),
              trailing: Icon(Icons.check, color: AppColors.primary),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: Text('America/New_York (EST)'.tr),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: Text('Europe/London (GMT)'.tr),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  // 5. Logout row
  Widget _buildLogoutRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red, size: 18),
        title: Text("Logout".tr,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        subtitle: Text("Sign out from your account".tr,
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Logout'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text('Are you sure you want to logout?'.tr),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel'.tr),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text('Logout'.tr, style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
