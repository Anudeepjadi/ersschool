import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FeeTab extends StatelessWidget {
  const FeeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fees", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.text,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2E9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pending Fee", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("₹12,500", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  ],
                ),
                Icon(Icons.payment, size: 40, color: Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("Payment History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 12),
          _buildTransaction("Term 1 Tuition Fees", "Paid on 10 Apr 2026", "₹25,000", Colors.green),
          _buildTransaction("Bus Transport Charges", "Paid on 12 Apr 2026", "₹4,500", Colors.green),
          _buildTransaction("Library Annual Deposit", "Paid on 15 Apr 2026", "₹1,200", Colors.green),
        ],
      ),
    );
  }

  Widget _buildTransaction(String title, String date, String amount, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(Icons.check_circle_outline, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        subtitle: Text(date),
        trailing: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E2875))),
      ),
    );
  }
}
