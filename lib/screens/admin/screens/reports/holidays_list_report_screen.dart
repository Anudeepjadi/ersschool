import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';

class HolidaysListReportScreen extends StatefulWidget {
  const HolidaysListReportScreen({super.key});

  @override
  State<HolidaysListReportScreen> createState() => _HolidaysListReportScreenState();
}

class _HolidaysListReportScreenState extends State<HolidaysListReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> holidays = [
      {'date': '2/10/2026', 'day': 'Friday', 'description': 'Gandhi Jayanthi'},
      {'date': '25/12/2025', 'day': 'Friday', 'description': 'Christmas Day'},
      {'date': '20/3/2026', 'day': 'Wednesday', 'description': 'krishna birthday'},
      {'date': '27/3/2026', 'day': 'Wednesday', 'description': 'bakrid'},
      {'date': '30/3/2026', 'day': 'Saturday', 'description': 'Second saturday'},
      {'date': '25/6/2026', 'day': 'Thursday', 'description': 'muhharam'},
      {'date': '15/8/2026', 'day': 'Saturday', 'description': 'Independence Day'},
      {'date': '26/1/2027', 'day': 'Tuesday', 'description': 'Republic Day'},
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Reports",
        subtitle: "Holidays List",
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Holidays List",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildHolidaysTable(holidays),
          ],
        ),
      ),
    );
  }

  Widget _buildHolidaysTable(List<Map<String, String>> data) {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFF001A40)),
          children: [
            _buildHeaderCell("Date"),
            _buildHeaderCell("Day"),
            _buildHeaderCell("Description"),
          ],
        ),
        ...data.asMap().entries.map((entry) {
          final isEven = entry.key % 2 == 0;
          final item = entry.value;
          return TableRow(
            decoration: BoxDecoration(
              color: isEven ? Colors.grey.shade50 : Colors.white,
            ),
            children: [
              _buildDataCell(item['date']!),
              _buildDataCell(item['day']!),
              _buildDataCell(item['description']!),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}
