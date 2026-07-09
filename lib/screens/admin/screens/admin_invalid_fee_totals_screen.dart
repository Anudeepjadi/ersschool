import 'package:flutter/material.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminInvalidFeeTotalsScreen extends StatefulWidget {
  const AdminInvalidFeeTotalsScreen({super.key});

  @override
  State<AdminInvalidFeeTotalsScreen> createState() => _AdminInvalidFeeTotalsScreenState();
}

class _AdminInvalidFeeTotalsScreenState extends State<AdminInvalidFeeTotalsScreen> {
  final List<Map<String, dynamic>> _discrepancies = [
    {
      'school': 'Ecstasy School 1',
      'reported': 245000.0,
      'calculated': 244800.0,
      'diff': -200.0,
      'reason': 'UPI transaction ECS-T901 timed out but was logged as collected',
      'status': 'Reconcilable',
    },
    {
      'school': 'Ecstasy School 2',
      'reported': 185000.0,
      'calculated': 186500.0,
      'diff': 1500.0,
      'reason': 'Manual cash receipt ECS-T304 was logged twice in offline ledger entry',
      'status': 'Reconcilable',
    },
    {
      'school': 'Ecstasy School 3',
      'reported': 310000.0,
      'calculated': 310000.0,
      'diff': 0.0,
      'reason': 'No mismatch detected',
      'status': 'Balanced',
    },
  ];

  void _reconcileSchool(int index) {
    setState(() {
      _discrepancies[index]['reported'] = _discrepancies[index]['calculated'];
      _discrepancies[index]['diff'] = 0.0;
      _discrepancies[index]['status'] = 'Balanced';
      _discrepancies[index]['reason'] = 'Audit adjustments verified and balanced';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ledger for ${_discrepancies[index]['school']} reconciled and balanced!'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Invalid Fee Totals",
        subtitle: "Audit ledger sums against reported branch collection totals",
        showSchoolSelector: false,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informational Overview
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Reconciliation Engine".tr,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A8A)),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "This engine checks transaction level data against reported aggregates. Correct any offline/online syncing offsets using 'Resolve Adjustment'.",
                          style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _discrepancies.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _discrepancies[index];
                final isBalanced = item['diff'] == 0.0;

                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isBalanced ? Colors.green.shade100 : Colors.red.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade50,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['school'],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isBalanced ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isBalanced ? "Balanced" : "Mismatch",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isBalanced ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Reported Total".tr, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("₹ ${item['reported'].toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Calculated Total".tr, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text("₹ ${item['calculated'].toStringAsFixed(0)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875))),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Discrepancy".tr, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                SizedBox(height: 4),
                                Text(
                                  "${item['diff'] > 0 ? '+' : ''}₹ ${item['diff'].toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isBalanced ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Divider(height: 1),
                      SizedBox(height: 12),
                      Text("Audit Explanation:".tr,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 2),
                      Text(
                        item['reason'],
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
                      ),
                      if (!isBalanced) ...[
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _reconcileSchool(index),
                            icon: Icon(Icons.compare_arrows_rounded, size: 14),
                            label: Text("Resolve Adjustment".tr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              elevation: 0,
                            ),
                          ),
                        )
                      ],
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
