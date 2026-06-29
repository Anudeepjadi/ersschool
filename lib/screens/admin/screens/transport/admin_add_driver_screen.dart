import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/admin_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';

class AdminAddDriverScreen extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const AdminAddDriverScreen({super.key, this.existingData});

  @override
  State<AdminAddDriverScreen> createState() => _AdminAddDriverScreenState();
}

class _AdminAddDriverScreenState extends State<AdminAddDriverScreen> {
  late TextEditingController codeCtrl;
  late TextEditingController nameCtrl;
  late TextEditingController mobileCtrl;
  late TextEditingController emailCtrl;
  
  late String role;

  @override
  void initState() {
    super.initState();
    codeCtrl = TextEditingController(text: widget.existingData?['code'] ?? '');
    nameCtrl = TextEditingController(text: widget.existingData?['name'] ?? '');
    mobileCtrl = TextEditingController(text: widget.existingData?['mobile'] ?? '');
    emailCtrl = TextEditingController(text: widget.existingData?['email'] ?? '');
    
    role = widget.existingData?['role'] ?? 'Driver';
  }

  @override
  void dispose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
    mobileCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AdminAppBar(
        title: widget.existingData == null ? "Add Driver Details" : "Edit Driver Details",
        subtitle: "Manage driver information",
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isMobile ? Column(
                children: [
                  _buildDropdown("Employee Role", role, ["Driver", "Attender"], (v) => setState(() => role = v!)),
                  const SizedBox(height: 16),
                  _buildTextField("Employee Code", codeCtrl),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildDropdown("Employee Role", role, ["Driver", "Attender"], (v) => setState(() => role = v!))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("Employee Code", codeCtrl)),
                ],
              ),
              const SizedBox(height: 16),
              isMobile ? Column(
                children: [
                  _buildTextField("Full Name", nameCtrl),
                  const SizedBox(height: 16),
                  _buildTextField("Mobile", mobileCtrl),
                  const SizedBox(height: 16),
                  _buildTextField("EmailId", emailCtrl),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildTextField("Full Name", nameCtrl)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("Mobile", mobileCtrl)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("EmailId", emailCtrl)),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2875),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text("Cancel".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final newData = Map<String, dynamic>.from({
                        "role": role,
                        "code": codeCtrl.text,
                        "name": nameCtrl.text.isEmpty ? "New Employee" : nameCtrl.text,
                        "mobile": mobileCtrl.text,
                        "email": emailCtrl.text,
                      });
                      Navigator.pop(context, newData);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text("Save".tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item.tr, style: const TextStyle(fontSize: 14)));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
