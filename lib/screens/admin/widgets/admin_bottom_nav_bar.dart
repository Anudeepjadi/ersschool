import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../admin_dashboard_screen.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTabSelected;

  const AdminBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTabSelected,
  });

  void _handleTap(BuildContext context, int index) {
    if (onTabSelected != null) {
      // We are on the Dashboard, just change the tab
      onTabSelected!(index);
    } else {
      // We are on a sub-screen, navigate back to Dashboard with the selected tab
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboardScreen(initialIndex: index),
        ),
        (route) => false, // Clear all previous routes (reset to Dashboard)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFF757897),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      onTap: (index) => _handleTap(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined),
          label: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: "Students",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Teachers",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business_outlined),
          label: "Branches",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: "More",
        ),
      ],
    );
  }
}
