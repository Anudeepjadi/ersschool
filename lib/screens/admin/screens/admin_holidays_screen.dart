import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminHolidaysScreen extends StatefulWidget {
  AdminHolidaysScreen({super.key});
  @override
  State<AdminHolidaysScreen> createState() => _AdminHolidaysScreenState();
}

class _AdminHolidaysScreenState extends State<AdminHolidaysScreen> {
  final _store = AppDataStore.instance;
  DateTime? _selectedDate;
  final _descCtrl = TextEditingController();

  List<Map<String, dynamic>> get _holidays => _store.holidays;

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => setState(() {});

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _descCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog({int? editIndex}) {
    if (editIndex != null) {
      _descCtrl.text = _holidays[editIndex]['description'];
      _selectedDate = null;
    } else {
      _descCtrl.clear();
      _selectedDate = null;
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            editIndex != null ? 'Edit Holiday' : 'Add New Holiday',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: ctx,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setS(() => _selectedDate = picked);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : editIndex != null
                            ? _holidays[editIndex]['date']
                            : 'Select Date',
                    style: TextStyle(
                        color: _selectedDate != null
                            ? Colors.black87
                            : Colors.grey),
                  ),
                ]),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'.tr)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB45309),
                  foregroundColor: Colors.white),
              onPressed: () {
                final desc = _descCtrl.text.trim();
                if (desc.isEmpty) return;
                final dateStr = _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : (editIndex != null
                        ? _holidays[editIndex]['date']
                        : '');
                final entry = {'date': dateStr, 'description': desc};
                if (editIndex != null) {
                  _store.updateHoliday(editIndex, entry);
                } else {
                  _store.addHoliday(entry);
                }
                setState(() {});
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(editIndex != null
                      ? 'Holiday updated'
                      : 'Holiday added'),
                  backgroundColor: Color(0xFFB45309),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              child: Text(editIndex != null ? 'Update' : 'Save'),
            ),
          ],
        );
      }),
    );
  }

  void _delete(int index) {
    final desc = _holidays[index]['description'];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Holiday'.tr,
            style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Delete "$desc"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _store.deleteHoliday(index);
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Holiday deleted'.tr),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: Text('Delete'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(
          title: 'Holidays', subtitle: 'Manage school holidays'),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(children: [
              Text('Holidays List'.tr,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45309))),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(),
                icon: Icon(Icons.add, size: 16),
                label: Text('Add New'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB45309),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Color(0xFF2D3748),
          child: Row(children: [
            Expanded(
                flex: 2,
                child: Text('Date'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
            Expanded(
                flex: 3,
                child: Text('Description'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
            SizedBox(width: 76),
          ]),
        ),
        Expanded(
          child: _holidays.isEmpty
              ? Center(child: Text('No holidays added yet.'.tr,
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _holidays.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (_, i) {
                    final h = _holidays[i];
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(children: [
                        Expanded(
                            flex: 2,
                            child: Text(h['date'],
                                style: TextStyle(fontSize: 13))),
                        Expanded(
                          flex: 3,
                          child: Text(h['description'],
                              style: TextStyle(
                                  fontSize: 13,
                                  color: i < 2
                                      ? Colors.black87
                                      : Color(0xFFB45309))),
                        ),
                        Row(children: [
                          InkWell(
                            onTap: () => _showAddDialog(editIndex: i),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () => _delete(i),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle),
                              child: Icon(Icons.delete_outline,
                                  color: Colors.red.shade700, size: 16),
                            ),
                          ),
                        ]),
                      ]),
                    );
                  },
                ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Color(0xFFFEF3C7),
          child: Row(children: [
            Text('Items per page:'.tr,
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            SizedBox(width: 8),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white),
              child: Text('10'.tr, style: TextStyle(fontSize: 12)),
            ),
            SizedBox(width: 16),
            Text('1 - ${_holidays.length} of ${_holidays.length}',
                style:
                    TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
