import 'dart:io';

void main() {
  final directory = Directory('lib/screens');
  final files = directory.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final newClassesList = "['LKG', 'UKG', 'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5', 'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10']";
  
  final regexes = [
    RegExp(r"\['Grade 1',\s*'Grade 2',\s*'Grade 3',\s*'Grade 4',\s*'Grade 5'\]"),
    RegExp(r"\['Grade 1',\s*'Grade 2',\s*'Grade 3'\]"),
    RegExp(r"\[\s*'Grade 1',\s*'Grade 2',\s*'Grade 3',\s*'Grade 4',\s*'Grade 5'\s*\]"),
    RegExp(r'\["All",\s*"L\.K\.G",\s*"U\.K\.G",\s*"Grade 1",\s*"Grade 2",\s*"Grade 3",\s*"Grade 4",\s*"Grade 5",\s*"Grade 6",\s*"Grade 7",\s*"Grade 8",\s*"Grade 9",\s*"Class 10"\]')
  ];

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    for (final regex in regexes) {
      if (regex.hasMatch(content)) {
        content = content.replaceAll(regex, newClassesList);
        changed = true;
      }
    }
    
    // Replace default value for state
    if (content.contains("'Grade 1'")) {
       content = content.replaceAll("'Grade 1'", "'LKG'");
       changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      // ignore: avoid_print
      print('Updated \${file.path}');
    }
  }
}
