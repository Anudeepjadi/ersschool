import 'dart:io';

void main() {
  final file = File('lib/screens/admin/screens/admin_examinations_screen.dart');
  final lines = file.readAsLinesSync();
  final start = 1623;
  final end = 1744;
  final dialogLines = lines.sublist(start, end + 1);
  lines.removeRange(start, end + 1);
  final insertIndex = lines.indexWhere((l) => l.contains('4. GRADE REPORT VIEW'));
  if (insertIndex != -1) {
    lines.insertAll(insertIndex, dialogLines);
    file.writeAsStringSync(lines.join('\n'));
    print('Success');
  } else {
    print('Failed to find insert point');
  }
}
