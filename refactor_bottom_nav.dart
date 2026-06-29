// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final dir = Directory('lib/screens/admin/screens');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.dart'));
  int updated = 0;

  for (var file in files) {
    String content = file.readAsStringSync();
    
    // Add import if missing
    if (!content.contains("import '../widgets/admin_bottom_nav_bar.dart';")) {
      content = content.replaceFirst(
        "import '../widgets/admin_app_bar.dart';", 
        "import '../widgets/admin_app_bar.dart';\nimport '../widgets/admin_bottom_nav_bar.dart';"
      );
    }

    // Inject bottomNavigationBar if missing
    if (!content.contains('bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4)')) {
      // Find appBar: const AdminAppBar(...)
      final RegExp appBarRegex = RegExp(r'(appBar:\s*const AdminAppBar\([^)]+\),)');
      if (appBarRegex.hasMatch(content)) {
        content = content.replaceFirstMapped(
          appBarRegex, 
          (match) => '${match.group(1)}\n      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),'
        );
        
        file.writeAsStringSync(content);
        print('Updated ${file.path}');
        updated++;
      } else {
        print('Warning: No AdminAppBar found in ${file.path}');
      }
    }
  }
  print('Total files updated: $updated');
}
