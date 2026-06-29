import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

class AdminFeeNotGenStudentsScreen extends StatefulWidget {
  const AdminFeeNotGenStudentsScreen({super.key});

  @override
  State<AdminFeeNotGenStudentsScreen> createState() => _AdminFeeNotGenStudentsScreenState();
}

class _AdminFeeNotGenStudentsScreenState extends State<AdminFeeNotGenStudentsScreen> {
  final List<Map<String, dynamic>> _studentsList = [
    {
      'admission': 'ECS00006',
      'name': 'Sneha Joshi',
      'school': 'Ecstasy School 1',
      'class': 'Class 9',
      'selected': false,
    },
    {
      'admission': 'ECS00204',
      'name': 'Myra Mehta',
      'school': 'Ecstasy School 2',
      'class': 'Class 8',
      'selected': false,
    },
    {
      'admission': 'ECS00304',
      'name': 'Tara Dsouza',
      'school': 'Ecstasy School 3',
      'class': 'Class 8',
      'selected': false,
    },
    {
      'admission': 'ECS00010',
      'name': 'Meera Das',
      'school': 'Ecstasy School 1',
      'class': 'Class 6',
      'selected': false,
    },
    {
      'admission': 'ECS00206',
      'name': 'Tanvi Bhatia',
      'school': 'Ecstasy School 2',
      'class': 'Class 9',
      'selected': false,
    },
  ];

  bool _isAllSelected = false;

  void _toggleSelectAll() {
    setState(() {
      _isAllSelected = !_isAllSelected;
      for (var student in _studentsList) {
        student['selected'] = _isAllSelected;
      }
    });
  }

  void _generateInvoices() {
    final selectedCount = _studentsList.where((s) => s['selected']).length;
    if (selectedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one student to generate invoices.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _studentsList.removeWhere((s) => s['selected']);
      _isAllSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoices generated successfully for $selectedCount students!'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(
        title: "Fee Invoices Pending",
        subtitle: "Audit students missing invoices for the active billing cycle",
        showSchoolSelector: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Batch generation action card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade50,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Term 1 Invoice Batch",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "${_studentsList.length} students have no active invoices.",
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _generateInvoices,
                    icon: const Icon(Icons.rocket_launch_outlined, size: 14),
                    label: const Text("Generate Selected", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Select all row
            Row(
              children: [
                Checkbox(
                  value: _isAllSelected,
                  onChanged: (v) => _toggleSelectAll(),
                  activeColor: AppColors.primary,
                ),
                const Text(
                  "Select All Students",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E2875)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Students table list
            Expanded(
              child: _studentsList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle_outline_rounded, size: 48, color: Colors.green),
                          SizedBox(height: 12),
                          Text(
                            "All students have generated invoices!",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: _studentsList.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final student = _studentsList[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: student['selected'],
                              activeColor: AppColors.primary,
                              onChanged: (val) {
                                setState(() {
                                  student['selected'] = val!;
                                  _isAllSelected = _studentsList.every((s) => s['selected']);
                                });
                              },
                            ),
                            title: Text(
                              student['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                            ),
                            subtitle: Text(
                              "${student['class']} | ${student['school']}",
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                            trailing: Text(
                              student['admission'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF757897)),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

