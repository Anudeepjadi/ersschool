import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminLibraryScreen extends StatefulWidget {
  AdminLibraryScreen({super.key});

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
      'student': 'Aarav Sharma',
      'rollNo': 'ECS00001',
      'class': 'Class 10-A',
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
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AdminAppBar(title: "Library Management", subtitle: "Manage your account details"),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCatalogTab(),
          _buildIssuedTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {},
        backgroundColor: AppColors.primaryDark,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Add Book".tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(16),
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
          SizedBox(height: 16),

          // Donut chart of categories
          _buildCategoryDistribution(),
          SizedBox(height: 24),

          // Search Bar
          _buildSearchBar(),
          SizedBox(height: 14),

          // Horizontal Categories
          _buildCategoryFilterRow(),
          SizedBox(height: 16),

          // Books List Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Books in Catalog (${filteredBooks.length})",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Icon(Icons.sort_outlined, color: Colors.grey, size: 18),
            ],
          ),
          SizedBox(height: 10),

          // Catalog List
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              final book = filteredBooks[index];
              return _buildBookItem(book);
            },
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildIssuedTab() {
    return Column(
      children: [
        // Top filters inside Issued Tab
        Padding(
          padding: EdgeInsets.all(16),
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
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.filter_list_outlined, color: AppColors.primary, size: 20),
              ),
            ],
          ),
        ),

        // Issued books list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _issuedRegistry.length,
            itemBuilder: (context, index) {
              final log = _issuedRegistry[index];
              final isOverdue = log['status'] == 'Overdue';

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade50,
                      blurRadius: 4,
                      offset: Offset(0, 1),
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E2875)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    SizedBox(height: 2),
                    Text(
                      "${log['rollNo']} | ${log['class']}",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Divider(height: 20),
                    Row(
                      children: [
                        Icon(Icons.book, size: 16, color: AppColors.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            log['book'],
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1E2875)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Issued Date".tr, style: TextStyle(fontSize: 9, color: Colors.grey)),
                            SizedBox(height: 2),
                            Text(log['issuedDate'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Due Date".tr, style: TextStyle(fontSize: 9, color: isOverdue ? Colors.red.shade300 : Colors.grey)),
                            SizedBox(height: 2),
                            Text(
                              log['dueDate'],
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isOverdue ? Colors.red : Color(0xFF1E2875),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isOverdue) ...[
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: Icon(Icons.notifications_active, color: Colors.white, size: 12),
                            label: Text("Send Reminder".tr, style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(subtext, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCategoryDistribution() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category Distribution".tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          SizedBox(height: 16),
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
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem("Science (35%)", Colors.blue),
                    SizedBox(height: 6),
                    _buildLegendItem("Maths (20%)", Colors.purple),
                    SizedBox(height: 6),
                    _buildLegendItem("Tech (25%)", Colors.teal),
                    SizedBox(height: 6),
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
        SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF757897))),
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
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
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
      physics: BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: EdgeInsets.only(right: 8.0),
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
                color: isSelected ? Colors.white : Color(0xFF757897),
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
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.book_outlined, color: AppColors.primary, size: 24),
          ),
          SizedBox(width: 12),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E2875)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                SizedBox(height: 2),
                Text(
                  "By ${book['author']}",
                  style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ISBN: ${book['isbn']}", style: TextStyle(fontSize: 9, color: Colors.grey.shade400)),
                    Text(book['shelf']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF757897))),
                  ],
                ),
                Divider(height: 14),
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 12, color: Colors.grey.shade400),
                    SizedBox(width: 4),
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

