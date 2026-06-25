import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminTransportScreen extends StatefulWidget {
  AdminTransportScreen({super.key});

  @override
  State<AdminTransportScreen> createState() => _AdminTransportScreenState();
}

class _AdminTransportScreenState extends State<AdminTransportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _routes = [
    {
      'routeNo': 'Route 12',
      'routeName': 'Green Park - Saket - AIIMS',
      'busNo': 'DL 01 AB 1234',
      'driver': 'Ramesh Kumar',
      'driverPhone': '+91 98765 12345',
      'stops': 14,
      'occupancy': 32,
      'capacity': 40,
      'status': 'On Time',
    },
    {
      'routeNo': 'Route 05',
      'routeName': 'Dwarka Sec 6 - Janakpuri - Rajouri',
      'busNo': 'DL 01 CD 5678',
      'driver': 'Jagdish Singh',
      'driverPhone': '+91 98765 67890',
      'stops': 18,
      'occupancy': 38,
      'capacity': 42,
      'status': 'Delayed (10m)',
    },
    {
      'routeNo': 'Route 18',
      'routeName': 'Vasant Kunj - Munirka - RK Puram',
      'busNo': 'DL 01 EF 9012',
      'driver': 'Baldev Raj',
      'driverPhone': '+91 98765 34567',
      'stops': 10,
      'occupancy': 18,
      'capacity': 35,
      'status': 'On Time',
    },
    {
      'routeNo': 'Route 09',
      'routeName': 'Noida Sec 62 - Mayur Vihar - Akshardham',
      'busNo': 'UP 16 AT 4321',
      'driver': 'Sanjeev Yadav',
      'driverPhone': '+91 98765 89012',
      'stops': 12,
      'occupancy': 28,
      'capacity': 40,
      'status': 'On Time',
    },
  ];

  final List<Map<String, dynamic>> _drivers = [
    {
      'name': 'Ramesh Kumar',
      'phone': '+91 98765 12345',
      'license': 'DL-012015003948',
      'rating': 4.8,
      'experience': '8 Years',
      'route': 'Route 12',
      'status': 'Active',
    },
    {
      'name': 'Jagdish Singh',
      'phone': '+91 98765 67890',
      'license': 'DL-052012004829',
      'rating': 4.5,
      'experience': '12 Years',
      'route': 'Route 05',
      'status': 'Active',
    },
    {
      'name': 'Baldev Raj',
      'phone': '+91 98765 34567',
      'license': 'DL-182019001294',
      'rating': 4.9,
      'experience': '5 Years',
      'route': 'Route 18',
      'status': 'Active',
    },
    {
      'name': 'Sanjeev Yadav',
      'phone': '+91 98765 89012',
      'license': 'UP-162016008234',
      'rating': 4.2,
      'experience': '7 Years',
      'route': 'Route 09',
      'status': 'On Leave',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: "Transport Management", subtitle: "Manage your account details"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoutesTab(),
          _buildDriversTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {},
        backgroundColor: AppColors.primaryDark,
        icon: Icon(Icons.add_road, color: Colors.white),
        label: Text("New Route".tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRoutesTab() {
    final filteredRoutes = _routes.where((r) {
      return r['routeNo']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['routeName']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r['busNo']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bus Image Banner
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Manage Fleet".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        SizedBox(height: 8),
                        Text("Track and manage your school buses in real time.".tr, style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/school_bus.png", fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Stats Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatCard("Total Routes", "15 Active", "Covering entire city", Colors.blue),
                _buildStatCard("Total Buses", "18 Vehicles", "3 on standby", Colors.purple),
                _buildStatCard("Students Enrolled", "650", "84% occupancy rate", Colors.teal),
                _buildStatCard("Active Alerts", "1 Delay", "Bus 5 running late", Colors.red),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search routes by number, name, or vehicle...",
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Title
          Text("Active Fleet & Route Status".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 10),

          // Routes List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredRoutes.length,
            itemBuilder: (context, index) {
              final r = filteredRoutes[index];
              final isDelayed = r['status'].toString().contains('Delayed');
              final occupancyRate = r['occupancy'] / r['capacity'];

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                r['routeNo'],
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.directions_bus, size: 16, color: Colors.orange),
                            SizedBox(width: 4),
                            Text(
                              r['busNo'],
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF757897)),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isDelayed ? Colors.red : Colors.green).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            r['status'],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDelayed ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      r['routeName'],
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                    ),
                    Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Assigned Driver".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Text(r['driver'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Stops Covered".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Text("${r['stops']} Stops", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Occupancy Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seat Occupancy".tr, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                        Text(
                          "${r['occupancy']} / ${r['capacity']} seats (${(occupancyRate * 100).toInt()}%)",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: occupancyRate,
                        backgroundColor: Colors.grey.shade100,
                        color: occupancyRate > 0.9 ? Colors.red : AppColors.primary,
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildDriversTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _drivers.length,
      itemBuilder: (context, index) {
        final d = _drivers[index];
        final isActive = d['status'] == 'Active';

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: AppColors.primary, size: 24),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          d['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            d['status'],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Lic: ${d['license']}",
                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Experience".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Text(d['experience'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Assigned".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Text(d['route'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Safety Rating".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 12),
                                SizedBox(width: 2),
                                Text(
                                  d['rating'].toString(),
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 130,
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
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
