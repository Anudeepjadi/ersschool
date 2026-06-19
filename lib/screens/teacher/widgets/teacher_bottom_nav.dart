import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class TeacherBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const TeacherBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex > 5 ? 5 : currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: const Color(0xFF757897),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.class_outlined), activeIcon: Icon(Icons.class_), label: "Classes"),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: "Students"),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: "Exams"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: "Reports"),
        BottomNavigationBarItem(icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz), label: "More"),
      ],
    );
  }
}
