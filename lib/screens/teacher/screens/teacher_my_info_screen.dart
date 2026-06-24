import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../widgets/teacher_app_bar.dart';
import '../../../core/data/app_data_store.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model helpers
// ─────────────────────────────────────────────────────────────────────────────
class _CountryCode {
  final String code;
  final String flag;
  final String name;
  const _CountryCode(this.code, this.flag, this.name);
}



// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class TeacherMyInfoScreen extends StatefulWidget {
  final Function(int)? onTabSelected;
  const TeacherMyInfoScreen({super.key, this.onTabSelected});

  @override
  State<TeacherMyInfoScreen> createState() => _TeacherMyInfoScreenState();
}

class _TeacherMyInfoScreenState extends State<TeacherMyInfoScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    
    // Load from ProfileManager if set, otherwise from AppDataStore currentUser
    final currentTeacher = AppDataStore.instance.currentUser;
    final savedName = ProfileManager().teacherName.value;
    
    name = (savedName.isNotEmpty && savedName != 'Teacher Name') 
        ? savedName 
        : (currentTeacher != null ? currentTeacher['name'] as String : 'Dr. Ramesh Kumar');
        
    studentId = currentTeacher != null ? currentTeacher['employeeCode'] as String : 'ECS00E01';
    rollNumber = currentTeacher != null ? currentTeacher['subject'] as String : 'Senior Faculty';
    mobile = currentTeacher != null ? currentTeacher['phone'] as String : '9876543301';
    email = currentTeacher != null ? "${(currentTeacher['name'] as String).toLowerCase().replaceAll(' ', '.')}@school.com" : 'ramesh.kumar@school.com';
    gender = currentTeacher != null ? currentTeacher['gender'] as String : 'Male';
    
    // Fallback constants or fields
    admissionNo = studentId;
    classSection = currentTeacher != null ? currentTeacher['department'] as String : 'Science';
    dateOfAdmission = currentTeacher != null ? currentTeacher['experience'] as String : '15 years';
    academicYear = '10 Jun 2012';
    house = 'Full Time';
    firstLanguage = 'Morning';
    secondLanguage = currentTeacher != null ? (currentTeacher['school'] as String) : 'Ecstasy School 1';
    
    // Emergency contact default
    emergencyContact = 'Family Member';
    relationship = 'Spouse';
    emergencyPhone = '+91 9876543300';
    
    // Other defaults
    nationality = 'Indian';
    religion = 'Hindu';
    casteCategory = 'General';
    languagesKnown = 'English, Hindi, Telugu';
    
    // Also update ProfileManager's teacherName value if it was the default
    if (ProfileManager().teacherName.value == 'Teacher Name') {
      ProfileManager().setTeacherName(name);
    }
    
    final path = ProfileManager().teacherProfileImagePath.value;
    if (path != null) {
      _profileImage = File(path);
    }
  }

  // ── Student data ───────────────────────────────────────────────────────────
  String name = '';
  String classSection = '';
  String studentId = '';
  String mobile = '';
  String countryCode = '+91';
  String email = '';
  String bloodGroup = 'A+';
  String dob = '';
  String gender = 'Male';
  String address = '';
  String aadhaar = '';

  // Academic
  String admissionNo = '';
  String rollNumber = '';
  String academicYear = '';
  String dateOfAdmission = '';
  String house = '';
  String firstLanguage = 'Morning';
  String secondLanguage = 'Main Campus';

  // Parent
  String fatherName = '';
  String fatherPhone = '';
  String fatherEmail = '';
  String fatherOccupation = '';
  String motherName = '';
  String motherPhone = '';
  String motherEmail = '';
  String motherOccupation = '';

  // Emergency
  String emergencyContact = '';
  String relationship = '';
  String emergencyPhone = '';

  // Medical
  String allergies = '';
  String medicalConditions = '';
  String regularMedication = '';

  // Other
  String nationality = '';
  String religion = '';
  String casteCategory = '';
  String languagesKnown = '';

  // Profile photo
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // ── Country codes ──────────────────────────────────────────────────────────
  static const List<_CountryCode> _countryCodes = [
    _CountryCode('+91', '🇮🇳', 'India'),
    _CountryCode('+1', '🇺🇸', 'USA'),
    _CountryCode('+44', '🇬🇧', 'UK'),
    _CountryCode('+61', '🇦🇺', 'Australia'),
    _CountryCode('+971', '🇦🇪', 'UAE'),
    _CountryCode('+966', '🇸🇦', 'Saudi Arabia'),
    _CountryCode('+65', '🇸🇬', 'Singapore'),
    _CountryCode('+81', '🇯🇵', 'Japan'),
    _CountryCode('+49', '🇩🇪', 'Germany'),
    _CountryCode('+33', '🇫🇷', 'France'),
    _CountryCode('+86', '🇨🇳', 'China'),
    _CountryCode('+55', '🇧🇷', 'Brazil'),
    _CountryCode('+7', '🇷🇺', 'Russia'),
    _CountryCode('+27', '🇿🇦', 'South Africa'),
    _CountryCode('+234', '🇳🇬', 'Nigeria'),
    _CountryCode('+880', '🇧🇩', 'Bangladesh'),
    _CountryCode('+92', '🇵🇰', 'Pakistan'),
    _CountryCode('+94', '🇱🇰', 'Sri Lanka'),
    _CountryCode('+977', '🇳🇵', 'Nepal'),
    _CountryCode('+60', '🇲🇾', 'Malaysia'),
  ];

  // ── Date helpers ───────────────────────────────────────────────────────────
  static const _months = [
    'Jan','Feb','Mar','Apr','Jun','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ];

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';

  DateTime? _parseDob(String s) {
    final p = s.split(' ');
    if (p.length != 3) return null;
    final day = int.tryParse(p[0]);
    final month = _months.indexOf(p[1]) + 1;
    final year = int.tryParse(p[2]);
    if (day == null || month == 0 || year == null) return null;
    return DateTime(year, month, day);
  }

  // ── Photo pick ─────────────────────────────────────────────────────────────
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _sheetWrapper(
        ctx,
        title: 'Upload Profile Photo',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: _photoBtn(Icons.camera_alt_rounded, 'Camera', 'Take a photo', () { Navigator.pop(ctx); _pickImage(ImageSource.camera); })),
                const SizedBox(width: 16),
                Expanded(child: _photoBtn(Icons.photo_library_rounded, 'Gallery', 'Choose existing', () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); })),
              ],
            ),
            if (_profileImage != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () { 
                    setState(() => _profileImage = null); 
                    ProfileManager().setTeacherProfileImage(null);
                    Navigator.pop(ctx); 
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _photoBtn(IconData icon, String label, String sub, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ]),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 85);
      if (picked != null && mounted) {
        setState(() => _profileImage = File(picked.path));
        ProfileManager().setTeacherProfileImage(picked.path);
        _showSnack('Profile photo updated!', Colors.green.shade600, Icons.check_circle);
      }
    } catch (_) {
      if (mounted) _showSnack('Cannot access ${source == ImageSource.camera ? 'camera' : 'gallery'}. Check permissions.', Colors.red.shade600, Icons.error_outline);
    }
  }

  void _showSnack(String msg, Color bg, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [Icon(icon, color: Colors.white, size: 18), const SizedBox(width: 8), Expanded(child: Text(msg))]),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Shared bottom-sheet wrapper ────────────────────────────────────────────
  Widget _sheetWrapper(BuildContext ctx, {required String title, required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  // ── Generic text form field ────────────────────────────────────────────────
  Widget _formField({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: _inputDeco(label, icon),
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
  );

  // ── Dropdown form field ────────────────────────────────────────────────────
  Widget _dropField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(value) ? value : items.first,
      decoration: _inputDeco(label, icon),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT PROFILE
  // ────────────────────────────────────────────────────────────────────────────
  void _openEditProfile() {
    final nameCtrl = TextEditingController(text: name);
    final studentIdCtrl = TextEditingController(text: studentId);
    final aadhaarCtrl = TextEditingController(text: aadhaar);
    final mobileCtrl = TextEditingController(text: mobile.replaceAll(RegExp(r'\D'), ''));
    final emailCtrl = TextEditingController(text: email);
    final addressCtrl = TextEditingController(text: address);
    String selGender = gender;
    String selBlood = bloodGroup;
    String selCode = countryCode;
    DateTime? selDob = _parseDob(dob);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setSS) {
        return _sheetWrapper(ctx, title: 'Edit Profile', child: Form(
          key: formKey,
          child: Column(children: [
            // Full Name
            _formField(ctrl: nameCtrl, label: 'Full Name', icon: Icons.person,
              validator: (v) => (v == null || v.trim().length < 2) ? 'Enter a valid name' : null),
            const SizedBox(height: 14),

            // Employee ID
            _formField(ctrl: studentIdCtrl, label: 'Employee ID', icon: Icons.badge_outlined),
            const SizedBox(height: 14),

            // Phone + country code
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selCode,
                    menuMaxHeight: 300,
                    items: _countryCodes.map((c) => DropdownMenuItem(value: c.code, child: Text('${c.flag} ${c.code}', style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) { if (v != null) setSS(() => selCode = v); },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: TextFormField(
                controller: mobileCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                decoration: _inputDeco('Mobile (10 digits)', Icons.phone).copyWith(counterText: ''),
                validator: (v) => (v == null || v.length != 10) ? 'Enter 10-digit number' : null,
              )),
            ]),
            const SizedBox(height: 14),

            // Email
            _formField(ctrl: emailCtrl, label: 'Email Address', icon: Icons.email, keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) return 'Enter a valid email';
                return null;
              }),
            const SizedBox(height: 14),

            // Blood Group
            _dropField(label: 'Blood Group', icon: Icons.bloodtype, value: selBlood,
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
              onChanged: (v) { if (v != null) setSS(() => selBlood = v); }),
            const SizedBox(height: 14),

            // Date of Birth
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final p = await showDatePicker(
                  context: ctx,
                  initialDate: selDob ?? DateTime(now.year - 10),
                  firstDate: DateTime(1990),
                  lastDate: now,
                  builder: (c, w) => Theme(
                    data: Theme.of(c).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.primary, onPrimary: Colors.white)),
                    child: w!,
                  ),
                );
                if (p != null) setSS(() => selDob = p);
              },
              child: AbsorbPointer(child: TextFormField(
                controller: TextEditingController(text: selDob != null ? _formatDate(selDob!) : ''),
                decoration: _inputDeco('Date of Birth', Icons.cake).copyWith(
                  hintText: 'Tap to select date',
                  suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                ),
              )),
            ),
            const SizedBox(height: 14),

            // Gender
            _dropField(label: 'Gender', icon: Icons.wc, value: selGender,
              items: const ['Male', 'Female'],
              onChanged: (v) { if (v != null) setSS(() => selGender = v); }),
            const SizedBox(height: 14),

            // Address
            _formField(ctrl: addressCtrl, label: 'Address', icon: Icons.home, maxLines: 2),
            const SizedBox(height: 14),

            // Aadhaar Number
            TextFormField(
              controller: aadhaarCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
              decoration: _inputDeco('Aadhaar Number (12 digits)', Icons.shield_outlined).copyWith(counterText: ''),
              validator: (v) => (v != null && v.isNotEmpty && v.length != 12) ? 'Aadhaar must be 12 digits' : null,
            ),
            const SizedBox(height: 22),

            _saveBtn(() {
              if (formKey.currentState!.validate()) {
                final newName = nameCtrl.text.trim();
                setState(() {
                  name = newName;
                  studentId = studentIdCtrl.text.trim();
                  aadhaar = aadhaarCtrl.text.trim();
                  mobile = mobileCtrl.text.trim();
                  countryCode = selCode;
                  email = emailCtrl.text.trim();
                  bloodGroup = selBlood;
                  dob = selDob != null ? _formatDate(selDob!) : dob;
                  gender = selGender;
                  address = addressCtrl.text.trim();
                });
                ProfileManager().setTeacherName(newName);
                if (AppDataStore.instance.currentUser != null) {
                  AppDataStore.instance.currentUser!['name'] = newName;
                  AppDataStore.instance.currentUser!['phone'] = mobile;
                  AppDataStore.instance.currentUser!['gender'] = gender;
                }
                Navigator.pop(context);
              }
            }),
          ]),
        ));
      }),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT ACADEMIC
  // ────────────────────────────────────────────────────────────────────────────
  void _openAcademicEdit() {
    final ctrls = {
      'Employee ID': TextEditingController(text: admissionNo),
      'Designation': TextEditingController(text: rollNumber),
      'Date of Joining': TextEditingController(text: academicYear),
      'Experience': TextEditingController(text: dateOfAdmission),
      'Employment Type': TextEditingController(text: house),
      'Shift': TextEditingController(text: firstLanguage),
      'Work Location': TextEditingController(text: secondLanguage),
    };
    final icons = {
      'Employee ID': Icons.badge,
      'Designation': Icons.work,
      'Date of Joining': Icons.calendar_today,
      'Experience': Icons.timeline,
      'Employment Type': Icons.shield,
      'Shift': Icons.access_time,
      'Work Location': Icons.location_on,
    };
    _openSimpleEdit('Edit Employment Information', ctrls, icons, () {
      setState(() {
        admissionNo = ctrls['Employee ID']!.text;
        rollNumber = ctrls['Designation']!.text;
        academicYear = ctrls['Date of Joining']!.text;
        dateOfAdmission = ctrls['Experience']!.text;
        house = ctrls['Employment Type']!.text;
        firstLanguage = ctrls['Shift']!.text;
        secondLanguage = ctrls['Work Location']!.text;
      });
    });
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT PARENT
  // ────────────────────────────────────────────────────────────────────────────
  void _openParentEdit() {
    final fNameCtrl = TextEditingController(text: fatherName);
    final fPhoneCtrl = TextEditingController(text: fatherPhone);
    final fEmailCtrl = TextEditingController(text: fatherEmail);
    final fOccCtrl = TextEditingController(text: fatherOccupation);

    final mNameCtrl = TextEditingController(text: motherName);
    final mPhoneCtrl = TextEditingController(text: motherPhone);
    final mEmailCtrl = TextEditingController(text: motherEmail);
    final mOccCtrl = TextEditingController(text: motherOccupation);

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setSS) {
        return _sheetWrapper(ctx, title: 'Edit Bank & Statutory Details', child: Form(
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Bank Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10),
            _formField(ctrl: fNameCtrl, label: 'Bank Name', icon: Icons.account_balance),
            const SizedBox(height: 14),
            _formField(ctrl: fPhoneCtrl, label: 'Account Number', icon: Icons.numbers),
            const SizedBox(height: 14),
            _formField(ctrl: fEmailCtrl, label: 'IFSC Code', icon: Icons.account_balance_wallet),
            const SizedBox(height: 14),
            _formField(ctrl: fOccCtrl, label: 'Branch Name', icon: Icons.business),
            const SizedBox(height: 24),

            const Text('Statutory Details', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E8C))),
            const SizedBox(height: 10),
            _formField(ctrl: mNameCtrl, label: 'PAN Number', icon: Icons.badge),
            const SizedBox(height: 14),
            _formField(ctrl: mPhoneCtrl, label: 'EPF Number', icon: Icons.health_and_safety),
            const SizedBox(height: 14),
            _formField(ctrl: mEmailCtrl, label: 'UAN Number', icon: Icons.health_and_safety),
            const SizedBox(height: 14),
            _formField(ctrl: mOccCtrl, label: 'Tax Regime (e.g. New/Old)', icon: Icons.monetization_on),
            const SizedBox(height: 22),

            _saveBtn(() {
              if (formKey.currentState!.validate()) {
                setState(() {
                  fatherName = fNameCtrl.text.trim();
                  fatherPhone = fPhoneCtrl.text.trim();
                  fatherEmail = fEmailCtrl.text.trim();
                  fatherOccupation = fOccCtrl.text.trim();
                  motherName = mNameCtrl.text.trim();
                  motherPhone = mPhoneCtrl.text.trim();
                  motherEmail = mEmailCtrl.text.trim();
                  motherOccupation = mOccCtrl.text.trim();
                });
                Navigator.pop(context);
              }
            }),
          ]),
        ));
      }),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT EMERGENCY
  // ────────────────────────────────────────────────────────────────────────────
  void _openEmergencyEdit() {
    String extractCode(String p) => p.contains(' ') ? p.split(' ')[0] : '+91';
    String extractNum(String p) => p.contains(' ') ? p.split(' ')[1].replaceAll(RegExp(r'\D'), '') : p.replaceAll(RegExp(r'\D'), '');

    final nameCtrl = TextEditingController(text: emergencyContact);
    final relCtrl = TextEditingController(text: relationship);
    final phoneCtrl = TextEditingController(text: extractNum(emergencyPhone));
    String selCode = extractCode(emergencyPhone);
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setSS) {
        return _sheetWrapper(ctx, title: 'Edit Emergency Contact', child: Form(
          key: formKey,
          child: Column(children: [
            _formField(ctrl: nameCtrl, label: 'Contact Name', icon: Icons.person),
            const SizedBox(height: 14),
            _formField(ctrl: relCtrl, label: 'Relationship', icon: Icons.people),
            const SizedBox(height: 14),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 56,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selCode,
                    menuMaxHeight: 300,
                    items: _countryCodes.map((c) => DropdownMenuItem(value: c.code, child: Text('${c.flag} ${c.code}', style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) { if (v != null) setSS(() => selCode = v); },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                decoration: _inputDeco('Mobile (10 digits)', Icons.phone).copyWith(counterText: ''),
                validator: (v) => (v != null && v.isNotEmpty && v.length != 10) ? 'Enter 10-digit number' : null,
              )),
            ]),
            const SizedBox(height: 22),
            _saveBtn(() {
              if (formKey.currentState!.validate()) {
                setState(() {
                  emergencyContact = nameCtrl.text.trim();
                  relationship = relCtrl.text.trim();
                  emergencyPhone = phoneCtrl.text.isEmpty ? '' : '$selCode ${phoneCtrl.text.trim()}';
                });
                Navigator.pop(context);
              }
            }),
          ]),
        ));
      }),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT MEDICAL
  // ────────────────────────────────────────────────────────────────────────────
  void _openMedicalEdit() {
    final ctrls = {
      'Allergies': TextEditingController(text: allergies),
      'Medical Conditions': TextEditingController(text: medicalConditions),
      'Regular Medication': TextEditingController(text: regularMedication),
    };
    final icons = {'Allergies': Icons.warning_amber, 'Medical Conditions': Icons.medical_services, 'Regular Medication': Icons.medication};
    _openSimpleEdit('Edit Medical Information', ctrls, icons, () {
      setState(() {
        allergies = ctrls['Allergies']!.text;
        medicalConditions = ctrls['Medical Conditions']!.text;
        regularMedication = ctrls['Regular Medication']!.text;
      });
    });
  }

  // ── Generic simple editor ──────────────────────────────────────────────────
  void _openSimpleEdit(
    String title,
    Map<String, TextEditingController> ctrls,
    Map<String, IconData> icons,
    VoidCallback onSaveData,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _sheetWrapper(ctx, title: title, child: Column(children: [
        ...ctrls.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _formField(ctrl: e.value, label: e.key, icon: icons[e.key] ?? Icons.edit),
        )),
        _saveBtn(() { onSaveData(); Navigator.pop(context); }),
      ])),
    );
  }

  Widget _saveBtn(VoidCallback onTap) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    ),
  );

  // ──────────────────────────────────────────────────────────────────────────
  //  BUILD
  // ──────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    // On screens ≥ 700 px (tablet / desktop) use wider card layout
    final isWide = screenW >= 700;
    final hPad = isWide ? 24.0 : 16.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: TeacherAppBar(
        title: "My Info",
        subtitle: "View and edit your profile",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onProfileTap: () {
          // Stay on this page
        },
      ),
      drawer: _buildDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF757897),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: (index) {
          Navigator.pop(context);
          if (widget.onTabSelected != null) {
            widget.onTabSelected!(index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.class_outlined), activeIcon: Icon(Icons.class_), label: "Classes"),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: "Students"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: "Reports"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                // cap max width for desktop
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: EdgeInsets.only(left: hPad, right: hPad, top: 4, bottom: 16),
                  child: Column(children: [
                    // ── 1. Profile header ────────────────────────────────────────
                _buildProfileCard(),
                const SizedBox(height: 14),

                // ── 2. Quick stats ────────────────────────────────────────────
                _buildQuickStats(),
                const SizedBox(height: 14),

                // ── 3. Academic + Parent (side-by-side on wide, stacked on narrow) ──
                isWide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: _buildAcademicCard()),
                      const SizedBox(width: 14),
                      Expanded(child: _buildParentCard()),
                    ])
                  : Column(children: [
                      _buildAcademicCard(),
                      const SizedBox(height: 14),
                      _buildParentCard(),
                    ]),
                const SizedBox(height: 14),

                // ── 4. Emergency + Medical ────────────────────────────────────
                isWide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: _buildEmergencyCard()),
                      const SizedBox(width: 14),
                      Expanded(child: _buildMedicalCard()),
                    ])
                  : Column(children: [
                      _buildEmergencyCard(),
                      const SizedBox(height: 14),
                      _buildMedicalCard(),
                    ]),
                const SizedBox(height: 14),

                // ── 5. Other Information ─────────────────────────────────────
                _buildOtherCard(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  1. PROFILE CARD  (matches Image 2 — avatar left, details right, Edit Profile button top-right)
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B263B), Color(0xFF0D1B2A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Avatar + camera icon
          Stack(children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 46, color: Colors.white)
                  : null,
            ),
            Positioned(
              bottom: 0, right: 0,
              child: GestureDetector(
                onTap: _showPhotoOptions,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 14),

          // Name + class + details
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                ValueListenableBuilder<String>(
                  valueListenable: ProfileManager().teacherName,
                  builder: (context, tName, _) {
                    return Text(tName.isEmpty ? 'Employee Name' : tName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: tName.isEmpty ? Colors.white70 : Colors.white));
                  }
                ),
                const SizedBox(height: 3),
                Text(
                  rollNumber.isEmpty ? 'Designation' : rollNumber,
                  style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                ),
              ])),
              TextButton.icon(
                onPressed: _openEditProfile,
                icon: const Icon(Icons.edit, size: 14),
                label: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            _darkDetailLine(Icons.badge_outlined, 'Employee ID', studentId),
            _darkDetailLine(Icons.phone_outlined, 'Mobile Number', mobile.isEmpty ? '' : '$countryCode ${_formatMobile(mobile)}'),
            _darkDetailLine(Icons.email_outlined, 'Email Address', email),
            _darkDetailLine(Icons.water_drop_outlined, 'Blood Group', bloodGroup),
          ])),
        ]),
      ]),
    );
  }

  Widget _darkDetailLine(IconData icon, String label, String value) {
    final bool isEmpty = value.trim().isEmpty;
    final displayValue = isEmpty ? label : value;
    final valColor = isEmpty ? Colors.white54 : Colors.white;
    final fw = isEmpty ? FontWeight.normal : FontWeight.bold;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(flex: 4, child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))),
        Expanded(flex: 6, child: Text(displayValue, style: TextStyle(fontSize: 11, fontWeight: fw, color: valColor))),
      ]),
    );
  }

  String _formatMobile(String m) {
    final d = m.replaceAll(RegExp(r'\D'), '');
    if (d.length >= 10) return '${d.substring(0, 5)} ${d.substring(5, 10)}';
    return d;
  }


  // ────────────────────────────────────────────────────────────────────────────
  //  2. QUICK STATS ROW
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildQuickStats() {
    return _card(child: Row(children: [
      _statCell(Icons.cake_outlined, 'Date of Birth', dob),
      _vDiv(),
      _statCell(Icons.wc, 'Gender', gender),
      _vDiv(),
      _statCell(Icons.home_outlined, 'Address', address, small: true),
      _vDiv(),
      _statCell(Icons.shield_outlined, 'Aadhaar No.', aadhaar, small: true),
    ]));
  }

  Widget _statCell(IconData icon, String label, String val, {bool small = false}) {
    final bool isEmpty = val.trim().isEmpty;
    final displayValue = isEmpty ? label : val;
    final color = isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A);
    final fw = isEmpty ? FontWeight.normal : FontWeight.bold;

    return Expanded(child: Column(children: [
      Icon(icon, color: AppColors.primary, size: 20),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade500), textAlign: TextAlign.center),
      const SizedBox(height: 2),
      Text(displayValue, style: TextStyle(fontSize: small ? 9 : 11, fontWeight: fw, color: color), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
    ]));
  }

  Widget _vDiv() => Container(width: 1, height: 50, color: Colors.grey.shade200);

  // ────────────────────────────────────────────────────────────────────────────
  //  3a. ACADEMIC CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildAcademicCard() {
    return _sectionCard(
      icon: Icons.work_outline,
      iconColor: AppColors.primary,
      title: 'Employment Information',
      onEdit: _openAcademicEdit,
      child: Column(children: [
        _row2('Employee ID', admissionNo),
        _row2('Department', classSection),
        _row2('Designation', rollNumber),
        _row2('Date of Joining', dateOfAdmission),
        _row2('Employment Type', house),
        _row2('Shift', firstLanguage),
        _row2('Work Location', secondLanguage),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  3b. PARENT CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildParentCard() {
    return _sectionCard(
      icon: Icons.account_balance,
      iconColor: AppColors.primary,
      title: 'Bank & Statutory Details',
      onEdit: _openParentEdit,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Bank
        const Text('Bank Account', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(fatherName.isEmpty ? 'Bank Name' : fatherName, style: TextStyle(fontWeight: fatherName.isEmpty ? FontWeight.normal : FontWeight.bold, fontSize: 13, color: fatherName.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        _contactLine(Icons.numbers, fatherPhone),
        _contactLine(Icons.account_balance_wallet, fatherEmail),
        _occupationRow('Branch', fatherOccupation),
        const SizedBox(height: 12),
        // Statutory
        const Text('Statutory Info', style: TextStyle(color: Color(0xFFE91E8C), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(motherName.isEmpty ? 'PAN Number' : motherName, style: TextStyle(fontWeight: motherName.isEmpty ? FontWeight.normal : FontWeight.bold, fontSize: 13, color: motherName.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        _contactLine(Icons.badge, motherPhone),
        _contactLine(Icons.health_and_safety, motherEmail),
      ]),
    );
  }

  Widget _contactLine(IconData icon, String val) {
    final bool isEmpty = val.trim().isEmpty;
    final displayValue = isEmpty ? 'Not provided' : val;
    final color = isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A);

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(children: [
        Icon(icon, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(child: Text(displayValue, style: TextStyle(fontSize: 11, color: color), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _occupationRow(String label, String val) {
    final bool isEmpty = val.trim().isEmpty;
    final displayValue = isEmpty ? label : val;
    final color = isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A);
    final fw = isEmpty ? FontWeight.normal : FontWeight.w600;

    return Row(children: [
      Text('$label  ', style: const TextStyle(fontSize: 11, color: Color(0xFF1A1A1A))),
      Expanded(child: Text(displayValue, style: TextStyle(fontSize: 11, fontWeight: fw, color: color), overflow: TextOverflow.ellipsis)),
    ]);
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  4a. EMERGENCY CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildEmergencyCard() {
    return _sectionCard(
      icon: Icons.emergency_rounded,
      iconColor: Colors.redAccent,
      title: 'Emergency Contact',
      onEdit: _openEmergencyEdit,
      child: Column(children: [
        _row2('Contact Name', emergencyContact),
        _row2('Relationship', relationship),
        _row2('Phone Number', emergencyPhone),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  4b. MEDICAL CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildMedicalCard() {
    return _sectionCard(
      icon: Icons.favorite_rounded,
      iconColor: Colors.green,
      title: 'Medical Information',
      onEdit: _openMedicalEdit,
      child: Column(children: [
        _row2('Allergies', allergies),
        _row2('Medical Conditions', medicalConditions),
        _row2('Regular Medication', regularMedication),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  5. OTHER INFORMATION
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildOtherCard() {
    return _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.12), shape: BoxShape.circle),
          child: const Icon(Icons.info_outline, color: Colors.orange, size: 18),
        ),
        const SizedBox(width: 8),
        const Text('Other Information', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
      const SizedBox(height: 12),
      const Divider(height: 1),
      const SizedBox(height: 12),
      LayoutBuilder(builder: (_, constraints) {
        final wide = constraints.maxWidth > 420;
        if (wide) {
          return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(children: [
              _row2('Nationality', nationality),
              _row2('Caste Category', casteCategory),
            ])),
            const SizedBox(width: 16),
            Expanded(child: Column(children: [
              _row2('Religion', religion),
              _row2('Languages Known', languagesKnown),
            ])),
          ]);
        } else {
          return Column(children: [
            _row2('Nationality', nationality),
            _row2('Religion', religion),
            _row2('Caste Category', casteCategory),
            _row2('Languages Known', languagesKnown),
          ]);
        }
      }),
    ]));
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  Shared widgets
  // ────────────────────────────────────────────────────────────────────────────

  /// A simple label-value row used inside section cards
  Widget _row2(String label, String value) {
    final bool isEmpty = value.trim().isEmpty;
    final displayValue = isEmpty ? label : value;
    final color = isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A);
    final fw = isEmpty ? FontWeight.normal : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex: 5, child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF1A1A1A)))),
        Expanded(flex: 5, child: Text(displayValue, style: TextStyle(fontSize: 11, fontWeight: fw, color: color), textAlign: TextAlign.right)),
      ]),
    );
  }

  /// White rounded card container
  Widget _card({required Widget child, EdgeInsets padding = const EdgeInsets.all(16)}) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: child,
    );
  }

  /// Section card with icon header + edit arrow
  Widget _sectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
    VoidCallback? onEdit,
  }) {
    return _card(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
            ),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),
        child,
      ]),
    );
  }
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
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
                        valueListenable: ProfileManager().teacherProfileImagePath,
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
                      child: ValueListenableBuilder<String>(
                        valueListenable: ProfileManager().teacherName,
                        builder: (context, tName, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tName.isEmpty ? "Employee Name" : tName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                rollNumber.isEmpty ? "Designation" : rollNumber,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "MAIN",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: 1.0,
              ),
            ),
          ),
          
          ListTile(
            leading: Icon(Icons.home_outlined, color: const Color(0xFF757897)),
            title: Text(
              "Dashboard",
              style: TextStyle(color: const Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pop(context); // Close Profile
              if (widget.onTabSelected != null) widget.onTabSelected!(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.class_outlined, color: const Color(0xFF757897)),
            title: Text(
              "Classes",
              style: TextStyle(color: const Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pop(context); // Close Profile
              if (widget.onTabSelected != null) widget.onTabSelected!(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.people_outline, color: const Color(0xFF757897)),
            title: Text(
              "Students",
              style: TextStyle(color: const Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pop(context); // Close Profile
              if (widget.onTabSelected != null) widget.onTabSelected!(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment_outlined, color: const Color(0xFF757897)),
            title: Text(
              "Exams",
              style: TextStyle(color: const Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pop(context); // Close Profile
              if (widget.onTabSelected != null) widget.onTabSelected!(3);
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart_outlined, color: const Color(0xFF757897)),
            title: Text(
              "Reports",
              style: TextStyle(color: const Color(0xFF1E2875), fontWeight: FontWeight.w500, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pop(context); // Close Profile
              if (widget.onTabSelected != null) widget.onTabSelected!(4);
            },
          ),
          
          const Divider(height: 20),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              // Just pop to the root
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
