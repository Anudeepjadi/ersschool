import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../widgets/admin_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';

class AdminAddVehicleScreen extends StatefulWidget {
  final Map<String, dynamic>? existingData;

  const AdminAddVehicleScreen({super.key, this.existingData});

  @override
  State<AdminAddVehicleScreen> createState() => _AdminAddVehicleScreenState();
}

class _AdminAddVehicleScreenState extends State<AdminAddVehicleScreen> {
  late TextEditingController modelCtrl;
  late TextEditingController regNoCtrl;
  late TextEditingController seatCtrl;
  late TextEditingController routeNoCtrl;
  late TextEditingController routeNameCtrl;
  late TextEditingController areaCtrl;
  late TextEditingController contactCtrl;
  late TextEditingController startTimeCtrl;

  late String driver;
  late String attender;
  late bool isActive;

  @override
  void initState() {
    super.initState();
    modelCtrl = TextEditingController(text: widget.existingData != null ? widget.existingData!['model'].split('\n')[0] : '');
    regNoCtrl = TextEditingController(text: widget.existingData != null && widget.existingData!['model'].split('\n').length > 1 ? widget.existingData!['model'].split('\n')[1] : '');
    seatCtrl = TextEditingController(text: widget.existingData?['seat'] ?? '');
    routeNoCtrl = TextEditingController(text: widget.existingData?['routeNo'] ?? '');
    routeNameCtrl = TextEditingController(text: widget.existingData?['routeName'] ?? '');
    areaCtrl = TextEditingController(text: widget.existingData?['area'] ?? '');
    contactCtrl = TextEditingController(text: widget.existingData?['contact'] ?? '');
    startTimeCtrl = TextEditingController(text: widget.existingData?['startTime'] ?? '');

    driver = widget.existingData?['driver'] ?? 'Kumar';
    attender = widget.existingData?['attender'] ?? 'Sunitha';
    isActive = widget.existingData?['isActive'] ?? true;
  }

  @override
  void dispose() {
    modelCtrl.dispose();
    regNoCtrl.dispose();
    seatCtrl.dispose();
    routeNoCtrl.dispose();
    routeNameCtrl.dispose();
    areaCtrl.dispose();
    contactCtrl.dispose();
    startTimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AdminAppBar(
        title: widget.existingData == null ? "Add Vehicle Details" : "Edit Vehicle Details",
        subtitle: "Manage vehicle information",
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
                  _buildTextField("Vehicle Model", modelCtrl),
                  const SizedBox(height: 16),
                  _buildTextField("Vehicle RegNo", regNoCtrl),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildTextField("Vehicle Model", modelCtrl)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("Vehicle RegNo", regNoCtrl)),
                ],
              ),
              const SizedBox(height: 16),
              isMobile ? Column(
                children: [
                  _buildTextField("Seat Capacity", seatCtrl),
                  const SizedBox(height: 16),
                  _buildTextField("Route No", routeNoCtrl),
                  const SizedBox(height: 16),
                  _buildTextField("Start Time (hh:mm am/pm)", startTimeCtrl),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildTextField("Seat Capacity", seatCtrl)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("Route No", routeNoCtrl)),
                  const SizedBox(width: 24),
                  Expanded(child: _buildTextField("Start Time (hh:mm am/pm)", startTimeCtrl)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField("Route Name", routeNameCtrl),
              const SizedBox(height: 16),
              _buildTextField("Area Covered", areaCtrl),
              const SizedBox(height: 16),
              isMobile ? Column(
                children: [
                  _buildDropdown("Driver", driver, ["Kumar", "Srinu"], (v) => setState(() => driver = v!)),
                  const SizedBox(height: 16),
                  _buildDropdown("Attender", attender, ["Sunitha", "Aaya Rani"], (v) => setState(() => attender = v!)),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildDropdown("Driver", driver, ["Kumar", "Srinu"], (v) => setState(() => driver = v!))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildDropdown("Attender", attender, ["Sunitha", "Aaya Rani"], (v) => setState(() => attender = v!))),
                ],
              ),
              const SizedBox(height: 16),
              isMobile ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Contact Mobile Number", contactCtrl),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isActive,
                        onChanged: (v) => setState(() => isActive = v!),
                        activeColor: Colors.blue,
                      ),
                      Text("Is Active".tr, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ) : Row(
                children: [
                  Expanded(child: _buildTextField("Contact Mobile Number", contactCtrl)),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: isActive,
                          onChanged: (v) => setState(() => isActive = v!),
                          activeColor: Colors.blue,
                        ),
                        Text("Is Active".tr, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
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
                        "model": modelCtrl.text.isEmpty ? "New Vehicle" : "${modelCtrl.text}\n${regNoCtrl.text}",
                        "seat": seatCtrl.text.isEmpty ? "0" : seatCtrl.text,
                        "routeNo": routeNoCtrl.text.isEmpty ? "0" : routeNoCtrl.text,
                        "routeName": routeNameCtrl.text.isEmpty ? "Unknown" : routeNameCtrl.text,
                        "area": areaCtrl.text.isEmpty ? "Unknown" : areaCtrl.text,
                        "contact": contactCtrl.text.isEmpty ? "000000" : contactCtrl.text,
                        "driver": driver,
                        "attender": attender,
                        "startTime": startTimeCtrl.text.isEmpty ? "8:00 AM" : startTimeCtrl.text,
                        "isActive": isActive,
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
