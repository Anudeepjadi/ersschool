import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

/// Reusable screen for any "Name + Is Active" list stored in AppDataStore.
/// Pass [dataSource] as a direct reference to the AppDataStore list
/// (e.g. AppDataStore.instance.paymentTypes). All mutations go straight
/// through [AppDataStore.addConfigItem] / [updateConfigItem] / [deleteConfigItem]
/// so every other screen that reads the same list gets the latest data.
class AdminActiveListScreen extends StatefulWidget {
  final String title;
  final String columnLabel;
  final List<Map<String, dynamic>> dataSource;
  final Color accentColor;

  const AdminActiveListScreen({
    super.key,
    required this.title,
    required this.columnLabel,
    required this.dataSource,
    required this.accentColor,
  });

  @override
  State<AdminActiveListScreen> createState() => _AdminActiveListScreenState();
}

class _AdminActiveListScreenState extends State<AdminActiveListScreen> {
  final _store = AppDataStore.instance;
  final _ctrl = TextEditingController();

  // Convenient alias so build() looks clean
  List<Map<String, dynamic>> get _items => widget.dataSource;

  @override
  void initState() {
    super.initState();
    // Listen for config changes triggered by OTHER screens
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => setState(() {});

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _ctrl.dispose();
    super.dispose();
  }

  void _showDialog({int? editIndex}) {
    _ctrl.text = editIndex != null ? (_items[editIndex]['name'] ?? '') : '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          editIndex != null ? 'Edit ${widget.title}' : 'Add New',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: widget.columnLabel,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.white),
            onPressed: () {
              final name = _ctrl.text.trim();
              if (name.isEmpty) return;
              if (editIndex != null) {
                _store.updateConfigItem(
                    _items, editIndex, {..._items[editIndex], 'name': name});
              } else {
                _store.addConfigItem(
                    _items, {'name': name, 'isActive': true});
              }
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(editIndex != null
                    ? '${widget.columnLabel} updated'
                    : '${widget.columnLabel} added'),
                backgroundColor: widget.accentColor,
                behavior: SnackBarBehavior.floating,
              ));
            },
            child: Text(editIndex != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _delete(int index) {
    final name = _items[index]['name'] ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Entry'.tr,
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Delete "$name"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _store.deleteConfigItem(_items, index);
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Entry deleted'.tr),
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
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
          title: widget.title,
          subtitle: 'Manage ${widget.title.toLowerCase()}'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        backgroundColor: widget.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF1E2875),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Text(widget.columnLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
            Expanded(
                flex: 2,
                child: Text('Is Active'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13))),
            const SizedBox(width: 76),
          ]),
        ),
        // Rows
        Expanded(
          child: _items.isEmpty
              ? Center(
                  child: Text(
                      'No ${widget.title.toLowerCase()} found.\nTap "Add New" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _items.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) {
                    final item = _items[i];
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 13),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text(item['name'] ?? '',
                                style: TextStyle(fontSize: 13))),
                        Expanded(
                          flex: 2,
                          child: Icon(
                            (item['isActive'] as bool? ?? true)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                        ),
                        Row(children: [
                          InkWell(
                            onTap: () => _showDialog(editIndex: i),
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
        // Footer
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
            Text('1 - ${_items.length} of ${_items.length}',
                style:
                    TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
