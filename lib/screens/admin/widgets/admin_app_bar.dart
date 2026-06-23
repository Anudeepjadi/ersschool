import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/profile_manager.dart';
import '../tabs/admin_more_tab.dart';
import '../screens/admin_invalid_fee_data_screen.dart';
import '../screens/admin_invalid_fee_totals_screen.dart';
import '../screens/admin_fee_not_gen_students_screen.dart';
import '../screens/admin_transaction_logs_screen.dart';

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
                  icon: const Icon(Icons.menu, size: 26, color: Colors.white),
                  onPressed: onOpenDrawer,
                )
              : (Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: actions ?? [
        // Super Admin Settings Dropdown (Icon: Computer with Gear dropdown)
        PopupMenuButton<String>(
          icon: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.settings_suggest, color: Colors.white, size: 24),
              Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
            ],
          ),
          offset: const Offset(0, 45),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onSelected: (value) {
            if (value == 'invalid_data') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminInvalidFeeDataScreen()),
              );
            } else if (value == 'invalid_totals') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminInvalidFeeTotalsScreen()),
              );
            } else if (value == 'fee_not_gen') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminFeeNotGenStudentsScreen()),
              );
            } else if (value == 'transaction_logs') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminTransactionLogsScreen()),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'invalid_data',
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 20),
                  SizedBox(width: 12),
                  Text("Invalid Fee Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'invalid_totals',
              child: Row(
                children: [
                  Icon(Icons.difference_outlined, color: Color(0xFFF59E0B), size: 20),
                  SizedBox(width: 12),
                  Text("Invalid Fee Totals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'fee_not_gen',
              child: Row(
                children: [
                  Icon(Icons.person_search_outlined, color: Color(0xFF3B82F6), size: 20),
                  SizedBox(width: 12),
                  Text("Fee not Gen Students", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: 'transaction_logs',
              child: Row(
                children: [
                  Icon(Icons.receipt_long, color: Color(0xFF10B981), size: 20),
                  SizedBox(width: 12),
                  Text("Transaction logs", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))),
                ],
              ),
            ),
          ],
        ),
        // Notification bell with badge 5
        Stack(
          alignment: Alignment.center,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 24),
              offset: const Offset(0, 45),
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'mails',
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mail_outline, color: Color(0xFF0038FF), size: 20)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Support Mails", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("12 unread queries", style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'chats',
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0038FF), size: 20)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Active Chats", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("5 unread messages", style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'payments',
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.payment, color: Color(0xFF10B981), size: 20)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Payments Received", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("3 recent transactions", style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'leaves',
                  child: Row(
                    children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.event_note, color: Color(0xFFF59E0B), size: 20)),
                      const SizedBox(width: 12),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Leave Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875))), Text("2 pending approvals", style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 6,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                child: const Text(
                  "5",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        // User profile photo
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: GestureDetector(
            onTap: onProfileTap ?? () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMoreTab()));
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
                    child: path == null ? const Icon(Icons.person, color: AppColors.primary, size: 20) : null,
                  );
                },
              ),
            ),
          ),
        ),
      ],
      bottom: showSchoolSelector
          ? PreferredSize(
              preferredSize: const Size.fromHeight(24),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(), // Empty space on left
                    // School Selector Pill moved below notifications
                    PopupMenuButton<String>(
                      onSelected: (String school) {
                        debugPrint("AdminAppBar selected school: $school");
                        ProfileManager().selectedSchool.value = school;
                      },
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Ecstasy School 1',
                          child: Text('Ecstasy School 1', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Ecstasy School 2',
                          child: Text('Ecstasy School 2', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Ecstasy School 3',
                          child: Text('Ecstasy School 3', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                const Icon(Icons.school, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  selectedSchool,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
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
          : const PreferredSize(
              preferredSize: Size.fromHeight(24),
              child: SizedBox(height: 24),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
