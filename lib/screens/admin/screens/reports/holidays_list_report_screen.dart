import 'package:ersschool/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/admin_app_bar.dart';
import '../../widgets/admin_drawer.dart';
import '../../widgets/admin_bottom_nav_bar.dart';
import '../../../../core/data/app_data_store.dart';
import 'package:intl/intl.dart';

class HolidaysListReportScreen extends StatefulWidget {
  const HolidaysListReportScreen({super.key});

  @override
  State<HolidaysListReportScreen> createState() => _HolidaysListReportScreenState();
}

class _HolidaysListReportScreenState extends State<HolidaysListReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AppDataStore _store = AppDataStore.instance;

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    super.dispose();
  }

  String _getDayName(String dateStr) {
    try {
      // Assuming date format is dd/MM/yyyy or d/M/yyyy
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        return DateFormat('EEEE').format(date);
      }
    } catch (_) {}
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final holidays = _store.holidays.map((h) {
      return {
        'date': h['date']?.toString() ?? '',
        'day': _getDayName(h['date']?.toString() ?? ''),
        'description': h['description']?.toString() ?? '',
      };
    }).toList();

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
          decoration: const BoxDecoration(color: AppColors.primary),
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
