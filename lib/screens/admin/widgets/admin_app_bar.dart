import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../../../core/localization/language_manager.dart';
import '../tabs/admin_more_tab.dart';


class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final Widget? leading;
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onProfileTap;
  final List<Widget>? actions;
  final bool showSchoolSelector;

  const AdminAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.leading,
    this.onOpenDrawer,
    this.onProfileTap,
    this.actions,
    this.showSchoolSelector = true,
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
            title.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle.tr,
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
                  value: 'mails',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.mail_outline, color: Color(0xFF0038FF), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Support Mails".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("12 unread queries".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'chats',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.chat_bubble_outline, color: Color(0xFF0038FF), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Active Chats".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("5 unread messages".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'payments',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.payment, color: Color(0xFF10B981), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Payments Received".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("3 recent transactions".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'leaves',
                  child: Row(
                    children: [
                      Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.event_note, color: Color(0xFFF59E0B), size: 20)),
                      SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Leave Requests".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("2 pending approvals".tr, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
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
                child: Text("5".tr,
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
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminMoreTab()));
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: ValueListenableBuilder<String?>(
                valueListenable: ProfileManager().adminProfileImagePath,
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
      bottom: showSchoolSelector
          ? PreferredSize(
              preferredSize: Size.fromHeight(24),
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(), // Empty space on left
                    // School Selector Pill moved below notifications
                    PopupMenuButton<String>(
                      onSelected: (String school) {
                        debugPrint("AdminAppBar selected school: $school");
                        ProfileManager().selectedSchool.value = school;
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Ecstasy School 1',
                          child: Text('Ecstasy School 1'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                        PopupMenuItem<String>(
                          value: 'Ecstasy School 2',
                          child: Text('Ecstasy School 2'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                        PopupMenuItem<String>(
                          value: 'Ecstasy School 3',
                          child: Text('Ecstasy School 3'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                      ],
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ValueListenableBuilder<String>(
                          valueListenable: ProfileManager().selectedSchool,
                          builder: (context, selectedSchool, _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  selectedSchool,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  size: 14,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(24),
              child: SizedBox(height: 24),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(72);
}
