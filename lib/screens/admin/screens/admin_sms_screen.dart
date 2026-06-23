import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/data/app_data_store.dart';

class AdminSmsScreen extends StatefulWidget {
  const AdminSmsScreen({super.key});

  @override
  State<AdminSmsScreen> createState() => _AdminSmsScreenState();
}

class _AdminSmsScreenState extends State<AdminSmsScreen> {
  String selectedSchool = 'Ecstasy School 1';
  Map<String, bool> selectedClasses = {};
  
  bool term1Selected = false;
  bool term2Selected = false;
  bool term3Selected = false;
  
  // Track selected students individually (admission -> selected)
  Map<String, bool> selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    _initSelectedClasses();
  }

  void _initSelectedClasses() {
    selectedClasses.clear();
    for (var c in AppDataStore.instance.studyClasses) {
      selectedClasses[c['name'].toString()] = false;
    }
  }

  void _updateSelectAll(bool? checked) {
    setState(() {
      for (var key in selectedClasses.keys) {
        selectedClasses[key] = checked ?? false;
      }
    });
  }

  bool get _isAllSelected {
    if (selectedClasses.isEmpty) return false;
    return selectedClasses.values.every((v) => v);
  }

  List<Map<String, String>> _getTargetStudents() {
    final List<Map<String, String>> result = [];
    final activeGrades = selectedClasses.entries.where((e) => e.value).map((e) => e.key).toList();
    if (activeGrades.isEmpty) return result;

    final realStudents = AppDataStore.instance.students.where((s) => s['school'] == selectedSchool).toList();
    
    for (var s in realStudents) {
      String sClass = s['class'] ?? '';
      bool matches = false;
      for (var g in activeGrades) {
        String standardG = g.replaceAll('.', '').replaceAll(' ', '').toLowerCase();
        String standardSClass = sClass.replaceAll('.', '').replaceAll(' ', '').toLowerCase();
        if (standardSClass == standardG) {
          matches = true;
          break;
        }
      }
      if (matches) {
        result.add({
          'name': s['name'] ?? '',
          'class': s['class'] ?? '',
          'phone': s['phone'] ?? '',
          'admission': s['admission'] ?? '',
        });
      }
    }

    final mockNames = {
      'Nursery': ['Kabir Roy', 'Sanya Gupta'],
      'L.K.G': ['Little Timmy', 'Aria Sen'],
      'U.K.G': ['Rayan Khan', 'Zoya Patel'],
      'Class 1': ['Aarav Kumar', 'Vihaan Shah'],
      'Class 2': ['Aditya Rao', 'Anjali Gupta'],
      'Class 3': ['Sai Kiran', 'Divya Teja'],
      'Class 4': ['Sanjay Verma', 'Meera Krishnan'],
      'Class 5': ['Rakesh Roshan', 'Sneha Latha'],
      'Class 6': ['Deepak Hooda', 'Meera Das'],
      'Class 7': ['Rahul Verma', 'Kavya Menon'],
      'Class 8': ['Arjun Nair', 'Tara Dsouza'],
      'Class 9': ['Rohan Gupta', 'Sneha Joshi'],
      'Class 10': ['Aarav Sharma', 'Priya Patel'],
    };

    for (var grade in activeGrades) {
      final names = mockNames[grade] ?? ['Student A', 'Student B'];
      for (var name in names) {
        if (!result.any((s) => s['name'] == name)) {
          result.add({
            'name': name,
            'class': grade,
            'phone': '9876543210',
            'admission': 'ECS-${grade.replaceAll(' ', '')}-${name.split(' ').first}',
          });
        }
      }
    }

    return result;
  }

  void _showSelectStudentsDialog() {
    final students = _getTargetStudents();
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one class first."),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Reset student selections that are not in the current target list
    final targetIds = students.map((s) => s['admission']!).toSet();
    selectedStudentIds.removeWhere((id, _) => !targetIds.contains(id));
    
    // Default any new target students to true (selected) if not already tracked
    for (var s in students) {
      selectedStudentIds.putIfAbsent(s['admission']!, () => true);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Students",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                  ),
                  Text(
                    "Selected: ${selectedStudentIds.values.where((v) => v).length}/${students.length}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              for (var s in students) {
                                selectedStudentIds[s['admission']!] = true;
                              }
                            });
                          },
                          child: const Text("Select All"),
                        ),
                        TextButton(
                          onPressed: () {
                            setDialogState(() {
                              for (var s in students) {
                                selectedStudentIds[s['admission']!] = false;
                              }
                            });
                          },
                          child: const Text("Clear All"),
                        ),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final id = student['admission']!;
                          final isSelected = selectedStudentIds[id] ?? true;

                          return CheckboxListTile(
                            title: Text(student['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text("Class: ${student['class']} | Adm: $id"),
                            value: isSelected,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              setDialogState(() {
                                selectedStudentIds[id] = val ?? false;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // refresh main screen cached stats
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Apply Selection"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _sendSmsNotification() {
    final activeGrades = selectedClasses.entries.where((e) => e.value).map((e) => e.key).toList();
    if (activeGrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one class.")),
      );
      return;
    }

    if (!term1Selected && !term2Selected && !term3Selected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one pending term.")),
      );
      return;
    }

    final targetStudents = _getTargetStudents();
    final selectedStudents = targetStudents.where((s) => selectedStudentIds[s['admission']] ?? true).toList();

    if (selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No students are currently selected to receive SMS.")),
      );
      return;
    }

    final List<String> selectedTerms = [];
    if (term1Selected) selectedTerms.add("Term 1");
    if (term2Selected) selectedTerms.add("Term 2");
    if (term3Selected) selectedTerms.add("Term 3");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Send SMS", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("You are about to send fee due SMS alerts to:"),
            const SizedBox(height: 8),
            Text("• School: $selectedSchool"),
            Text("• Classes: ${activeGrades.join(', ')}"),
            Text("• Terms: ${selectedTerms.join(', ')}"),
            Text("• Total Recipients: ${selectedStudents.length} students"),
            const SizedBox(height: 12),
            const Text(
              "This action will dispatch automated SMS alerts to the parents of all selected students.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSendingProgress(selectedStudents.length);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5A35),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Send SMS"),
          ),
        ],
      ),
    );
  }

  void _showSendingProgress(int count) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                child: Text("Sending SMS notifications...", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text("Success", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text("$count SMS notifications have been sent successfully to parents!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
        title: "SMS panel",
        subtitle: "Send fee notifications",
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Send Fee Due title with reduced font size (18)
              const Text(
                "Send Fee Due SMS to Selected Students",
                style: TextStyle(
                  color: Color(0xFFC2410C), // deep rust/brown/orange
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Branch selector
              const Text(
                "Branch",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSchool,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 18),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1E2875),
                      fontWeight: FontWeight.bold,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Ecstasy School 1', child: Text("Ecstasy School 1 (ECS001)")),
                      DropdownMenuItem(value: 'Ecstasy School 2', child: Text("Ecstasy School 2 (ECS002)")),
                      DropdownMenuItem(value: 'Ecstasy School 3', child: Text("Ecstasy School 3 (ECS003)")),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() {
                          selectedSchool = v;
                          selectedStudentIds.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. Select Classes option
              _buildClassesSelectionList(),
              const SizedBox(height: 24),

              // 4. Fee pending controls
              _buildRightControlsPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassesSelectionList() {
    final classes = AppDataStore.instance.studyClasses;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _isAllSelected,
                activeColor: AppColors.primary,
                tristate: true,
                onChanged: _updateSelectAll,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Select All",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E2875),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: classes.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (context, index) {
                final cls = classes[index]['name'].toString();
                final isSelected = selectedClasses[cls] ?? false;

                return CheckboxListTile(
                  value: isSelected,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: AppColors.primary,
                  title: Text(
                    cls,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1E2875),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      selectedClasses[cls] = val ?? false;
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRightControlsPanel() {
    final activeGrades = selectedClasses.entries.where((e) => e.value).map((e) => e.key).toList();
    final targetStudents = _getTargetStudents();
    final selectedStudentsCount = targetStudents.where((s) => selectedStudentIds[s['admission']] ?? true).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Select Students" Button (Brown color)
        ElevatedButton(
          onPressed: activeGrades.isEmpty ? null : _showSelectStudentsDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC2410C), // brown / orange accent
            disabledBackgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
          ),
          child: Text(
            activeGrades.isEmpty 
                ? "Select Students" 
                : "Select Students (${selectedStudentsCount}/${targetStudents.length})",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        const SizedBox(height: 20),

        // Title: Fee pending from
        const Text(
          "Fee pending from",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E2875),
          ),
        ),
        const SizedBox(height: 12),

        // Checklist of Terms card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              CheckboxListTile(
                value: term1Selected,
                title: const Text("Term 1", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E2875), fontSize: 14)),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (v) => setState(() => term1Selected = v ?? false),
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              CheckboxListTile(
                value: term2Selected,
                title: const Text("Term 2", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E2875), fontSize: 14)),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (v) => setState(() => term2Selected = v ?? false),
              ),
              Divider(height: 1, color: Colors.grey.shade100),
              CheckboxListTile(
                value: term3Selected,
                title: const Text("Term 3", style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E2875), fontSize: 14)),
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (v) => setState(() => term3Selected = v ?? false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // "Send to All Students" Green button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: activeGrades.isEmpty ? null : _sendSmsNotification,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E), // teal / green
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 2,
            ),
            child: const Text(
              "Send to All Students",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
