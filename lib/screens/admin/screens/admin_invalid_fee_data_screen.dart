import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

class AdminInvalidFeeDataScreen extends StatefulWidget {
  const AdminInvalidFeeDataScreen({super.key});

  @override
  State<AdminInvalidFeeDataScreen> createState() => _AdminInvalidFeeDataScreenState();
}

class _AdminInvalidFeeDataScreenState extends State<AdminInvalidFeeDataScreen> {
  final List<Map<String, dynamic>> _invalidRecords = [
    {
      'id': 'INV-001',
      'name': 'Aarav Sharma',
      'school': 'Ecstasy School 1',
      'class': 'Class 10',
      'issue': 'Tuition Fee Exceeds Limit',
      'details': 'Assigned Tuition Fee (₹ 55,000) exceeds Class 10 cap (₹ 45,000)',
      'status': 'Unresolved',
    },
    {
      'id': 'INV-002',
      'name': 'Dia Sen',
      'school': 'Ecstasy School 2',
      'class': 'Class 10',
      'issue': 'Double Scholarship Applied',
      'details': 'Both Merit (20%) and Need-based (15%) scholarships applied concurrently',
      'status': 'Unresolved',
    },
    {
      'id': 'INV-003',
      'name': 'Tara Dsouza',
      'school': 'Ecstasy School 3',
      'class': 'Class 8',
      'issue': 'Negative Transport Fee',
      'details': 'Transport charge set to -₹ 1,500 due to data entry offset error',
      'status': 'Unresolved',
    },
    {
      'id': 'INV-004',
      'name': 'Vikram Reddy',
      'school': 'Ecstasy School 1',
      'class': 'Class 10',
      'issue': 'Unapproved Waiver',
      'details': '100% tuition waiver applied without Principal digital signature token',
      'status': 'Unresolved',
    },
  ];

  void _resolveRecord(int index) {
    setState(() {
      _invalidRecords[index]['status'] = 'Resolved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Discrepancy ${_invalidRecords[index]['id']} resolved successfully!'),
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
        title: "Invalid Fee Data",
        subtitle: "Audit and resolve student fee configuration anomalies",
        showSchoolSelector: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Alert Panel
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Fee Configurations Requiring Attention",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF991B1B)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "The following records have inconsistencies that prevent accurate invoice generation and billing cycles. Please audit and resolve them.",
                          style: TextStyle(fontSize: 11, color: Color(0xFF7F1D1D)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _invalidRecords.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _invalidRecords[index];
                final isResolved = item['status'] == 'Resolved';

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isResolved ? Colors.green.shade100 : Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade50,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isResolved ? Colors.green.shade50 : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['id'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isResolved ? Colors.green : Colors.orange.shade800,
                              ),
                            ),
                          ),
                          Text(
                            item['school'],
                            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item['issue'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Student: ${item['name']} (${item['class']})",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF757897)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['details'],
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isResolved ? Icons.check_circle : Icons.hourglass_empty,
                                size: 16,
                                color: isResolved ? Colors.green : Colors.orange,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isResolved ? Colors.green : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          if (!isResolved)
                            ElevatedButton(
                              onPressed: () => _resolveRecord(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                elevation: 0,
                              ),
                              child: const Text("Fix & Reconcile", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            )
                          else
                            const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
