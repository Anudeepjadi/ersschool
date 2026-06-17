import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../login/login_screen.dart';
import '../widgets/admin_app_bar.dart';
import '../screens/admin_chat_support_screen.dart';

class AdminMoreTab extends StatefulWidget {
  final VoidCallback onOpenDrawer;

  const AdminMoreTab({super.key, required this.onOpenDrawer});

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
  String _networkImageUrl = 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop';
  
  bool _tfaEnabled = true;
  final ImagePicker _imagePicker = ImagePicker();

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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Simulated Camera view overlay
  void _openSimulatedCamera() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 300),
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
                            const Icon(Icons.person, size: 120, color: Colors.white24),
                            const SizedBox(height: 16),
                            Text(
                              "CAMERA VIEWFINDER ACTIVE",
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
                        const Row(
                          children: [
                            Icon(Icons.flash_off, color: Colors.white),
                            SizedBox(width: 16),
                            Icon(Icons.hdr_on, color: Colors.white),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
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
                        Text(
                          "Focus locked. Tap shutter to capture.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Gallery Icon
                            const Icon(Icons.photo_library, color: Colors.white, size: 28),
                            // Shutter
                            GestureDetector(
                              onTap: () {
                                // Close simulated camera, update profile photo to a different portrait matching the layout
                                Navigator.pop(context);
                                setState(() {
                                  _selectedLocalImage = null; // Clear picked
                                  // Update network photo to another professional face for demonstration
                                  _networkImageUrl = 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop';
                                });
                                _showToast("Photo captured successfully via simulated camera!");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
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
                            const Icon(Icons.flip_camera_ios, color: Colors.white, size: 28),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose Profile Picture Source",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: AppColors.primary),
                  title: const Text("Take Photo (Physical Camera)"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: AppColors.primary),
                  title: const Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.linked_camera_outlined, color: Colors.blue),
                  title: const Text("Simulate Camera Viewfinder"),
                  subtitle: const Text("Interactive mock camera capture"),
                  onTap: () {
                    Navigator.pop(context);
                    _openSimulatedCamera();
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
      shape: const RoundedRectangleBorder(
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
              const Text(
                "Edit Admin Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locCtrl,
                decoration: const InputDecoration(
                  labelText: "Location",
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _adminName = nameCtrl.text;
                    _adminEmail = emailCtrl.text;
                    _adminPhone = phoneCtrl.text;
                    _adminLocation = locCtrl.text;
                  });
                  Navigator.pop(context);
                  _showToast("Admin profile details saved!");
                },
                child: const Text("Save Details", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
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
      ),
      floatingActionButton: _buildChatFab(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar and Top details card
            _buildProfileHeaderCard(),
            const SizedBox(height: 20),

            // Account Information
            const Text(
              "Account Information",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            const SizedBox(height: 10),
            _buildAccountInfoCard(),
            const SizedBox(height: 20),

            // Security Settings
            const Text(
              "Security",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            const SizedBox(height: 10),
            _buildSecurityCard(),
            const SizedBox(height: 20),

            // Preferences
            const Text(
              "Preferences",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
              ),
            ),
            const SizedBox(height: 10),
            _buildPreferencesCard(),
            const SizedBox(height: 24),

            // Logout row
            _buildLogoutRow(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 1. Profile Header Card
  Widget _buildProfileHeaderCard() {
    ImageProvider avatarImage;
    if (_selectedLocalImage != null) {
      avatarImage = FileImage(_selectedLocalImage!);
    } else {
      avatarImage = NetworkImage(_networkImageUrl);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            blurRadius: 4,
            offset: const Offset(0, 2),
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundImage: avatarImage,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourcePicker,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4361EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _adminName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                const SizedBox(height: 4),
                // Super Admin badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4361EE).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Super Administrator",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4361EE),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Phone number
                Row(
                  children: [
                    const Icon(Icons.phone, size: 13, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      _adminPhone,
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Email
                Row(
                  children: [
                    const Icon(Icons.email, size: 13, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      _adminEmail,
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 13, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _adminLocation,
                        style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Edit Profile Button
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              side: const BorderSide(color: Color(0xFF4361EE)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: _openEditProfileDialog,
            icon: const Icon(Icons.edit, size: 14, color: Color(0xFF4361EE)),
            label: const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4361EE)),
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
          const Divider(height: 1),
          _buildInfoRow(Icons.email_outlined, "Email Address", _adminEmail),
          const Divider(height: 1),
          _buildInfoRow(Icons.phone_outlined, "Mobile Number", _adminPhone),
          const Divider(height: 1),
          _buildInfoRow(Icons.badge_outlined, "Role", "Super Administrator"),
          const Divider(height: 1),
          _buildInfoRow(Icons.calendar_today_outlined, "Date of Joining", "01 Jan 2024, 09:00 AM"),
          const Divider(height: 1),
          _buildInfoRow(Icons.language, "Language", "English", trailing: const Icon(Icons.chevron_right, size: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF4361EE)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF757897)),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 6),
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
            onTap: () => _showToast("Change password dialog — Coming soon!"),
          ),
          const Divider(height: 1),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            secondary: const Icon(Icons.security_outlined, color: Color(0xFF4361EE), size: 18),
            title: const Text(
              "Two-Factor Authentication",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
            subtitle: const Text(
              "Add an extra layer of security",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            value: _tfaEnabled,
            onChanged: (v) => setState(() => _tfaEnabled = v),
          ),
          const Divider(height: 1),
          _buildSettingsRow(
            Icons.devices_outlined,
            "Active Sessions",
            "Manage your active login sessions",
            onTap: () => _showToast("Active sessions list — Coming soon!"),
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
            onTap: () => _showToast("Notification configuration — Coming soon!"),
          ),
          const Divider(height: 1),
          _buildSettingsRow(
            Icons.palette_outlined,
            "Theme",
            "System Default",
            onTap: () => _showToast("Theme selector — Coming soon!"),
          ),
          const Divider(height: 1),
          _buildSettingsRow(
            Icons.public,
            "Region & Time Zone",
            "Asia/Kolkata (IST)",
            onTap: () => _showToast("Region selector — Coming soon!"),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4361EE), size: 18),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: onTap,
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
        leading: const Icon(Icons.logout, color: Colors.red, size: 18),
        title: const Text(
          "Logout",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        subtitle: const Text(
          "Sign out from your account",
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
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
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 6. CHATBOT FAB
  Widget _buildChatFab() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Hi! How can I help you?",
            style: TextStyle(fontSize: 11, color: Color(0xFF1E2875)),
          ),
        ),
        const SizedBox(height: 6),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminChatSupportScreen()));
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
