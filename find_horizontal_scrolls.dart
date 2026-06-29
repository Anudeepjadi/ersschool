import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    final content = file.readAsStringSync();
    if (content.contains('scrollDirection: Axis.horizontal')) {
      final lines = content.split('\n');
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].contains('scrollDirection: Axis.horizontal')) {
          print('--- ${file.path} : line ${i + 1} ---');
          final start = (i - 5).clamp(0, lines.length);
          final end = (i + 10).clamp(0, lines.length);
          for (int j = start; j < end; j++) {
            print('${j + 1}: ${lines[j]}');
          }
        }
      }
    }
  }
}
