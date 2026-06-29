// ignore_for_file: avoid_print
import 'lib/core/data/app_data_store.dart';

void main() {
  final store = AppDataStore.instance;
  final classes = store.studyClasses.map((c) => c['name'] as String).toList();
  final sections = store.classSections.map((s) => s['name'] as String).toList();
  
  List<String> list = [];
  for (int i = 0; i < classes.length; i++) {
    for (int j = 0; j < sections.length; j++) {
      final secName = sections[j].split(' ').last;
      list.add("${classes[i]} - $secName");
    }
  }
  final result = list.toSet().toList();
  print("Length: ${result.length}");
  print("Items: $result");
}
