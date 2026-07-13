import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/admin_app_bar.dart';

class AdminAddDriverScreen extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  const AdminAddDriverScreen({super.key, this.existingData});

  @override
  State<AdminAddDriverScreen> createState() => _AdminAddDriverScreenState();
}

class _AdminAddDriverScreenState extends State<AdminAddDriverScreen> {
  // Controllers
  late TextEditingController codeCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController primaryMobileCtrl;
  late TextEditingController secondaryMobileCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController aadhaarCtrl;
  late TextEditingController designationCtrl;
  late TextEditingController drivingLicenseCtrl;
  late TextEditingController badgeNumberCtrl;
  late TextEditingController salaryCtrl;
  late TextEditingController otherDetailsCtrl;

  // Dropdown values
  String branch = "Ecstasy School 1 (ECS001)";
  String gender = "Male";
  String employeeType = "Full Time Employee";
  String employeeRole = "Driver";

  // Dates
  DateTime? dob;
  DateTime? dateOfJoin;
  DateTime? dateOfRelieve;

  // Checkbox
  bool isActive = true;

  // Image
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    final data = widget.existingData;
    codeCtrl = TextEditingController(text: data?['code'] ?? data?['employeeCode'] ?? '');
    nameCtrl = TextEditingController(text: data?['name'] ?? '');
    primaryMobileCtrl = TextEditingController(text: data?['mobile'] ?? data?['phone'] ?? '');
    secondaryMobileCtrl = TextEditingController(text: data?['secondaryMobile'] ?? '');
    emailCtrl = TextEditingController(text: data?['email'] ?? '');
    addressCtrl = TextEditingController(text: data?['address'] ?? '');
    aadhaarCtrl = TextEditingController(text: data?['aadhaar'] ?? '');
    designationCtrl = TextEditingController(text: data?['designation'] ?? '');
    drivingLicenseCtrl = TextEditingController(text: data?['driving_license'] ?? '');
    badgeNumberCtrl = TextEditingController(text: data?['badge_number'] ?? '');
    salaryCtrl = TextEditingController(text: data?['salary']?.toString() ?? '');
    otherDetailsCtrl = TextEditingController(text: data?['other_details'] ?? '');

