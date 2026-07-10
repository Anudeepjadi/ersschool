import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import 'package:image_picker/image_picker.dart';
// import 'dart:io';
import 'package:flutter/foundation.dart';
import '../widgets/admin_bottom_nav_bar.dart';

class AdminRegisterEmployeeScreen extends StatefulWidget {
  final bool isEditMode;
  final Map<String, dynamic>? employee;
  final String staffType;
  const AdminRegisterEmployeeScreen({super.key, this.isEditMode = false, this.employee, this.staffType = 'Employee'});

  @override
  State<AdminRegisterEmployeeScreen> createState() => _AdminRegisterEmployeeScreenState();
}

class _AdminRegisterEmployeeScreenState extends State<AdminRegisterEmployeeScreen> {
  dynamic _employeePhoto; // Removed File for web compatibility
  final ImagePicker _picker = ImagePicker();
  late Map<String, dynamic> _formData;

  @override
  void initState() {
    super.initState();
    _formData = Map.from(widget.employee ?? {});
    final photo = _formData['avatar'] ?? _formData['photoPath'];
    if (photo != null && !kIsWeb) {
      // _employeePhoto = File(photo.toString());
    }
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 85);
      if (picked != null && mounted) {
        setState(() {
          // if (!kIsWeb) _employeePhoto = File(picked.path);
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
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
      appBar: AdminAppBar(
        title: widget.isEditMode ? "Edit Employee".tr : "Register New Employee".tr,
        subtitle: "Fill the details below",
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Employee Saved!".tr), backgroundColor: Colors.green));
                      Navigator.pop(context, _formData);
                    },
                    icon: const Icon(Icons.save, size: 18),
                    label: Text("Save Employee".tr),
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
                    title: "Employee Identity",
                    icon: Icons.badge_outlined,
                    children: [
                      _buildTextField("Full Name *", initialValue: _formData['name'], onChanged: (v) => _formData['name'] = v),
                      _buildTextField("Employee Code", hint: "Enter Code", initialValue: _formData['employeeCode'], onChanged: (v) => _formData['employeeCode'] = v),
                      _buildDropdownField("Gender", _formData['gender'] ?? "Male", items: ["Male", "Female"], onChanged: (v) => setState(() => _formData['gender'] = v)),
                      _buildTextField("Aadhaar Number", initialValue: _formData['aadhaar'], onChanged: (v) => _formData['aadhaar'] = v),
                    ],
                  ),

                  _buildFormCard(
                    title: "Personal & Contact",
                    icon: Icons.person_outline,
                    children: [
                      _buildTextField("Date of Birth", hint: "dd/mm/yyyy", icon: Icons.calendar_month, initialValue: _formData['dob'], onTap: () => _selectDate('dob')),
                      _buildTextField("Primary Mobile *", initialValue: _formData['phone']?.toString().replaceAll(',', ''), onChanged: (v) => _formData['phone'] = v),
                      _buildTextField("Primary Email", initialValue: _formData['email'], onChanged: (v) => _formData['email'] = v),
                      _buildTextField("Secondary Mobile", initialValue: _formData['secondary_mobile'], onChanged: (v) => _formData['secondary_mobile'] = v),
                      _buildTextField("Address", maxLines: 3, initialValue: _formData['address'], onChanged: (v) => _formData['address'] = v),
                    ],
                  ),

                  _buildFormCard(
                    title: "Professional Details",
                    icon: Icons.work_outline,
                    children: [
                      _buildDropdownField("Branch", _formData['school'] ?? "Ecstasy School 1 (ECS001)", items: ["Ecstasy School 1 (ECS001)", "Ecstasy School 2 (ECS002)", "Ecstasy (ECS003)", "Ecstasy (ECS004)"], onChanged: (v) => setState(() => _formData['school'] = v)),
                      _buildDropdownField("Department", _formData['department'] ?? "Teaching", items: ["Teaching", "Administration", "Support Staff", "Transport", "Other"], onChanged: (v) => setState(() => _formData['department'] = v)),
                      _buildTextField("Designation / Subject", initialValue: _formData['subject'], onChanged: (v) => _formData['subject'] = v),
                      _buildDropdownField("Employee Type", _formData['employee_type'] ?? "Full Time", items: ["Full Time", "Part Time", "Contract"], onChanged: (v) => setState(() => _formData['employee_type'] = v)),
                      _buildTextField("Experience", hint: "e.g., 5 years", initialValue: _formData['experience'], onChanged: (v) => _formData['experience'] = v),
                      _buildTextField("Date of Join", hint: "dd/mm/yyyy", icon: Icons.calendar_month, initialValue: _formData['date_of_join'], onTap: () => _selectDate('date_of_join')),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            Switch(
                              value: _formData['status'] != 'Inactive', 
                              onChanged: (v) { setState(() { _formData['status'] = v ? 'Active' : 'Inactive'; }); },
                              activeThumbColor: AppColors.primary,
                            ),
                            Text("Employee is Active".tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                          ],
                        ),
                      ),
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
                  backgroundImage: null,
                  child: _employeePhoto == null ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
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
            widget.isEditMode ? "Update Employee Photo".tr : "Upload Employee Photo".tr,
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
      firstDate: DateTime(1950),
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
