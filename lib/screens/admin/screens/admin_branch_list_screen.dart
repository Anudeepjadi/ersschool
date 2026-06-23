import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import '../../../core/data/app_data_store.dart';
import '../../../core/utils/profile_manager.dart';

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
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
        ),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            _field(_codeCtrl, 'Branch Code'),
            const SizedBox(height: 10),
            _field(_headCtrl, 'Branch Head'),
            const SizedBox(height: 10),
            _field(_nameCtrl, 'Branch Name'),
            const SizedBox(height: 10),
            _field(_addressCtrl, 'Branch Address'),
            const SizedBox(height: 10),
            _field(_phoneCtrl, 'Contact Number', TextInputType.phone),
            const SizedBox(height: 10),
            _field(_emailCtrl, 'Email Address', TextInputType.emailAddress),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB45309), foregroundColor: Colors.white),
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
                  'color': const Color(0xFF0038FF),
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
        title: const Text('Delete Branch',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to delete this branch?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => AppDataStore.instance.deleteBranch(branch));
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: const AdminAppBar(title: 'Branch', subtitle: 'Manage school branches'),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(children: [
        // Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Column(children: [
              const Text('Branch List',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45309))),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add New'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB45309),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ]),
          ),
        ),
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: const Color(0xFF2D3748),
          child: const Row(children: [
            SizedBox(width: 72, child: Text('Code', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            Expanded(child: Text('Name & Head', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 72, child: Text('Contact', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
            SizedBox(width: 72),
          ]),
        ),
        // Rows
        Expanded(
          child: _branches.isEmpty
              ? const Center(
                  child: Text('No branches found',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code
                          SizedBox(
                            width: 72,
                            child: Text(code,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E2875))),
                          ),
                          // Name + head + address
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB45309))),
                                if (head.isNotEmpty)
                                  Text(head,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                if (email.isNotEmpty)
                                  Text(email,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          // Phone
                          SizedBox(
                            width: 72,
                            child: Text(phone,
                                style: const TextStyle(fontSize: 11),
                                maxLines: 2),
                          ),
                          // Actions
                          SizedBox(
                            width: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _showAddDialog(edit: b, editIdx: i),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFF2563EB),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                                const SizedBox(width: 4),
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        // Footer
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFFFEF3C7),
          child: Row(children: [
            const Text('Items per page:',
                style: TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white),
              child: const Text('10', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: 16),
            Text('1 - ${_branches.length} of ${_branches.length}',
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
        ),
      ]),
    );
  }
}
