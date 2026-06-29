import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StudentCurvedHeader extends StatelessWidget {
  final Widget child;

  const StudentCurvedHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 35,
        left: 20,
        right: 20,
      ),
      child: child,
    );
  }
}
