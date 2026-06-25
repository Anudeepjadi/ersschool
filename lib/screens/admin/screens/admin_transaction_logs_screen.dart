import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

class AdminTransactionLogsScreen extends StatefulWidget {
  AdminTransactionLogsScreen({super.key});

  @override
  State<AdminTransactionLogsScreen> createState() => _AdminTransactionLogsScreenState();
}

class _AdminTransactionLogsScreenState extends State<AdminTransactionLogsScreen> {
  final List<Map<String, dynamic>> _allLogs = [
    {
      'txId': 'TXN-9023412',
      'name': 'Aarav Sharma',
      'school': 'Ecstasy School 1',
      'amount': '₹ 15,000',
      'date': '22 May 2026',
      'time': '10:15 AM',
      'method': 'UPI (GPay)',
      'status': 'Success',
      'operator': 'Operator 1',
    },
    {
      'txId': 'TXN-8812903',
      'name': 'Kabir Malhotra',
      'school': 'Ecstasy School 2',
      'amount': '₹ 25,000',
      'date': '21 May 2026',
      'time': '02:40 PM',
      'method': 'Cash',
      'status': 'Success',
      'operator': 'Operator 2',
    },
    {
      'txId': 'TXN-7738210',
      'name': 'Vivaan Kapoor',
      'school': 'Ecstasy School 3',
      'amount': '₹ 12,000',
      'date': '21 May 2026',
      'time': '11:05 AM',
      'method': 'Card',
      'status': 'Success',
      'operator': 'Operator 3',
    },
    {
      'txId': 'TXN-5542911',
      'name': 'Priya Patel',
      'school': 'Ecstasy School 1',
      'amount': '₹ 8,500',
      'date': '20 May 2026',
      'time': '04:55 PM',
      'method': 'UPI (PhonePe)',
      'status': 'Failed',
      'operator': 'Operator 1',
    },
    {
      'txId': 'TXN-4428930',
      'name': 'Dia Sen',
      'school': 'Ecstasy School 2',
      'amount': '₹ 18,000',
      'date': '19 May 2026',
      'time': '09:30 AM',
      'method': 'Net Banking',
      'status': 'Success',
      'operator': 'Operator 2',
    },
  ];

  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredLogs = _allLogs.where((log) {
      final query = _searchQuery.toLowerCase();
      return log['name'].toLowerCase().contains(query) ||
          log['txId'].toLowerCase().contains(query) ||
          log['school'].toLowerCase().contains(query) ||
          log['method'].toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Transaction Logs",
        subtitle: "Audit log of UPI, cash, card, and net banking fee receipts",
        showSchoolSelector: false,
      ),
      body: Column(
        children: [
          // Search & Filters Header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search by Student Name, Txn ID, Method...",
                prefixIcon: Icon(Icons.search, color: Color(0xFF757897)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Log entries count label
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Transactions (${filteredLogs.length})",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                ),
                Icon(Icons.filter_list, color: AppColors.primary),
              ],
            ),
          ),
          SizedBox(height: 8),

          // Scrollable log lists
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: filteredLogs.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final log = filteredLogs[index];
                final isSuccess = log['status'] == 'Success';

                return Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade50,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['txId'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${log['date']} | ${log['time']}",
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              log['status'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSuccess ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Divider(height: 1),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log['name'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E2875)),
                              ),
                              Text(
                                log['school'],
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                log['amount'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                              ),
                              Text(
                                "${log['method']} | ${log['operator']}",
                                style: TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

