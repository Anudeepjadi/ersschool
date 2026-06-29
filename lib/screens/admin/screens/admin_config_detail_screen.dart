import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';

class AdminConfigDetailScreen extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;

  const AdminConfigDetailScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  State<AdminConfigDetailScreen> createState() => _AdminConfigDetailScreenState();
}

class _AdminConfigDetailScreenState extends State<AdminConfigDetailScreen> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    // Generate some mock items based on the title
    _items = List.generate(5, (index) => {
      'id': index + 1,
      'name': '${widget.title} Entry ${index + 1}',
      'details': 'Configuration details for ${widget.title.toLowerCase()} item.',
      'status': index % 2 == 0 ? 'Active' : 'Inactive',
    });
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Add New ${widget.title}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: "${widget.title} Name")),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: "Description/Value")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.insert(0, {
                  'id': _items.length + 1,
                  'name': 'New ${widget.title} Entry',
                  'details': 'Newly added configuration details.',
                  'status': 'Active',
                });
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("New ${widget.title} added.")));
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Edit ${widget.title}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: _items[index]['name']),
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: TextEditingController(text: _items[index]['details']),
              decoration: const InputDecoration(labelText: "Details"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              // Mock update logic
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.title} updated successfully.")));
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Entry", style: TextStyle(color: Colors.red)),
        content: const Text("Are you sure you want to remove this configuration entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Entry deleted.")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete"),
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
        subtitle: "Manage your ${widget.title.toLowerCase()} configurations",
      ),
      bottomNavigationBar: const AdminBottomNavBar(currentIndex: 4),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _items.isEmpty
                ? Center(child: Text("No ${widget.title.toLowerCase()} found", style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      final isActive = item['status'] == 'Active';
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: widget.color.withValues(alpha: 0.1),
                            child: Icon(widget.icon, color: widget.color, size: 20),
                          ),
                          title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['details'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (isActive ? Colors.green : Colors.red).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(item['status'], style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.green : Colors.red)),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_note, color: Colors.blue, size: 24),
                                onPressed: () => _editItem(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                onPressed: () => _deleteItem(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: const Color(0xFF1E2875),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search ${widget.title.toLowerCase()}...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSmallStat("Total", "${_items.length}", Colors.blue),
              const SizedBox(width: 8),
              _buildSmallStat("Active", "${_items.where((it) => it['status'] == 'Active').length}", Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$label: ", style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
