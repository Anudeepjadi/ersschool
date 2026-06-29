import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminFeeTypesScreen extends StatefulWidget {
  const AdminFeeTypesScreen({super.key});
  @override
  State<AdminFeeTypesScreen> createState() => _AdminFeeTypesScreenState();
}

class _AdminFeeTypesScreenState extends State<AdminFeeTypesScreen> {
  final _store = AppDataStore.instance;
  final _typeCtrl = TextEditingController();

  List<Map<String, dynamic>> get _feeTypes => _store.feeTypes;

  @override
  void initState() {
    super.initState();
    _store.configVersion.addListener(_onStoreChanged);
  }

  void _onStoreChanged() => setState(() {});

  @override
  void dispose() {
    _store.configVersion.removeListener(_onStoreChanged);
    _typeCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog({int? editIndex}) {
    _typeCtrl.text =
        editIndex != null ? (_feeTypes[editIndex]['type'] ?? '') : '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          editIndex != null ? 'Edit Fee Type' : 'Add Fee Type',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: TextField(
          controller: _typeCtrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Fee Type Name',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB45309),
                foregroundColor: Colors.white),
            onPressed: () {
              final val = _typeCtrl.text.trim();
              if (val.isEmpty) return;
              if (editIndex != null) {
                _store.updateFeeType(
                    editIndex, {..._feeTypes[editIndex], 'type': val});
              } else {
                _store.addFeeType({'type': val, 'isActive': true});
              }
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    editIndex != null ? 'Fee type updated' : 'Fee type added'),
                backgroundColor: Color(0xFFB45309),
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
    final name = _feeTypes[index]['type'] ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Fee Type'.tr,
            style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Delete "$name"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              _store.deleteFeeType(index);
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Fee type deleted'.tr),
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
      appBar: const AdminAppBar(
          title: 'Fee Types', subtitle: 'Manage student fee types'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: const Color(0xFFB45309),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF1E2875),
          child: Row(children: [
            Expanded(
                flex: 3,
                child: Text('Fee Type'.tr,
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
            const SizedBox(width: 72),
          ]),
        ),
        Expanded(
          child: _feeTypes.isEmpty
              ? Center(child: Text('No fee types added yet.'.tr,
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _feeTypes.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (_, i) {
                    final f = _feeTypes[i];
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 13),
                      child: Row(children: [
                        Expanded(
                            flex: 3,
                            child: Text(f['type'] ?? '',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500))),
                        Expanded(
                          flex: 2,
                          child: Icon(
                            (f['isActive'] as bool? ?? true)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: Color(0xFF2563EB),
                            size: 20,
                          ),
                        ),
                        Row(children: [
                          InkWell(
                            onTap: () => _showAddDialog(editIndex: i),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Color(0xFF2563EB),
                                  shape: BoxShape.circle),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () => _delete(i),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  shape: BoxShape.circle),
                              child: Icon(Icons.delete_outline,
                                  color: Colors.red.shade700, size: 14),
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
            Text('1 - ${_feeTypes.length} of ${_feeTypes.length}',
                style:
                    TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
