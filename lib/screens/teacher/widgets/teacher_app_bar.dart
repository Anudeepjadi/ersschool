import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/profile_manager.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class TeacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;

  const TeacherAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.onOpenDrawer,
    this.onProfileTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 48,
      leading: leading ?? 
          (onOpenDrawer != null
              ? IconButton(
                  icon: Icon(Icons.menu, size: 26, color: Colors.white),
                  onPressed: onOpenDrawer,
                )
              : (Navigator.canPop(context)
                  ? IconButton(
                      icon: Icon(Icons.arrow_back, size: 24, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: actions ?? [
        // Notification bell with badge 5
        Stack(
          alignment: Alignment.center,
          children: [
            PopupMenuButton<String>(
              icon: Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
              offset: Offset(0, 45),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'notices',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.campaign_outlined, color: Color(0xFF0038FF), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Important Notices".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("3 new notices".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'events',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.event, color: Color(0xFF10B981), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Upcoming Events".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("Staff Meeting Tomorrow".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 6,
              top: 8,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                child: Text("2".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        // User profile photo
        Padding(
          padding: EdgeInsets.only(right: 16, left: 4),
          child: GestureDetector(
            onTap: onProfileTap ?? () {
              // Navigate to teacher profile if needed
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ValueListenableBuilder<String?>(
                valueListenable: ProfileManager().teacherProfileImagePath,
                builder: (context, path, _) {
                  return CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: path != null ? FileImage(File(path)) : null,
                    child: path == null ? Icon(Icons.person, color: AppColors.primary, size: 20) : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(48); // Account for toolbar only
}
