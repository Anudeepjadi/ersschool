import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';

class AdminRegisterEmployeeScreen extends StatefulWidget {
  final Map<String, dynamic>? employee;
  final String? staffType; // 'Employee' | 'Teacher' | 'Attender'
  const AdminRegisterEmployeeScreen({super.key, this.employee, this.staffType});

  @override
  State<AdminRegisterEmployeeScreen> createState() => _AdminRegisterEmployeeScreenState();
}

class _AdminRegisterEmployeeScreenState extends State<AdminRegisterEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobile1Controller = TextEditingController();
  final TextEditingController _mobile2Controller = TextEditingController();
  final TextEditingController _email1Controller = TextEditingController();
  final TextEditingController _email2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _dojController = TextEditingController();
  final TextEditingController _dorController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _otherDetailsController = TextEditingController();

  File? _selectedImage;
  String? _selectedImageName;
  final ImagePicker _picker = ImagePicker();

  // Dropdown values
  String _selectedBranch = 'Ecstasy School 1';
  String _selectedGender = 'Female';
  String _selectedType = 'Full Time Employee';
  String _selectedRole = 'Employee';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      final emp = widget.employee!;
      _codeController.text = emp['employeeCode'] ?? '';
      _nameController.text = emp['name'] ?? '';
      _mobile1Controller.text = emp['phone'] ?? '';
      _designationController.text = emp['subject'] ?? '';
      _selectedBranch = emp['school'] ?? 'Ecstasy School 1';
      _selectedGender = emp['gender'] ?? 'Female';
      _selectedRole = emp['department'] ?? 'Employee';
      _isActive = emp['status'] == 'Active';
    } else if (widget.staffType != null) {
      if (widget.staffType == 'Teacher') _selectedRole = 'Teacher';
      if (widget.staffType == 'Attender') _selectedRole = 'Attender';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _mobile1Controller.dispose();
    _mobile2Controller.dispose();
    _email1Controller.dispose();
    _email2Controller.dispose();
    _addressController.dispose();
    _designationController.dispose();
    _aadhaarController.dispose();
    _dojController.dispose();
    _dorController.dispose();
    _salaryController.dispose();
    _otherDetailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E2875),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage(StateSetter setModalState) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _selectedImageName = image.name;
        });
        // Also update the modal's state to reflect the change immediately
        setModalState(() {});
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showUploadPhotoPopup() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Upload Photo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _pickImage(setModalState),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text("Choose File", style: TextStyle(fontSize: 12, color: Color(0xFF1E2875), fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedImageName ?? "No file chosen",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                              _selectedImageName = null;
                            });
                            setModalState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Remove", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF757897),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final nameParts = name.split(' ');
      String avatar = name.substring(0, 1).toUpperCase();
      if (nameParts.length > 1) {
        avatar = (nameParts[0][0] + nameParts[1][0]).toUpperCase();
      }

      final newEmployee = {
        'name': name,
        'employeeCode': _codeController.text.isEmpty
            ? 'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}'
            : _codeController.text,
        'school': _selectedBranch,
        'status': _isActive ? 'Active' : 'Inactive',
        'subject': _designationController.text.isEmpty ? 'Staff' : _designationController.text,
        'department': _selectedRole,
        'phone': _mobile1Controller.text.trim(),
        'experience': 'N/A',
        'gender': _selectedGender,
        'avatar': avatar,
      };

      if (widget.employee != null) {
        // Update existing
        final index = AppDataStore.instance.teachers.indexOf(widget.employee!);
        if (index != -1) {
          AppDataStore.instance.teachers[index] = {
            ...widget.employee!,
            ...newEmployee,
          };
        }
      } else {
        // Add new
        AppDataStore.instance.addTeacher(newEmployee);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.employee != null ? "Employee $name updated!" : "Employee $name saved!"),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 2),
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ─── Top Header & Action Bar ─────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _topActionBtn("Close", const Color(0xFF1E2843), () => Navigator.pop(context)),
                        const SizedBox(width: 10),
                        _topActionBtn("Save", AppColors.primary, _saveEmployee),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.employee != null ? "Update Employee" : "Register New Employee",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2875),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ─── Main Form Content ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Photo Section (Left)
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                    image: _selectedImage != null
                                        ? DecorationImage(
                                            image: FileImage(_selectedImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _selectedImage == null
                                      ? Icon(Icons.person, size: 80, color: Colors.grey.shade400)
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _showUploadPhotoPopup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    elevation: 0,
                                  ),
                                  child: const Text("Change Photo", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Top Right Fields (Employee Code & Branch)
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildFieldLabel("Employee Code"),
                                _buildTextField(_codeController, "Enter Code"),
                                const SizedBox(height: 16),
                                _buildFieldLabel("Branch"),
                                _buildDropdown(['Ecstasy School 1', 'Ecstasy School 2', 'Ecstasy School 3'], _selectedBranch, (val) => setState(() => _selectedBranch = val!)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Full Name (Full Width)
                      _buildFieldLabel("Full Name *"),
                      _buildTextField(
                        _nameController,
                        "Enter Full Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Full Name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Gender & DOB Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Gender"),
                                _buildDropdown(['Male', 'Female', 'Other'], _selectedGender, (val) => setState(() => _selectedGender = val!)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Date of Birth"),
                                _buildDatePickerField(_dobController, () => _selectDate(context, _dobController)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Mobile Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Primary Contact Mobile *"),
                                _buildTextField(
                                  _mobile1Controller,
                                  "Enter Mobile Number",
                                  keyboard: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter mobile number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Secondary Contact Mobile"),
                                _buildTextField(_mobile2Controller, "Enter Mobile Number", keyboard: TextInputType.phone),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Email Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Primary Email"),
                                _buildTextField(_email1Controller, "Enter Email ID", keyboard: TextInputType.emailAddress),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Secondary Email"),
                                _buildTextField(_email2Controller, "Enter Email ID", keyboard: TextInputType.emailAddress),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Address (Full Width Text Area)
                      _buildFieldLabel("Address"),
                      _buildTextField(_addressController, "Enter Address", maxLines: 3),

                      const SizedBox(height: 16),

                      // Employee Type & Role
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Employee Type"),
                                _buildDropdown(['Full Time Employee', 'Part Time Employee', 'Contract'], _selectedType, (val) => setState(() => _selectedType = val!)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Employee Role"),
                                _buildDropdown(
                                  ['Employee', 'Admin', 'Accountant', 'Teacher', 'Science', 'Languages', 'Technology', 'Sports', 'Creative Arts', 'Humanities'], 
                                  _selectedRole, 
                                  (val) => setState(() => _selectedRole = val!)
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Designation (Full Width)
                      _buildFieldLabel("Designation"),
                      _buildTextField(_designationController, "Enter Designation"),

                      const SizedBox(height: 16),

                      // Aadhaar Number (Full Width)
                      _buildFieldLabel("Aadhaar Number"),
                      _buildTextField(_aadhaarController, "Enter Aadhaar Number"),

                      const SizedBox(height: 16),

                      // DOJ & DOR
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Date of Join"),
                                _buildDatePickerField(_dojController, () => _selectDate(context, _dojController)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Date of Relieve"),
                                _buildDatePickerField(_dorController, () => _selectDate(context, _dorController)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Salary & Is Active Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldLabel("Salary"),
                                _buildTextField(_salaryController, "Enter Salary", keyboard: TextInputType.number),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isActive,
                                  activeColor: AppColors.primary,
                                  onChanged: (val) => setState(() => _isActive = val!),
                                ),
                                const Text("Is Active", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Other Details
                      _buildFieldLabel("Other Details"),
                      _buildTextField(_otherDetailsController, "Enter Remarks", maxLines: 4),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Component Builders ──────────────────────────────────────────────────

  Widget _topActionBtn(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF757897)),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: validator,
        style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          errorStyle: const TextStyle(height: 0.8, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          style: const TextStyle(fontSize: 13, color: Color(0xFF1E2875), fontWeight: FontWeight.w500),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Text(
                  controller.text.isEmpty ? "dd/mm/yyyy" : controller.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: controller.text.isEmpty ? Colors.grey.shade400 : const Color(0xFF1E2875),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.calendar_month, size: 20, color: Color(0xFFEF4444)),
            ),
          ],
        ),
      ),
    );
  }
}
