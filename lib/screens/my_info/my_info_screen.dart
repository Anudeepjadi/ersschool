import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';

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
class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
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
    'Jan','Feb','Mar','Apr','May','Jun',
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
                  onPressed: () { setState(() => _profileImage = null); Navigator.pop(ctx); },
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

            // Student ID
            _formField(ctrl: studentIdCtrl, label: 'Student ID', icon: Icons.badge_outlined),
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
                setState(() {
                  name = nameCtrl.text.trim();
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
      'Admission No.': TextEditingController(text: admissionNo),
      'Roll Number': TextEditingController(text: rollNumber),
      'Academic Year': TextEditingController(text: academicYear),
      'Date of Admission': TextEditingController(text: dateOfAdmission),
      'House': TextEditingController(text: house),
    };
    final icons = {
      'Admission No.': Icons.numbers,
      'Roll Number': Icons.format_list_numbered,
      'Academic Year': Icons.calendar_today,
      'Date of Admission': Icons.event,
      'House': Icons.shield,
    };
    _openSimpleEdit('Edit Academic Information', ctrls, icons, () {
      setState(() {
        admissionNo = ctrls['Admission No.']!.text;
        rollNumber = ctrls['Roll Number']!.text;
        academicYear = ctrls['Academic Year']!.text;
        dateOfAdmission = ctrls['Date of Admission']!.text;
        house = ctrls['House']!.text;
      });
    });
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  EDIT PARENT
  // ────────────────────────────────────────────────────────────────────────────
  void _openParentEdit() {
    String extractCode(String p) => p.contains(' ') ? p.split(' ')[0] : '+91';
    String extractNum(String p) => p.contains(' ') ? p.split(' ')[1].replaceAll(RegExp(r'\D'), '') : p.replaceAll(RegExp(r'\D'), '');

    final fNameCtrl = TextEditingController(text: fatherName);
    final fPhoneCtrl = TextEditingController(text: extractNum(fatherPhone));
    final fEmailCtrl = TextEditingController(text: fatherEmail);
    final fOccCtrl = TextEditingController(text: fatherOccupation);
    String selFCode = extractCode(fatherPhone);

    final mNameCtrl = TextEditingController(text: motherName);
    final mPhoneCtrl = TextEditingController(text: extractNum(motherPhone));
    final mEmailCtrl = TextEditingController(text: motherEmail);
    final mOccCtrl = TextEditingController(text: motherOccupation);
    String selMCode = extractCode(motherPhone);

    final formKey = GlobalKey<FormState>();

    Widget phoneRow(String code, TextEditingController ctrl, void Function(String) onCodeChange) {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 56,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: code,
              menuMaxHeight: 300,
              items: _countryCodes.map((c) => DropdownMenuItem(value: c.code, child: Text('${c.flag} ${c.code}', style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: (v) { if (v != null) onCodeChange(v); },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          decoration: _inputDeco('Mobile (10 digits)', Icons.phone).copyWith(counterText: ''),
          validator: (v) => (v != null && v.isNotEmpty && v.length != 10) ? 'Enter 10-digit number' : null,
        )),
      ]);
    }

    String? emailVal(String? v) {
      if (v != null && v.isNotEmpty && !RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.[a-zA-Z]{2,}$').hasMatch(v.trim())) return 'Enter a valid email';
      return null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(builder: (ctx, setSS) {
        return _sheetWrapper(ctx, title: 'Edit Parent Details', child: Form(
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Father Details', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
            const SizedBox(height: 10),
            _formField(ctrl: fNameCtrl, label: 'Father Name', icon: Icons.person),
            const SizedBox(height: 14),
            phoneRow(selFCode, fPhoneCtrl, (c) => setSS(() => selFCode = c)),
            const SizedBox(height: 14),
            _formField(ctrl: fEmailCtrl, label: 'Father Email', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: emailVal),
            const SizedBox(height: 14),
            _formField(ctrl: fOccCtrl, label: 'Father Occupation', icon: Icons.work),
            const SizedBox(height: 24),

            const Text('Mother Details', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E8C))),
            const SizedBox(height: 10),
            _formField(ctrl: mNameCtrl, label: 'Mother Name', icon: Icons.person),
            const SizedBox(height: 14),
            phoneRow(selMCode, mPhoneCtrl, (c) => setSS(() => selMCode = c)),
            const SizedBox(height: 14),
            _formField(ctrl: mEmailCtrl, label: 'Mother Email', icon: Icons.email, keyboardType: TextInputType.emailAddress, validator: emailVal),
            const SizedBox(height: 14),
            _formField(ctrl: mOccCtrl, label: 'Mother Occupation', icon: Icons.work),
            const SizedBox(height: 22),

            _saveBtn(() {
              if (formKey.currentState!.validate()) {
                setState(() {
                  fatherName = fNameCtrl.text.trim();
                  fatherPhone = fPhoneCtrl.text.isEmpty ? '' : '$selFCode ${fPhoneCtrl.text.trim()}';
                  fatherEmail = fEmailCtrl.text.trim();
                  fatherOccupation = fOccCtrl.text.trim();
                  motherName = mNameCtrl.text.trim();
                  motherPhone = mPhoneCtrl.text.isEmpty ? '' : '$selMCode ${mPhoneCtrl.text.trim()}';
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
      backgroundColor: const Color(0xFFF2F4F8),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            // cap max width for desktop
            constraints: const BoxConstraints(maxWidth: 960),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
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
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  1. PROFILE CARD  (matches Image 2 — avatar left, details right, Edit Profile button top-right)
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildProfileCard() {
    return _card(child: Column(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Avatar + camera icon
        Stack(children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
            child: _profileImage == null
                ? const Icon(Icons.person, size: 46, color: AppColors.primary)
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
              Text(name.isEmpty ? 'Student Name' : name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: name.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A))),
              const SizedBox(height: 3),
              Text(
                classSection.isEmpty ? 'Class & Section' : classSection,
                style: TextStyle(fontSize: 13, color: classSection.isEmpty ? Colors.grey.shade400 : AppColors.primary, fontWeight: FontWeight.w600),
              ),
            ])),
            TextButton.icon(
              onPressed: _openEditProfile,
              icon: const Icon(Icons.edit, size: 14),
              label: const Text('Edit Profile', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              ),
            ),
          ]),
          const SizedBox(height: 10),
          _detailLine(Icons.badge_outlined, 'Student ID', studentId),
          _detailLine(Icons.phone_outlined, 'Mobile Number', mobile.isEmpty ? '' : '$countryCode ${_formatMobile(mobile)}'),
          _detailLine(Icons.email_outlined, 'Email Address', email),
          _detailLine(Icons.water_drop_outlined, 'Blood Group', bloodGroup),
        ])),
      ]),
    ]));
  }

  String _formatMobile(String m) {
    final d = m.replaceAll(RegExp(r'\D'), '');
    if (d.length >= 10) return '${d.substring(0, 5)} ${d.substring(5, 10)}';
    return d;
  }

  Widget _detailLine(IconData icon, String label, String value) {
    final bool isEmpty = value.trim().isEmpty;
    final displayValue = isEmpty ? label : value;
    final color = isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A);
    final fw = isEmpty ? FontWeight.normal : FontWeight.w600;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF1A1A1A))),
        ),
        Expanded(child: Text(displayValue, style: TextStyle(fontSize: 12, fontWeight: fw, color: color), overflow: TextOverflow.ellipsis)),
      ]),
    );
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

  void _showReadOnly() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This information is view-only. Please contact the school admin to update it.')),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  3a. ACADEMIC CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildAcademicCard() {
    return _sectionCard(
      icon: Icons.school_rounded,
      iconColor: AppColors.primary,
      title: 'Academic Information',
      onEdit: _showReadOnly,
      child: Column(children: [
        _row2('Admission No.', admissionNo),
        _row2('Class & Section', classSection),
        _row2('Roll Number', rollNumber),
        _row2('Academic Year', academicYear),
        _row2('Date of Admission', dateOfAdmission),
        _row2('House', house),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  //  3b. PARENT CARD
  // ────────────────────────────────────────────────────────────────────────────
  Widget _buildParentCard() {
    return _sectionCard(
      icon: Icons.family_restroom,
      iconColor: AppColors.primary,
      title: 'Parent / Guardian Details',
      onEdit: _showReadOnly,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Father
        const Text('Father', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(fatherName.isEmpty ? 'Father Name' : fatherName, style: TextStyle(fontWeight: fatherName.isEmpty ? FontWeight.normal : FontWeight.bold, fontSize: 13, color: fatherName.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        _contactLine(Icons.phone, fatherPhone),
        _contactLine(Icons.email, fatherEmail),
        _occupationRow('Occupation', fatherOccupation),
        const SizedBox(height: 12),
        // Mother
        const Text('Mother', style: TextStyle(color: Color(0xFFE91E8C), fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 4),
        Text(motherName.isEmpty ? 'Mother Name' : motherName, style: TextStyle(fontWeight: motherName.isEmpty ? FontWeight.normal : FontWeight.bold, fontSize: 13, color: motherName.isEmpty ? Colors.grey.shade400 : const Color(0xFF1A1A1A))),
        const SizedBox(height: 4),
        _contactLine(Icons.phone, motherPhone),
        _contactLine(Icons.email, motherEmail),
        _occupationRow('Occupation', motherOccupation),
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
      onEdit: _showReadOnly,
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
      onEdit: _showReadOnly,
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
}
