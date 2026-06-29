import 'dart:io';

void main() {
  final dir = Directory('lib/screens/admin/screens');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.dart'));
  int updated = 0;

  for (var file in files) {
    String content = file.readAsStringSync();
    
    if (!content.contains('appBar: AppBar(')) continue;

    // Add import if missing
    if (!content.contains("import '../widgets/admin_app_bar.dart';")) {
      content = content.replaceFirst("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport '../widgets/admin_app_bar.dart';");
    }

    int startIndex = content.indexOf('appBar: AppBar(');
    while (startIndex != -1) {
      int openParenIndex = content.indexOf('(', startIndex);
      int parenCount = 1;
      int endIndex = openParenIndex + 1;
      
      while (parenCount > 0 && endIndex < content.length) {
        if (content[endIndex] == '(') parenCount++;
        if (content[endIndex] == ')') parenCount--;
        endIndex++;
      }
      
      String appBarBlock = content.substring(startIndex, endIndex);
      
      // Extract title
      final titleMatch = RegExp(r'Text\(\s*["\x27]([^"\x27]+)["\x27]').firstMatch(appBarBlock);
      String title = titleMatch != null ? titleMatch.group(1)! : "Admin Profile";
      
      String newAppBar = 'appBar: const AdminAppBar(title: "$title", subtitle: "Manage your account details")';
      content = content.replaceRange(startIndex, endIndex, newAppBar);
      
      startIndex = content.indexOf('appBar: AppBar(');
    }
    
    file.writeAsStringSync(content);
    print('Updated ${file.path}');
    updated++;
  }
  print('Total files updated: $updated');
}
