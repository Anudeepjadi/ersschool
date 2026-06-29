import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminHostelScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  const AdminHostelScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminHostelScreen> createState() => _AdminHostelScreenState();
}

class _AdminHostelScreenState extends State<AdminHostelScreen> {
  final List<Map<String, dynamic>> _blocks = [
    {'name': 'Boys Hostel', 'block': 'Block A', 'rooms': 60, 'occupied': 52, 'vacant': 8, 'pct': 86},
    {'name': 'Girls Hostel', 'block': 'Block B', 'rooms': 40, 'occupied': 34, 'vacant': 6, 'pct': 85},
    {'name': 'Boys Hostel', 'block': 'Block C', 'rooms': 10, 'occupied': 8, 'vacant': 2, 'pct': 80},
    {'name': 'Girls Hostel', 'block': 'Block D', 'rooms': 10, 'occupied': 8, 'vacant': 2, 'pct': 80},
  ];

  final List<Map<String, dynamic>> _residents = [
    {'student': 'Rahul Kumar', 'roll': '101', 'hostel': 'Boys Hostel', 'room': 'Block A - 101', 'bed': 'B1', 'date': '20 Jun 2026', 'status': 'Active'},
    {'student': 'Ananya Sharma', 'roll': '102', 'hostel': 'Girls Hostel', 'room': 'Block B - 205', 'bed': 'B2', 'date': '20 Jun 2026', 'status': 'Active'},
    {'student': 'Aarav Singh', 'roll': '103', 'hostel': 'Boys Hostel', 'room': 'Block A - 112', 'bed': 'B1', 'date': '19 Jun 2026', 'status': 'Active'},
    {'student': 'Diya Patel', 'roll': '104', 'hostel': 'Girls Hostel', 'room': 'Block B - 210', 'bed': 'B3', 'date': '19 Jun 2026', 'status': 'Active'},
    {'student': 'Kabir Verma', 'roll': '105', 'hostel': 'Boys Hostel', 'room': 'Block C - 301', 'bed': 'B2', 'date': '18 Jun 2026', 'status': 'Active'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Hostel Management",
        subtitle: "Manage hostel, rooms and residents",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard("Total Hostels", "4", "No change", Colors.blue),
                  _buildStatCard("Total Rooms", "120", "+4 this year", Colors.teal),
                  _buildStatCard("Total Students", "360", "+12 this month", Colors.orange),
                  _buildStatCard("Occupied Rooms", "102", "85% Occupied", Colors.green),
                  _buildStatCard("Vacant Rooms", "18", "15% Vacant", Colors.purple),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Room Occupancy Chart
            _buildOccupancyChartSection(),
            SizedBox(height: 16),

            // Hostel Block Progress lists
            _buildHostelBlocksSection(),
            SizedBox(height: 16),

            // Residents registry list
            _buildResidentsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOccupancyChartSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Room Status Overview".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(value: 85, color: Color(0xFF10B981), radius: 12, showTitle: false),
                            PieChartSectionData(value: 15, color: Color(0xFFEF4444), radius: 12, showTitle: false),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("120".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text("Total Rooms".tr, style: TextStyle(fontSize: 8, color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _buildLegendRow(Color(0xFF10B981), "Occupied Rooms", "102 (85%)"),
                    SizedBox(height: 12),
                    _buildLegendRow(Color(0xFFEF4444), "Vacant Rooms", "18 (15%)"),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendRow(Color color, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: EdgeInsets.only(top: 4), width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        SizedBox(width: 8),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF757897), fontWeight: FontWeight.w500)),
        ),
        SizedBox(width: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
      ],
    );
  }

  Widget _buildHostelBlocksSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hostel Blocks Breakdown".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _blocks.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final blk = _blocks[index];
              final isBoys = blk['name'].toString().contains('Boys');
              final blockColor = isBoys ? Colors.blue : Colors.pinkAccent;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(blk['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                            Text("${blk['block']} | ${blk['rooms']} Rooms", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                        Text("${blk['pct']}% Occupancy", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: blk['pct'] / 100,
                      color: blockColor,
                      backgroundColor: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResidentsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Hostel Residents Log".tr,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _residents.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final res = _residents[index];
              return ListTile(
                title: Text(res['student'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                subtitle: Text("Room: ${res['room']} | Bed: ${res['bed']}", style: TextStyle(fontSize: 11, color: Colors.grey)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(res['hostel'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                    Text(
                      "Joined: ${res['date']}",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

