import 'package:flutter/material.dart';
import '../../../../core/data/app_data_store.dart';
import '../dashboard/widgets/student_app_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class StudentHolidaysScreen extends StatelessWidget {
  final Function(int)? onTabSelected;

  const StudentHolidaysScreen({super.key, this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final holidays = AppDataStore.instance.holidays;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: StudentAppBar(
        title: "School Holidays".tr,
        subtitle: "List of upcoming holidays",
        onOpenDrawer: () => Scaffold.of(context).openDrawer(),
        onProfileTap: onTabSelected != null ? () => onTabSelected!(1) : null,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.beach_access_rounded, size: 48, color: Colors.orange),
                SizedBox(height: 12),
                Text(
                  "Academic Calendar Holidays".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Check out the list of holidays for the current session".tr,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: holidays.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy_outlined,
                            size: 64, color: Colors.grey.shade300),
                        SizedBox(height: 16),
                        Text("No holidays listed yet.".tr,
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: holidays.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final h = holidays[index];
                      return _buildHolidayCard(h);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayCard(Map<String, dynamic> holiday) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  holiday['date'].split('/')[0],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
                Text(
                  _getMonth(holiday['date'].split('/')[1]),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday['description'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2875),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      holiday['date'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  String _getMonth(String monthNum) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    int idx = int.tryParse(monthNum) ?? 1;
    if (idx < 1 || idx > 12) idx = 1;
    return months[idx - 1];
  }
}
