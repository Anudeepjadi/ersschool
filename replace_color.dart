import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    var content = file.readAsStringSync();
    if (content.contains('0xFF4361EE')) {
      content = content.replaceAll('0xFF4361EE', '0xFF0038FF');
      file.writeAsStringSync(content);
      print('Replaced in ${file.path}');
    }
  }
}
