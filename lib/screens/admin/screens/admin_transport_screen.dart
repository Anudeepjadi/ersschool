import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminTransportScreen extends StatefulWidget {
  const AdminTransportScreen({super.key});

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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transport Management",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Track routes, buses, and driver rosters",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: "Routes & Buses"),
            Tab(text: "Drivers Registry"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoutesTab(),
          _buildDriversTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_road, color: Colors.white),
        label: const Text("New Route", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 16),

          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search routes by number, name, or vehicle...",
              hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            "Active Fleet & Route Status",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 10),

          // Routes List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredRoutes.length,
            itemBuilder: (context, index) {
              final r = filteredRoutes[index];
              final isDelayed = r['status'].toString().contains('Delayed');
              final occupancyRate = r['occupancy'] / r['capacity'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                r['routeNo'],
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.directions_bus, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              r['busNo'],
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF757897)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const SizedBox(height: 10),
                    Text(
                      r['routeName'],
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Assigned Driver", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(r['driver'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Stops Covered", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text("${r['stops']} Stops", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Occupancy Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seat Occupancy", style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                        Text(
                          "${r['occupancy']} / ${r['capacity']} seats (${(occupancyRate * 100).toInt()}%)",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildDriversTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _drivers.length,
      itemBuilder: (context, index) {
        final d = _drivers[index];
        final isActive = d['status'] == 'Active';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
                child: const Icon(Icons.person, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          d['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const SizedBox(height: 2),
                    Text(
                      "Lic: ${d['license']}",
                      style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Experience", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(d['experience'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Assigned", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(d['route'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Safety Rating", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 2),
                                Text(
                                  d['rating'].toString(),
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
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
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
