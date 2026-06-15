import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  // ── Editable student data ──────────────────────────────────────────────────
  String name = 'Ananya Sharma';
  String classSection = 'Class 8 - A';
  String studentId = 'STU2024001';
  String mobile = '98765 43210';
  String countryCode = '+91';
  String email = 'ananya.sharma@email.com';
  String bloodGroup = 'B+';
  String dob = '12 May 2010';
  String gender = 'Female';
  String address = '12, Green Park,\nNew Delhi - 110016';
  String aadhaar = '1234 5678 9012';

  // Profile photo
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Academic
  String admissionNo = 'ADM2024001';
  String rollNumber = '15';
  String academicYear = '2024 - 2025';
  String dateOfAdmission = '01 Apr 2024';
  String house = 'Blue House';

  // Parent
  String fatherName = 'Rajesh Sharma';
  String fatherPhone = '+91 98765 43211';
  String fatherEmail = 'rajesh.sharma@email.com';
  String fatherOccupation = 'Business';
  String motherName = 'Neha Sharma';
  String motherPhone = '+91 98765 43212';
  String motherEmail = 'neha.sharma@email.com';
  String motherOccupation = 'Teacher';

  // Emergency
  String emergencyContact = 'Amit Sharma (Uncle)';
  String relationship = 'Uncle';
  String emergencyPhone = '+91 98765 43213';

  // Medical
  String allergies = 'None';
  String medicalConditions = 'None';
  String regularMedication = 'None';

  // Other
  String nationality = 'Indian';
  String religion = 'Hindu';
  String casteCategory = 'General';
  String languagesKnown = 'English, Hindi';

  // ── Country codes ─────────────────────────────────────────────────────────
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

  // ── Profile photo upload ───────────────────────────────────────────────────
  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you want to upload your photo',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _photoOptionButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    subtitle: 'Take a photo',
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _photoOptionButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    subtitle: 'Choose existing',
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
            if (_profileImage != null) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() => _profileImage = null);
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

  Widget _photoOptionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _profileImage = File(picked.path);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Profile photo updated successfully!'),
                ],
              ),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text('Could not access ${source == ImageSource.camera ? 'camera' : 'gallery'}. Please check permissions.')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // ── Edit Profile ─────────────────────────────────────────────────────────────
  void _openEditProfile() {
    final nameCtrl = TextEditingController(text: name);
    final mobileCtrl = TextEditingController(text: mobile.replaceAll(' ', ''));
    final emailCtrl = TextEditingController(text: email);
    final addressCtrl = TextEditingController(text: address);

    String selectedGender = gender;
    String selectedBloodGroup = bloodGroup;
    String selectedCountryCode = countryCode;
    DateTime? selectedDob;

    // Try to parse the existing DOB
    try {
      selectedDob = _parseDateString(dob);
    } catch (_) {
      selectedDob = null;
    }

    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    _buildTextField(
                      controller: nameCtrl,
                      label: 'Full Name',
                      icon: Icons.person,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Name is required';
                        if (v.trim().length < 2) return 'Name must be at least 2 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Mobile Number with Country Code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country code dropdown
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCountryCode,
                              items: _countryCodes.map((c) {
                                return DropdownMenuItem(
                                  value: c.code,
                                  child: Text(
                                    '${c.flag} ${c.code}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setSheetState(() => selectedCountryCode = v);
                                }
                              },
                              icon: const Icon(Icons.arrow_drop_down, size: 20),
                              isDense: false,
                              menuMaxHeight: 300,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Phone number field (10 digits only)
                        Expanded(
                          child: TextFormField(
                            controller: mobileCtrl,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: const Icon(Icons.phone, color: AppColors.primary, size: 20),
                              counterText: '',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.primary, width: 2),
                              ),
                              hintText: '10-digit number',
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Phone number is required';
                              if (v.length != 10) return 'Must be exactly 10 digits';
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Email with validation
                    _buildTextField(
                      controller: emailCtrl,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        final emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\.\-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegex.hasMatch(v.trim())) return 'Enter a valid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Blood Group dropdown
                    _buildDropdownField(
                      label: 'Blood Group',
                      icon: Icons.bloodtype,
                      value: selectedBloodGroup,
                      items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                      onChanged: (v) {
                        if (v != null) setSheetState(() => selectedBloodGroup = v);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Date of Birth - date picker
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDob ?? DateTime(now.year - 10, 1, 1),
                          firstDate: DateTime(1990),
                          lastDate: now,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: Color(0xFF1E1E1E),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setSheetState(() => selectedDob = picked);
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: const Icon(Icons.cake, color: AppColors.primary, size: 20),
                            suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary, width: 2),
                            ),
                            hintText: selectedDob != null
                                ? _formatDate(selectedDob!)
                                : 'Select date of birth',
                          ),
                          controller: TextEditingController(
                            text: selectedDob != null ? _formatDate(selectedDob!) : '',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Gender dropdown (Male / Female only)
                    _buildDropdownField(
                      label: 'Gender',
                      icon: Icons.wc,
                      value: selectedGender,
                      items: const ['Male', 'Female'],
                      onChanged: (v) {
                        if (v != null) setSheetState(() => selectedGender = v);
                      },
                    ),
                    const SizedBox(height: 14),

                    // Address
                    _buildTextField(
                      controller: addressCtrl,
                      label: 'Address',
                      icon: Icons.home,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              name = nameCtrl.text.trim();
                              mobile = mobileCtrl.text.trim();
                              countryCode = selectedCountryCode;
                              email = emailCtrl.text.trim();
                              bloodGroup = selectedBloodGroup;
                              dob = selectedDob != null ? _formatDate(selectedDob!) : dob;
                              gender = selectedGender;
                              address = addressCtrl.text.trim();
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helper: build validated text field ──────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }

  // ── Helper: build dropdown field ───────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(value) ? value : items.first,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  // ── Date helpers ──────────────────────────────────────────────────────────
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]} ${d.year}';
  }

  DateTime? _parseDateString(String s) {
    // Parse "12 May 2010" format
    final parts = s.split(' ');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final monthIdx = _months.indexOf(parts[1]) + 1;
    final year = int.tryParse(parts[2]);
    if (day == null || monthIdx == 0 || year == null) return null;
    return DateTime(year, monthIdx, day);
  }

  // ── Section editors ───────────────────────────────────────────────────────────
  void _openAcademicEdit() {
    final admCtrl = TextEditingController(text: admissionNo);
    final rollCtrl = TextEditingController(text: rollNumber);
    final yearCtrl = TextEditingController(text: academicYear);
    final dateCtrl = TextEditingController(text: dateOfAdmission);
    final houseCtrl = TextEditingController(text: house);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Academic Information',
        fields: [
          _FieldDef('Admission No.', admCtrl, Icons.numbers),
          _FieldDef('Roll Number', rollCtrl, Icons.format_list_numbered),
          _FieldDef('Academic Year', yearCtrl, Icons.calendar_today),
          _FieldDef('Date of Admission', dateCtrl, Icons.event),
          _FieldDef('House', houseCtrl, Icons.shield),
        ],
        onSave: () {
          setState(() {
            admissionNo = admCtrl.text;
            rollNumber = rollCtrl.text;
            academicYear = yearCtrl.text;
            dateOfAdmission = dateCtrl.text;
            house = houseCtrl.text;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openParentEdit() {
    final fnCtrl = TextEditingController(text: fatherName);
    final fpCtrl = TextEditingController(text: fatherPhone);
    final feCtrl = TextEditingController(text: fatherEmail);
    final foCtrl = TextEditingController(text: fatherOccupation);
    final mnCtrl = TextEditingController(text: motherName);
    final mpCtrl = TextEditingController(text: motherPhone);
    final meCtrl = TextEditingController(text: motherEmail);
    final moCtrl = TextEditingController(text: motherOccupation);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Parent / Guardian Details',
        fields: [
          _FieldDef('Father Name', fnCtrl, Icons.person),
          _FieldDef('Father Phone', fpCtrl, Icons.phone),
          _FieldDef('Father Email', feCtrl, Icons.email),
          _FieldDef('Father Occupation', foCtrl, Icons.work),
          _FieldDef('Mother Name', mnCtrl, Icons.person),
          _FieldDef('Mother Phone', mpCtrl, Icons.phone),
          _FieldDef('Mother Email', meCtrl, Icons.email),
          _FieldDef('Mother Occupation', moCtrl, Icons.work),
        ],
        onSave: () {
          setState(() {
            fatherName = fnCtrl.text;
            fatherPhone = fpCtrl.text;
            fatherEmail = feCtrl.text;
            fatherOccupation = foCtrl.text;
            motherName = mnCtrl.text;
            motherPhone = mpCtrl.text;
            motherEmail = meCtrl.text;
            motherOccupation = moCtrl.text;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openEmergencyEdit() {
    final ecCtrl = TextEditingController(text: emergencyContact);
    final relCtrl = TextEditingController(text: relationship);
    final phoneCtrl = TextEditingController(text: emergencyPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Emergency Contact',
        fields: [
          _FieldDef('Contact Name', ecCtrl, Icons.person),
          _FieldDef('Relationship', relCtrl, Icons.people),
          _FieldDef('Phone Number', phoneCtrl, Icons.phone),
        ],
        onSave: () {
          setState(() {
            emergencyContact = ecCtrl.text;
            relationship = relCtrl.text;
            emergencyPhone = phoneCtrl.text;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openMedicalEdit() {
    final alCtrl = TextEditingController(text: allergies);
    final mcCtrl = TextEditingController(text: medicalConditions);
    final rmCtrl = TextEditingController(text: regularMedication);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditSheet(
        title: 'Edit Medical Information',
        fields: [
          _FieldDef('Allergies', alCtrl, Icons.warning_amber),
          _FieldDef('Medical Conditions', mcCtrl, Icons.medical_services),
          _FieldDef('Regular Medication', rmCtrl, Icons.medication),
        ],
        onSave: () {
          setState(() {
            allergies = alCtrl.text;
            medicalConditions = mcCtrl.text;
            regularMedication = rmCtrl.text;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            _buildHeader(),
            const SizedBox(height: 16),

            // ── Quick Stats row (DOB / Gender / Address / Aadhaar) ──────────
            _buildQuickStatsRow(),
            const SizedBox(height: 16),

            // ── Academic + Parent ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAcademicCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildParentCard()),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Emergency + Medical ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildEmergencyCard()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMedicalCard()),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Other Information ───────────────────────────────────────────
            _buildOtherInfoCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Profile Header ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with photo upload
              Stack(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 44,
                            color: AppColors.primary,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showPhotoOptions,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Name + info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _openEditProfile,
                          icon: const Icon(Icons.edit, size: 14),
                          label: const Text('Edit Profile', style: TextStyle(fontSize: 13)),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        classSection,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _infoRow(Icons.badge_outlined, 'Student ID', studentId),
                    const SizedBox(height: 6),
                    _infoRow(Icons.phone_outlined, 'Mobile Number', '$countryCode $mobile'),
                    const SizedBox(height: 6),
                    _infoRow(Icons.email_outlined, 'Email Address', email),
                    const SizedBox(height: 6),
                    _infoRow(Icons.water_drop_outlined, 'Blood Group', bloodGroup),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E1E),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ── Quick Stats Row ─────────────────────────────────────────────────────────
  Widget _buildQuickStatsRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _quickStat(Icons.cake_outlined, 'Date of Birth', dob),
          _vDivider(),
          _quickStat(Icons.wc, 'Gender', gender),
          _vDivider(),
          _quickStat(Icons.home_outlined, 'Address', address, small: true),
          _vDivider(),
          _quickStat(Icons.shield_outlined, 'Aadhaar No.', aadhaar, small: true),
        ],
      ),
    );
  }

  Widget _quickStat(IconData icon, String label, String value, {bool small = false}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E1E),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    height: 50,
    color: Colors.grey.shade200,
  );

  // ── Academic Card ────────────────────────────────────────────────────────────
  Widget _buildAcademicCard() {
    return _SectionCard(
      icon: Icons.school,
      iconColor: AppColors.primary,
      title: 'Academic Information',
      onEdit: _openAcademicEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('Admission No.', admissionNo),
          _detailRow('Class & Section', classSection),
          _detailRow('Roll Number', rollNumber),
          _detailRow('Academic Year', academicYear),
          _detailRow('Date of Admission', dateOfAdmission),
          _detailRow('House', house),
        ],
      ),
    );
  }

  // ── Parent Card ──────────────────────────────────────────────────────────────
  Widget _buildParentCard() {
    return _SectionCard(
      icon: Icons.family_restroom,
      iconColor: AppColors.primary,
      title: 'Parent / Guardian Details',
      onEdit: _openParentEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Father', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(fatherName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 3),
          _parentContactRow(Icons.phone, fatherPhone),
          _parentContactRow(Icons.email, fatherEmail),
          Row(
            children: [
              Text('Occupation ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Expanded(
                child: Text(fatherOccupation, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Mother', style: TextStyle(color: Color(0xFFE91E8C), fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 4),
          Text(motherName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 3),
          _parentContactRow(Icons.phone, motherPhone),
          _parentContactRow(Icons.email, motherEmail),
          Row(
            children: [
              Text('Occupation ', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Expanded(
                child: Text(motherOccupation, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _parentContactRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  // ── Emergency Card ───────────────────────────────────────────────────────────
  Widget _buildEmergencyCard() {
    return _SectionCard(
      icon: Icons.emergency,
      iconColor: Colors.redAccent,
      title: 'Emergency Contact',
      onEdit: _openEmergencyEdit,
      child: Column(
        children: [
          _detailRow('Contact Name', emergencyContact),
          _detailRow('Relationship', relationship),
          _detailRow('Phone Number', emergencyPhone),
        ],
      ),
    );
  }

  // ── Medical Card ─────────────────────────────────────────────────────────────
  Widget _buildMedicalCard() {
    return _SectionCard(
      icon: Icons.favorite,
      iconColor: Colors.green,
      title: 'Medical Information',
      onEdit: _openMedicalEdit,
      child: Column(
        children: [
          _detailRow('Allergies', allergies),
          _detailRow('Medical Conditions', medicalConditions),
          _detailRow('Regular Medication', regularMedication),
        ],
      ),
    );
  }

  // ── Other Info ────────────────────────────────────────────────────────────────
  Widget _buildOtherInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline, color: Colors.orange, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'Other Information',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _detailRow('Nationality', nationality),
                    _detailRow('Caste Category', casteCategory),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _detailRow('Religion', religion),
                    _detailRow('Languages Known', languagesKnown),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Shared detail row ─────────────────────────────────────────────────────────
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E1E1E)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Country code model ──────────────────────────────────────────────────────────
class _CountryCode {
  final String code;
  final String flag;
  final String name;

  const _CountryCode(this.code, this.flag, this.name);
}

// ── Reusable section card ──────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;
  final VoidCallback? onEdit;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 15),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
                ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

// ── Edit bottom sheet (for non-profile sections) ─────────────────────────────
class _FieldDef {
  final String label;
  final TextEditingController controller;
  final IconData icon;

  _FieldDef(this.label, this.controller, this.icon);
}

class _EditSheet extends StatelessWidget {
  final String title;
  final List<_FieldDef> fields;
  final VoidCallback onSave;

  const _EditSheet({
    required this.title,
    required this.fields,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            ...fields.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextField(
                  controller: f.controller,
                  decoration: InputDecoration(
                    labelText: f.label,
                    prefixIcon: Icon(f.icon, color: AppColors.primary, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
