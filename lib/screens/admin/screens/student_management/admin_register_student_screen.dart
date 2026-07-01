import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/admin_bottom_nav_bar.dart';

class AdminRegisterStudentScreen extends StatefulWidget {
  final bool isEditMode;
  final Map<String, dynamic>? student;
  const AdminRegisterStudentScreen({super.key, this.isEditMode = false, this.student});

  @override
  State<AdminRegisterStudentScreen> createState() => _AdminRegisterStudentScreenState();
}

class _AdminRegisterStudentScreenState extends State<AdminRegisterStudentScreen> {
  File? _studentPhoto;
  final ImagePicker _picker = ImagePicker();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = Map.from(widget.student ?? {});
    final photo = _formData['avatar'] ?? _formData['photoPath'];
    if (photo != null) {
      _studentPhoto = File(photo.toString());
    }
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 85);
      if (picked != null && mounted) {
        setState(() {
          _studentPhoto = File(picked.path);
          _formData['avatar'] = picked.path;
          _formData['photoPath'] = picked.path; // Keep for safety
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 1),
      appBar: AdminAppBar(
        title: widget.isEditMode ? "Edit Student".tr : "Register Student".tr,
        subtitle: "Manage student registration",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Action Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Close".tr),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Student Saved!".tr), backgroundColor: Colors.green));
                      Navigator.pop(context, _formData);
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: Text("Save Student".tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile Photo Header
            _buildPhotoHeader(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildFormCard(
                    title: "Student Identity",
                    icon: Icons.badge_outlined,
                    children: [
                      _buildTextField("Full Name *", initialValue: _formData['name'], onChanged: (v) => _formData['name'] = v),
                      _buildTextField("Admission Number", hint: "Auto-generated if empty", initialValue: _formData['admission'] ?? _formData['admNo'], onChanged: (v) => _formData['admission'] = v),
                      _buildTextField("Roll Number", initialValue: _formData['roll']?.toString().replaceAll('Roll No: ', ''), onChanged: (v) => _formData['roll'] = v),
                      _buildDropdownField("Gender", _formData['gender'] ?? "Male", items: ["Male", "Female"], onChanged: (v) => setState(() => _formData['gender'] = v)),
                      _buildTextField("Aadhaar Number", initialValue: _formData['aadhaar'], onChanged: (v) => _formData['aadhaar'] = v),
                    ],
                  ),

                  _buildFormCard(
                    title: "Personal & Contact",
                    icon: Icons.person_outline,
                    children: [
                      _buildTextField("Date of Birth", hint: "dd/mm/yyyy", icon: Icons.calendar_month, initialValue: _formData['dob'], onTap: () => _selectDate('dob')),
                      _buildTextField("Primary Mobile *", initialValue: (_formData['mobile'] ?? _formData['phone'])?.toString().replaceAll(',', ''), onChanged: (v) { _formData['mobile'] = v; _formData['phone'] = v; }),
                      _buildTextField("Primary Email", initialValue: _formData['email'], onChanged: (v) => _formData['email'] = v),
                      _buildTextField("Secondary Mobile", initialValue: _formData['secondary_mobile'], onChanged: (v) => _formData['secondary_mobile'] = v),
                      _buildTextField("Caste", initialValue: _formData['caste'], onChanged: (v) => _formData['caste'] = v),
                      _buildTextField("Address", maxLines: 3, initialValue: _formData['address'], onChanged: (v) => _formData['address'] = v),
                    ],
                  ),

                  _buildFormCard(
                    title: "Academic Information",
                    icon: Icons.school_outlined,
                    children: [
                      _buildDropdownField("Branch", _formData['branch'] ?? "Ecstasy School 1 (ECS001)", items: ["Ecstasy School 1 (ECS001)", "Ecstay School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], onChanged: (v) => setState(() => _formData['branch'] = v)),
                      _buildDropdownField("Academic Year", _formData['academic_year'] ?? "2025-26", items: ["2025-26", "2026-27"], onChanged: (v) => setState(() => _formData['academic_year'] = v)),
                      _buildDropdownField("Study Class", _formData['class'] ?? "Class 1", items: ["Passed out", "LKG", "UKG", "Class 1", "Class 2", "Class 3", "Class 4", "Class 5", "Class 6", "Class 7", "Class 8", "Class 9", "Class 10"], onChanged: (v) => setState(() => _formData['class'] = v)),
                      _buildDropdownField("First Language", _formData['first_language'] ?? "English", items: ["English", "Hindi", "Telugu", "Tamil", "Kannada", "Malayalam", "Marathi", "Sanskrit", "French", "None"], onChanged: (v) => setState(() => _formData['first_language'] = v)),
                      _buildDropdownField("Second Language", _formData['second_language'] ?? "Hindi", items: ["English", "Hindi", "Telugu", "Tamil", "Kannada", "Malayalam", "Marathi", "Sanskrit", "French", "None"], onChanged: (v) => setState(() => _formData['second_language'] = v)),
                      _buildDropdownField("Third Language", _formData['third_language'] ?? "Telugu", items: ["English", "Hindi", "Telugu", "Tamil", "Kannada", "Malayalam", "Marathi", "Sanskrit", "French", "None"], onChanged: (v) => setState(() => _formData['third_language'] = v)),
                      _buildTextField("Admission Date", hint: "dd/mm/yyyy", icon: Icons.calendar_month, initialValue: _formData['admission_date'], onTap: () => _selectDate('admission_date')),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Switch(
                              value: _formData['status'] != 'Inactive', 
                              onChanged: (v) { setState(() { _formData['status'] = v ? 'Active' : 'Inactive'; }); },
                              activeThumbColor: AppColors.primary,
                            ),
                            Text("Student is Active".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                          ],
                        ),
                      ),
                    ],
                  ),

                  _buildFormCard(
                    title: "Parent / Guardian Details",
                    icon: Icons.family_restroom_outlined,
                    children: [
                      _buildTextField("Father Name", initialValue: _formData['father'], onChanged: (v) => _formData['father'] = v),
                      _buildTextField("Father Occupation", initialValue: _formData['father_occupation'], onChanged: (v) => _formData['father_occupation'] = v),
                      const Divider(height: 32),
                      _buildTextField("Mother Name", initialValue: _formData['mother'], onChanged: (v) => _formData['mother'] = v),
                      _buildTextField("Mother Occupation", initialValue: _formData['mother_occupation'], onChanged: (v) => _formData['mother_occupation'] = v),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.1), width: 2),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade100,
                  backgroundImage: _studentPhoto != null ? FileImage(_studentPhoto!) : null,
                  child: _studentPhoto == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.isEditMode ? "Update Student Photo".tr : "Upload Student Photo".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF334155))),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(String key) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _formData[key] = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _buildTextField(String label, {String? hint, IconData? icon, int maxLines = 1, VoidCallback? onTap, String? initialValue, ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          TextFormField(
            key: onTap != null ? ValueKey(initialValue) : null,
            initialValue: initialValue,
            onChanged: onChanged,
            maxLines: maxLines,
            readOnly: onTap != null,
            onTap: onTap,
            style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
            decoration: InputDecoration(
              hintText: hint?.tr,
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              suffixIcon: icon != null ? Icon(icon, color: AppColors.primary, size: 20) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, {required List<String> items, required ValueChanged<String?> onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: items.contains(value) ? value : items.first,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF94A3B8)),
                style: const TextStyle(fontSize: 14, color: Color(0xFF1E293B)),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item.tr),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
