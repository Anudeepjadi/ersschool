import 'dart:io';

void main() {
  var file = File('c:/Users/DELL/ersschool/lib/screens/admin/screens/admin_fees_screen.dart');
  var text = file.readAsStringSync();
  text = text.replaceAll('â‚¹', '₹');
  file.writeAsStringSync(text);
}
