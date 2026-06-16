import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/empty_state_widget.dart';

class DiaryTab extends StatelessWidget {
  const DiaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateSelector(),
        const SizedBox(height: 80),
        const EmptyStateWidget(
          icon: Icons.menu_book_outlined,
          title: "No Diary Entries",
          subtitle: "There are no diary entries for this date.",
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.chevron_left, color: Colors.grey.shade400),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 10),
              const Text(
                "Monday, 20 May 2024",
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 18),
            ],
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}
