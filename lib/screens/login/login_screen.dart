import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/profile_manager.dart';
import '../../core/data/app_data_store.dart';
import '../student/dashboard/dashboard_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../teacher/teacher_dashboard_screen.dart';
import '../../core/localization/language_manager.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final id = _idController.text.trim();
      final password = _passwordController.text.trim();

      final role = AppDataStore.instance.authenticate(id, password);

      if (role == 'admin') {
        AppDataStore.instance.currentRole = 'admin';
        _navigate(AdminDashboardScreen(), 'Admin');
      } else if (role == 'student') {
        AppDataStore.instance.currentRole = 'student';
        final loggedInStudent = AppDataStore.instance.students
            .firstWhere((s) => (s['admission'] as String).toUpperCase() == id.toUpperCase());
        AppDataStore.instance.currentUser = loggedInStudent;
        
        final name = loggedInStudent['name'] ?? 'Student';
        final email = loggedInStudent['email'] ?? "${name.toLowerCase().replaceAll(' ', '')}@ecstasyschool.com";
        ProfileManager().setStudentName(name);
        ProfileManager().setStudentEmail(email);
        
        _navigate(DashboardScreen(), 'Student');
      } else if (role == 'teacher') {
        AppDataStore.instance.currentRole = 'teacher';
        AppDataStore.instance.currentUser = AppDataStore.instance.teachers
            .firstWhere((t) => (t['employeeCode'] as String).toUpperCase() == id.toUpperCase());
        _navigate(TeacherDashboardScreen(), 'Teacher');
      } else {
        _showError(
          'Invalid credentials.\n'
          '- Admin: ID = admin, Password = admin@123\n'
          '- Student: ID = ECS00001, Password = ECS00001\n'
          '- Teacher: ID = ECS00E01, Password = ECS00E01',
        );
      }
    }
  }

  void _navigate(Widget destination, String role) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome $role! Logging in...'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => destination));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPasswordRecoveryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Password Recovery'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your registered email or mobile number to receive a reset link.'.tr),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email or Mobile Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recovery link sent successfully!'.tr)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Send Link'.tr),
            ),
          ],
        );
      },
    );
  }

  void _showGoogleLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Choose an account'.tr,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('to continue to Ecstasy School ERP'.tr,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text('A'.tr, style: TextStyle(color: Colors.white)),
                ),
                title: Text('admin@ecstasy.edu'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Admin Account'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.shade400,
                  child: Text('S'.tr, style: TextStyle(color: Colors.white)),
                ),
                title: Text('student@ecstasy.edu'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Student Account'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade400,
                  child: Text('T'.tr, style: TextStyle(color: Colors.white)),
                ),
                title: Text('teacher@ecstasy.edu'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Teacher Account'.tr),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TeacherDashboardScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : Color(0xFF1E2875);
    final secondaryTextColor = isDark ? Colors.grey.shade400 : Color(0xFF757897);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                SizedBox(height: 10),
                
                // 1. Logo
                Center(
                  child: Image.asset(
                    'assets/images/loginscreenlogo.png',
                    height: 110,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.school, size: 100, color: AppColors.primary);
                    },
                  ),
                ),
                SizedBox(height: 12),
                
                // Smart School Management Subtitle Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 1,
                      color: AppColors.secondary.withValues(alpha: 0.5),
                    ),
                    SizedBox(width: 8),
                    Text("Smart School Management".tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: secondaryTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 1,
                      color: AppColors.secondary.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                SizedBox(height: 32),
                
                // 2. Title Section
                Text('Welcome Back!'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                SizedBox(height: 6),
                Text('Login to your account'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 32),

                // 3. User ID Field (Outside Label)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User ID".tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.text,
                      decoration: _buildInputDecoration(
                        hintText: "Enter Admission No / Teacher Code / Admin ID",
                        prefixIcon: Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your User ID';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // 4. Password Field (Outside Label)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password".tr,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: _buildInputDecoration(
                        hintText: "Enter your password",
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF757897),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // 5. Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => _showPasswordRecoveryDialog(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text('Forgot Password?'.tr,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // 6. Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Login'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // 7. OR Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("OR".tr,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        thickness: 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // 8. Login with Google Button
                OutlinedButton(
                  onPressed: () => _showGoogleLoginSheet(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
                    side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GoogleLogo(size: 20),
                      SizedBox(width: 12),
                      Text("Login with Google".tr,
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // 9. Powered By Footer
                Column(
                  children: [
                    Text("Powered by".tr,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/loginscreenlogo.png',
                          height: 22,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.school, size: 22, color: AppColors.primary),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("ECSTASY".tr,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: primaryTextColor,
                                height: 1.0,
                              ),
                            ),
                            Text("SCHOOLS ERP".tr,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("© 2024 Ecstasy Schools ERP. All rights reserved.".tr,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 22),
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: TextStyle(fontSize: 12),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// Custom Paint widget to render the Google 'G' icon vector in high resolution
class GoogleLogo extends StatelessWidget {
  final double size;
  GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double radius = width / 2;
    final Offset center = Offset(radius, radius);
    
    final double strokeWidth = width * 0.22;
    final Rect rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);
    
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;

    // 1. Red Top Arc
    paint.color = Color(0xFFEA4335);
    canvas.drawArc(rect, -2.4, 1.2, false, paint);

    // 2. Yellow Left Arc
    paint.color = Color(0xFFFBBC05);
    canvas.drawArc(rect, -3.6, 1.2, false, paint);

    // 3. Green Bottom Arc
    paint.color = Color(0xFF34A853);
    canvas.drawArc(rect, 1.2, 1.2, false, paint);

    // 4. Blue Right Arc
    paint.color = Color(0xFF4285F4);
    canvas.drawArc(rect, -0.0, 1.2, false, paint);

    // 5. Blue Horizontal Bar
    final Paint barPaint = Paint()
      ..color = Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawRect(
      Rect.fromLTWH(radius, radius - strokeWidth / 2, radius, strokeWidth),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