    branch = data?['branch'] ?? "Ecstasy School 1 (ECS001)";
    gender = data?['gender'] ?? "Male";
    employeeType = data?['employee_type'] ?? "Full Time Employee";
    employeeRole = data?['role'] ?? "Driver";
    isActive = data?['status'] == 'Active' || data?['status'] == null;
    if (data?['photo_path'] != null) {
      _imageFile = XFile(data!['photo_path']);
    }
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
    primaryMobileCtrl.dispose();
    secondaryMobileCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    aadhaarCtrl.dispose();
    designationCtrl.dispose();
    drivingLicenseCtrl.dispose();
    badgeNumberCtrl.dispose();
    salaryCtrl.dispose();
    otherDetailsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;
    double fieldWidth = isMobile ? double.infinity : 380;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(
        title: widget.existingData == null ? "Add Driver Details".tr : "Edit Driver Details".tr,
        subtitle: "Manage driver information".tr,
        showSchoolSelector: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          padding: const EdgeInsets.all(24.0),
          child: Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Section
              SizedBox(
                width: isMobile ? double.infinity : 160,
                child: Column(
                  children: [
                    Container(
                      width: 140,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _imageFile != null
                          ? kIsWeb
                              ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                              : Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                          : const Center(child: Icon(Icons.person, size: 60, color: Colors.grey)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E283C),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(140, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Text("Change Photo".tr, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              if (isMobile) const SizedBox(height: 32) else const SizedBox(width: 48),
              
              // Form Section
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E283C),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text("Close".tr),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final updatedData = {
                              'code': codeCtrl.text,
                              'employeeCode': codeCtrl.text,
                              'name': nameCtrl.text,
                              'mobile': primaryMobileCtrl.text,
                              'phone': primaryMobileCtrl.text,
                              'secondaryMobile': secondaryMobileCtrl.text,
                              'email': emailCtrl.text,
                              'address': addressCtrl.text,
                              'aadhaar': aadhaarCtrl.text,
                              'designation': designationCtrl.text,
                              'driving_license': drivingLicenseCtrl.text,
                              'badge_number': badgeNumberCtrl.text,
                              'salary': salaryCtrl.text,
                              'other_details': otherDetailsCtrl.text,
                              'branch': branch,
                              'gender': gender,
                              'employee_type': employeeType,
                              'role': employeeRole,
                              'status': isActive ? 'Active' : 'Inactive',
                              'photo_path': _imageFile?.path ?? widget.existingData?['photo_path'],
                            };
                            Navigator.pop(context, updatedData);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD35400),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text("Save".tr),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      children: [
                        SizedBox(width: fieldWidth, child: _buildTextField("Employee Code", codeCtrl)),
                        SizedBox(width: fieldWidth, child: _buildDropdown("Branch", branch, ["Ecstasy School 1 (ECS001)", "Ecstasy School 2"], (v) => setState(() => branch = v!))),
                        
                        SizedBox(width: double.infinity, child: _buildTextField("Full Name *", nameCtrl)),
                        
                        SizedBox(width: fieldWidth, child: _buildDropdown("Gender", gender, ["Male", "Female", "Other"], (v) => setState(() => gender = v!))),
                        SizedBox(width: fieldWidth, child: _buildDatePicker("Date of Birth", dob, (v) => setState(() => dob = v))),
                        
                        SizedBox(width: fieldWidth, child: _buildTextField("Primary Contact Mobile *", primaryMobileCtrl)),
                        SizedBox(width: fieldWidth, child: _buildTextField("Secondary Contact Mobile", secondaryMobileCtrl)),
                        
                        SizedBox(width: double.infinity, child: _buildTextField("Email", emailCtrl)),
                        
                        // Address and Employee Types
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 24,
                            runSpacing: 16,
                            children: [
                              SizedBox(width: fieldWidth, child: _buildTextField("Address", addressCtrl, maxLines: 5)),
                              SizedBox(
                                width: fieldWidth, 
                                child: Column(
                                  children: [
                                    _buildDropdown("Employee Type", employeeType, ["Full Time Employee", "Part Time Employee"], (v) => setState(() => employeeType = v!)),
                                    const SizedBox(height: 16),
                                    _buildDropdown("Employee Role", employeeRole, ["Driver", "Attender"], (v) => setState(() => employeeRole = v!)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: fieldWidth, child: _buildTextField("Aadhaar Number", aadhaarCtrl)),
                        SizedBox(width: fieldWidth, child: _buildTextField("Designation", designationCtrl)),
                        
                        SizedBox(width: fieldWidth, child: _buildTextField("Driving License Number", drivingLicenseCtrl)),
                        SizedBox(width: fieldWidth, child: _buildTextField("Badge Number", badgeNumberCtrl)),
                        
                        SizedBox(width: fieldWidth, child: _buildDatePicker("Date of Join", dateOfJoin, (v) => setState(() => dateOfJoin = v))),
                        SizedBox(width: fieldWidth, child: _buildDatePicker("Date of Relieve", dateOfRelieve, (v) => setState(() => dateOfRelieve = v))),
                        
                        SizedBox(width: fieldWidth, child: _buildTextField("Salary", salaryCtrl)),
                        SizedBox(
                          width: fieldWidth, 
                          child: Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isActive,
                                  onChanged: (v) => setState(() => isActive = v ?? true),
                                  activeColor: const Color(0xFF0D6EFD),
                                ),
                                Text("Is Active".tr, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(width: double.infinity, child: _buildTextField("Other Details", otherDetailsCtrl, maxLines: 3)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item.tr, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, ValueChanged<DateTime> onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}" : "dd/mm/yyyy",
                  style: TextStyle(fontSize: 14, color: selectedDate != null ? Colors.black87 : Colors.grey),
                ),
                const Icon(Icons.calendar_month, color: Color(0xFFC0392B), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
