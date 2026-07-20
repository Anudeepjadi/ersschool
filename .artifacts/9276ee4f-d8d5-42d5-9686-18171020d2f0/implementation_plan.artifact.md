# Fix Bottom Overflow in ID Card Download Confirmation Dialog

The ID card download confirmation dialog shows a "Bottom Overflowed" error because the ID card preview and confirmation text exceed the available height of the `AlertDialog` content area.

## User Review Required

> [!NOTE]
> I will make the `AlertDialog` scrollable to prevent overflow on smaller screens. This is the standard Material Design way to handle tall dialog content.

## Proposed Changes

### Admin ID Card Screens

I will update the `_showDownloadDialog` method in both Student and Employee ID card screens to enable scrolling.

#### [MODIFY] [admin_id_cards_screen.dart](file:///C:/Users/DELL/ersschool/lib/screens/admin/screens/admin_id_cards_screen.dart)
- Add `scrollable: true` to the `AlertDialog` in `_showDownloadDialog`.

#### [MODIFY] [admin_employee_id_cards_screen.dart](file:///C:/Users/DELL/ersschool/lib/screens/admin/screens/admin_employee_id_cards_screen.dart)
- Add `scrollable: true` to the `AlertDialog` in `_showDownloadDialog`.

## Verification Plan

### Automated Tests
- Run `analyze_file` on both modified files to ensure no syntax errors.

### Manual Verification
- Open the Student or Employee ID cards screen.
- Tap the download icon for any record.
- Verify the "Confirm download" dialog appears without any overflow errors, even if the window/screen size is reduced.
