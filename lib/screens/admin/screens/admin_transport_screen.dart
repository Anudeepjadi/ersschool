import 'package:flutter/material.dart';
import 'package:ersschool/core/localization/language_manager.dart';
import 'package:ersschool/core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'transport/admin_vehicle_details_screen.dart';
import 'transport/admin_drivers_list_screen.dart';
import 'transport/admin_transport_students_route_screen.dart';
import 'transport/admin_transport_students_class_screen.dart';

class AdminTransportScreen extends StatelessWidget {
  const AdminTransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      appBar: AdminAppBar(title: "Transport", subtitle: "Manage transport system"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            _buildDashboardCard(context, "Vehicle Details", Icons.directions_bus, const Color(0xFF0D6EFD), const AdminVehicleDetailsScreen()),
            const SizedBox(height: 12),
            _buildDashboardCard(context, "Drivers", Icons.person, const Color(0xFF10B981), const AdminDriversListScreen()),
            const SizedBox(height: 12),
            _buildDashboardCard(context, "Students by Route", Icons.route, const Color(0xFFF59E0B), const AdminTransportStudentsRouteScreen()),
            const SizedBox(height: 12),
            _buildDashboardCard(context, "Students by Class", Icons.class_, const Color(0xFF8B5CF6), const AdminTransportStudentsClassScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title.tr,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2875),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
