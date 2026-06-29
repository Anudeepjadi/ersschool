import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminBranchListScreen extends StatefulWidget {
  const AdminBranchListScreen({super.key});
  @override
  State<AdminBranchListScreen> createState() => _AdminBranchListScreenState();
}

class _AdminBranchListScreenState extends State<AdminBranchListScreen> {
  List<Map<String, dynamic>> get _branches => AppDataStore.instance.branches
      .where((b) => b['school'] == ProfileManager().selectedSchool.value)
      .toList();

  final _codeCtrl = TextEditingController();
  final _headCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _codeCtrl.dispose();
    _headCtrl.dispose();
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _showAddDialog({Map<String, dynamic>? edit, int? editIdx}) {
    _codeCtrl.text = edit?['branchCode'] ?? 'ECS00${(_branches.length + 1).toString().padLeft(3, '0')}';
    _headCtrl.text = edit?['principal'] ?? '';
    _nameCtrl.text = edit?['name'] ?? '';
    _addressCtrl.text = edit?['address'] ?? '';
    _phoneCtrl.text = edit?['phone'] ?? '';
    _emailCtrl.text = edit?['email'] ?? '';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          edit != null ? 'Edit Branch' : 'Add New Branch',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(_codeCtrl, 'Branch Code'),
            SizedBox(height: 10),
            _field(_headCtrl, 'Branch Head'),
            SizedBox(height: 10),
            _field(_nameCtrl, 'Branch Name'),
            SizedBox(height: 10),
            _field(_addressCtrl, 'Branch Address'),
            SizedBox(height: 10),
            _field(_phoneCtrl, 'Contact Number', TextInputType.phone),
            SizedBox(height: 10),
            _field(_emailCtrl, 'Email Address', TextInputType.emailAddress),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB45309), foregroundColor: Colors.white),
            onPressed: () {
              if (_nameCtrl.text.isEmpty) return;
              setState(() {
                final newBranch = {
                  'branchCode': _codeCtrl.text,
                  'principal': _headCtrl.text,
                  'name': _nameCtrl.text,
                  'address': _addressCtrl.text,
                  'phone': _phoneCtrl.text,
                  'email': _emailCtrl.text,
                  'students': edit?['students'] ?? 0,
                  'teachers': edit?['teachers'] ?? 0,
                  'status': 'Active',
                  'established': DateTime.now().year.toString(),
                  'color': Color(0xFF0038FF),
                  'icon': Icons.apartment,
                  'school': ProfileManager().selectedSchool.value,
                };
                if (edit != null) {
                  final idx = AppDataStore.instance.branches.indexOf(edit);
                  if (idx != -1) AppDataStore.instance.branches[idx] = newBranch;
                } else {
                  AppDataStore.instance.addBranch(newBranch);
                }
              });
              Navigator.pop(ctx);
            },
            child: Text(edit != null ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  void _delete(Map<String, dynamic> branch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Branch'.tr,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this branch?'.tr),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'.tr)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => AppDataStore.instance.deleteBranch(branch));
              Navigator.pop(ctx);
            },
            child: Text('Delete'.tr),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      [TextInputType type = TextInputType.text]) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(title: 'Branch', subtitle: 'Manage school branches'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: const Color(0xFFB45309),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF1E2875),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Text('Code'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            Expanded(
              flex: 5,
              child: Text('Name & Head'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            Expanded(
              flex: 3,
              child: Text('Contact'.tr,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            const SizedBox(width: 72),
          ]),
        ),
        // Rows
        Expanded(
          child: _branches.isEmpty
              ? Center(child: Text('No branches found'.tr,
                      style: TextStyle(color: Colors.grey)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _branches.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, i) {
                    final b = _branches[i];
                    final code = b['branchCode'] ??
                        'ECS${(i + 1).toString().padLeft(3, '0')}';
                    final name = b['name'] ?? '';
                    final head = b['principal'] ?? '';
                    final phone = b['phone'] ?? '';
                    final email = b['email'] ?? '';
                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code
                          Expanded(
                            flex: 2,
                            child: Text(code,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875))),
                          ),
                          // Name + head + address
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB45309))),
                                if (head.isNotEmpty)
                                  Text(head,
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                if (email.isNotEmpty)
                                  Text(email,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          // Phone
                          Expanded(
                            flex: 3,
                            child: Text(phone,
                                style: TextStyle(fontSize: 11),
                                maxLines: 2),
                          ),
                          // Actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () =>
                                    _showAddDialog(edit: b, editIdx: i),
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
                              SizedBox(width: 4),
                              if (_branches.length > 1)
                                InkWell(
                                  onTap: () => _delete(b),
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
                            ],
                          ),
                        ],
                      ),
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white),
              child: Text('10'.tr, style: TextStyle(fontSize: 12)),
            ),
            SizedBox(width: 16),
            Text('1 - ${_branches.length} of ${_branches.length}',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
