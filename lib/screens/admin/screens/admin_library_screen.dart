import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AdminLibraryScreen extends StatefulWidget {
  const AdminLibraryScreen({super.key});

  @override
  State<AdminLibraryScreen> createState() => _AdminLibraryScreenState();
}

class _AdminLibraryScreenState extends State<AdminLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _books = [
    {
      'title': 'Brief History of Time',
      'author': 'Stephen Hawking',
      'category': 'Science',
      'isbn': '978-0553380163',
      'shelf': 'Shelf B-4',
      'status': 'Available',
      'total': 5,
      'available': 4,
    },
    {
      'title': 'Principles of Mathematics',
      'author': 'Bertrand Russell',
      'category': 'Maths',
      'isbn': '978-0415487412',
      'shelf': 'Shelf A-1',
      'status': 'Available',
      'total': 3,
      'available': 1,
    },
    {
      'title': 'Introduction to Algorithms',
      'author': 'Thomas H. Cormen',
      'category': 'Tech',
      'isbn': '978-0262033848',
      'shelf': 'Shelf C-2',
      'status': 'Out of Stock',
      'total': 4,
      'available': 0,
    },
    {
      'title': 'To Kill a Mockingbird',
      'author': 'Harper Lee',
      'category': 'Literature',
      'isbn': '978-0446310789',
      'shelf': 'Shelf D-5',
      'status': 'Available',
      'total': 8,
      'available': 6,
    },
    {
      'title': 'The Code Book',
      'author': 'Simon Singh',
      'category': 'Tech',
      'isbn': '978-0385495325',
      'shelf': 'Shelf C-3',
      'status': 'Available',
      'total': 3,
      'available': 3,
    },
    {
      'title': 'Calculus Made Easy',
      'author': 'Silvanus P. Thompson',
      'category': 'Maths',
      'isbn': '978-0312185480',
      'shelf': 'Shelf A-3',
      'status': 'Available',
      'total': 5,
      'available': 5,
    },
  ];

  final List<Map<String, dynamic>> _issuedRegistry = [
    {
      'student': 'Anudeep Jaadi',
      'rollNo': 'ECS0801',
      'class': 'Class 8-A',
      'book': 'Brief History of Time',
      'issuedDate': '10 Jun 2026',
      'dueDate': '25 Jun 2026',
      'status': 'Active',
    },
    {
      'student': 'Priya Sharma',
      'rollNo': 'ECS0814',
      'class': 'Class 8-B',
      'book': 'Introduction to Algorithms',
      'issuedDate': '28 May 2026',
      'dueDate': '12 Jun 2026',
      'status': 'Overdue',
    },
    {
      'student': 'Amit Verma',
      'rollNo': 'ECS0904',
      'class': 'Class 9-A',
      'book': 'To Kill a Mockingbird',
      'issuedDate': '05 Jun 2026',
      'dueDate': '20 Jun 2026',
      'status': 'Active',
    },
    {
      'student': 'Sneha Patel',
      'rollNo': 'ECS1012',
      'class': 'Class 10-A',
      'book': 'Principles of Mathematics',
      'issuedDate': '12 May 2026',
      'dueDate': '27 May 2026',
      'status': 'Overdue',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Library Management",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            ),
            Text(
              "Track catalog, issuances, and returns",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: "Catalog & Stats"),
            Tab(text: "Issued Register"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCatalogTab(),
          _buildIssuedTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Book", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCatalogTab() {
    final filteredBooks = _books.where((book) {
      final matchesCategory = _selectedCategory == 'All' || book['category'] == _selectedCategory;
      final matchesSearch = book['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['author']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book['isbn']!.contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatCard("Total Catalog", "25,480", "Books available", Colors.blue),
                _buildStatCard("Active Issuances", "1,240", "Out of library", Colors.orange),
                _buildStatCard("Overdue Books", "89", "Requires action", Colors.red),
                _buildStatCard("New Additions", "+142", "This month", Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Donut chart of categories
          _buildCategoryDistribution(),
          const SizedBox(height: 24),

          // Search Bar
          _buildSearchBar(),
          const SizedBox(height: 14),

          // Horizontal Categories
          _buildCategoryFilterRow(),
          const SizedBox(height: 16),

          // Books List Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Books in Catalog (${filteredBooks.length})",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              const Icon(Icons.sort_outlined, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 10),

          // Catalog List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return _buildBookItem(book);
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildIssuedTab() {
    return Column(
      children: [
        // Top filters inside Issued Tab
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      _searchQuery = v;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search by student name or roll number...",
                    hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.filter_list_outlined, color: AppColors.primary, size: 20),
              ),
            ],
          ),
        ),

        // Issued books list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _issuedRegistry.length,
            itemBuilder: (context, index) {
              final log = _issuedRegistry[index];
              final isOverdue = log['status'] == 'Overdue';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          log['student'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isOverdue ? Colors.red : Colors.green).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            log['status'],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isOverdue ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${log['rollNo']} • ${log['class']}",
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.book, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            log['book'],
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E2875)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Issued Date", style: TextStyle(fontSize: 9, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(log['issuedDate'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Due Date", style: TextStyle(fontSize: 9, color: isOverdue ? Colors.red.shade300 : Colors.grey)),
                            const SizedBox(height: 2),
                            Text(
                              log['dueDate'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isOverdue ? Colors.red : const Color(0xFF1E2875),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isOverdue) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.notifications_active, color: Colors.white, size: 12),
                            label: const Text("Send Reminder", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      )
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String subtext, Color color) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Category Distribution",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 32,
                    sections: [
                      PieChartSectionData(color: Colors.blue, value: 35, radius: 14, showTitle: false),
                      PieChartSectionData(color: Colors.purple, value: 20, radius: 14, showTitle: false),
                      PieChartSectionData(color: Colors.teal, value: 25, radius: 14, showTitle: false),
                      PieChartSectionData(color: Colors.orange, value: 20, radius: 14, showTitle: false),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem("Science (35%)", Colors.blue),
                    const SizedBox(height: 6),
                    _buildLegendItem("Maths (20%)", Colors.purple),
                    const SizedBox(height: 6),
                    _buildLegendItem("Tech (25%)", Colors.teal),
                    const SizedBox(height: 6),
                    _buildLegendItem("Literature (20%)", Colors.orange),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF757897))),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: "Search books by title, author, or ISBN...",
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryFilterRow() {
    final categories = ['All', 'Science', 'Maths', 'Tech', 'Literature'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = cat;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF757897),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade200),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookItem(Map<String, dynamic> book) {
    final isAvailable = book['status'] == 'Available';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.book_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        book['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isAvailable ? Colors.green : Colors.red).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book['status']!,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  "By ${book['author']}",
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ISBN: ${book['isbn']}", style: TextStyle(fontSize: 9, color: Colors.grey.shade400)),
                    Text(book['shelf']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                  ],
                ),
                const Divider(height: 14),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      "Available: ${book['available']} / ${book['total']} copies",
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
