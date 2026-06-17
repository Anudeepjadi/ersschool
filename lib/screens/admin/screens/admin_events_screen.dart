import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/admin_app_bar.dart';

class AdminEventsScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;

  const AdminEventsScreen({super.key, this.onOpenDrawer});

  @override
  State<AdminEventsScreen> createState() => _AdminEventsScreenState();
}

class _AdminEventsScreenState extends State<AdminEventsScreen> {
  String _selectedYear = '2026 - 27';
  String _selectedType = 'All Types';
  String _selectedMonth = 'Jun 2026';
  String _selectedStatus = 'All Status';
  String _searchQuery = '';
  String _activeTab = 'All';

  final List<Map<String, dynamic>> _allEvents = [
    {
      'name': 'Annual Sports Day',
      'type': 'Sports',
      'date': '20 Jun 2026',
      'time': '09:00 AM - 04:00 PM',
      'venue': 'Main Ground',
      'organizer': 'Sports Department',
      'status': 'Upcoming',
      'color': Colors.green,
    },
    {
      'name': 'Science Exhibition',
      'type': 'Academic',
      'date': '22 Jun 2026',
      'time': '10:00 AM - 01:00 PM',
      'venue': 'Science Block',
      'organizer': 'Science Department',
      'status': 'Upcoming',
      'color': Colors.blue,
    },
    {
      'name': 'Parents Teacher Meeting',
      'type': 'Meeting',
      'date': '25 Jun 2026',
      'time': '11:00 AM - 02:00 PM',
      'venue': 'Seminar Hall',
      'organizer': 'Admin Department',
      'status': 'Upcoming',
      'color': Colors.purple,
    },
    {
      'name': 'Investiture Ceremony',
      'type': 'Ceremony',
      'date': '28 Jun 2026',
      'time': '09:30 AM - 12:00 PM',
      'venue': 'Auditorium',
      'organizer': 'Admin Department',
      'status': 'Upcoming',
      'color': Colors.orange,
    },
    {
      'name': 'Art & Craft Competition',
      'type': 'Competition',
      'date': '15 Jun 2026',
      'time': '10:00 AM - 12:30 PM',
      'venue': 'Art Room',
      'organizer': 'Art Department',
      'status': 'Completed',
      'color': Colors.blue,
    },
    {
      'name': 'World Book Day',
      'type': 'Academic',
      'date': '10 Jun 2026',
      'time': '09:00 AM - 11:00 AM',
      'venue': 'Library',
      'organizer': 'Library Department',
      'status': 'Completed',
      'color': Colors.blue,
    },
    {
      'name': 'Health Checkup Camp',
      'type': 'Health',
      'date': '05 Jun 2026',
      'time': '09:00 AM - 01:00 PM',
      'venue': 'Medical Room',
      'organizer': 'Health Department',
      'status': 'Completed',
      'color': Colors.blue,
    },
    {
      'name': 'Music & Dance Fest',
      'type': 'Cultural',
      'date': '02 Jun 2026',
      'time': '03:00 PM - 06:00 PM',
      'venue': 'Auditorium',
      'organizer': 'Cultural Committee',
      'status': 'Cancelled',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AdminAppBar(
        title: "Events",
        subtitle: "Manage school events and activities",
        onOpenDrawer: widget.onOpenDrawer,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Dropdown Filters + Create Button
            _buildFiltersAndCreateSection(),
            const SizedBox(height: 16),

            // 2. Metric Stat Cards Row
            _buildMetricCardsRow(),
            const SizedBox(height: 16),

            // 3. Calendar & Upcoming split section
            _buildCalendarAndUpcomingSplit(),
            const SizedBox(height: 24),

            // 4. All Events List Section
            _buildAllEventsTableSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 1. Filters & Create Section
  Widget _buildFiltersAndCreateSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double childWidth = (constraints.maxWidth - 24) / 4;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallDropdown("Academic Year", _selectedYear, ['2026 - 27', '2025 - 26'], (v) => setState(() => _selectedYear = v!), childWidth),
                    _buildSmallDropdown("Event Type", _selectedType, ['All Types', 'Sports', 'Academic', 'Meeting', 'Ceremony'], (v) => setState(() => _selectedType = v!), childWidth),
                    _buildSmallDropdown("Month", _selectedMonth, ['Jun 2026', 'May 2026', 'Jul 2026'], (v) => setState(() => _selectedMonth = v!), childWidth),
                    _buildSmallDropdown("Status", _selectedStatus, ['All Status', 'Upcoming', 'Ongoing', 'Completed', 'Cancelled'], (v) => setState(() => _selectedStatus = v!), childWidth),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Create Event — Coming soon!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2875),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Create Event", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSmallDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              isExpanded: true,
              style: const TextStyle(fontSize: 10, color: Color(0xFF1E2875), fontWeight: FontWeight.bold),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item, overflow: TextOverflow.ellipsis));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Metrics Cards Row
  Widget _buildMetricCardsRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildMetricCard("Total Events", "24", "↑ 6 this month", Colors.purple),
          _buildMetricCard("Upcoming Events", "8", "↑ 3 this month", Colors.green),
          _buildMetricCard("Ongoing Events", "2", "No change", Colors.orange),
          _buildMetricCard("Completed Events", "13", "↑ 5 this month", Colors.blue),
          _buildMetricCard("Cancelled Events", "1", "↓ 1 this month", Colors.red),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String sub, Color color) {
    return Container(
      width: 125,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 3. Calendar & Upcoming Split Section
  Widget _buildCalendarAndUpcomingSplit() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Row layout for tablets/web
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildCalendarView()),
              const SizedBox(width: 16),
              Expanded(flex: 5, child: _buildUpcomingListPanel()),
            ],
          );
        } else {
          // Column layout for mobile
          return Column(
            children: [
              _buildCalendarView(),
              const SizedBox(height: 16),
              _buildUpcomingListPanel(),
            ],
          );
        }
      },
    );
  }

  Widget _buildCalendarView() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Events Calendar",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20, color: Colors.grey),
                    onPressed: () {},
                  ),
                  const Text("Jun 2026", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Weekdays header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) {
              return Expanded(
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Days grid representation
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 35, // 5 weeks simple grid
            itemBuilder: (context, index) {
              // Simulating June 2026 starts on Monday (1st day index 1)
              final int dayNo = index - 0; // June 1st is Monday
              if (dayNo < 1 || dayNo > 30) {
                return const SizedBox();
              }
              final isToday = dayNo == 20; // 20th highlight
              final hasEvent = dayNo == 20 || dayNo == 22 || dayNo == 25 || dayNo == 28 || dayNo == 15 || dayNo == 10 || dayNo == 5 || dayNo == 2;
              
              Color? dotColor;
              if (dayNo == 20 || dayNo == 22 || dayNo == 25 || dayNo == 28) {
                dotColor = Colors.green; // Upcoming
              } else if (dayNo == 2) {
                dotColor = Colors.red; // Cancelled
              } else {
                dotColor = Colors.blue; // Completed
              }

              return Container(
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFF1E2875) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday ? Border.all(color: const Color(0xFF1E2875)) : null,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$dayNo",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isToday 
                            ? Colors.white 
                            : (hasEvent ? const Color(0xFF1E2875) : Colors.grey.shade700),
                      ),
                    ),
                    if (hasEvent)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Legend indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendNode(Colors.green, "Upcoming"),
              _buildLegendNode(Colors.orange, "Ongoing"),
              _buildLegendNode(Colors.blue, "Completed"),
              _buildLegendNode(Colors.red, "Cancelled"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendNode(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildUpcomingListPanel() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upcoming Events",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
              ),
              Text(
                "View All",
                style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildUpcomingEventRow("20", "Jun", "Annual Sports Day", "09:00 AM - 04:00 PM", "Main Ground", "Sports", Colors.green),
          const Divider(height: 16),
          _buildUpcomingEventRow("22", "Jun", "Science Exhibition", "10:00 AM - 01:00 PM", "Science Block", "Academic", Colors.blue),
          const Divider(height: 16),
          _buildUpcomingEventRow("25", "Jun", "Parents Teacher Meeting", "11:00 AM - 02:00 PM", "Seminar Hall", "Meeting", Colors.purple),
          const Divider(height: 16),
          _buildUpcomingEventRow("28", "Jun", "Investiture Ceremony", "09:30 AM - 12:00 PM", "Auditorium", "Ceremony", Colors.orange),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "View All Upcoming Events >",
              style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventRow(String day, String month, String title, String time, String venue, String tag, Color tagColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date block
        Container(
          width: 44,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(day, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              Text(month, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 10, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on_outlined, size: 10, color: Colors.grey),
                  const SizedBox(width: 2),
                  Text(venue, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        // Tag chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: tagColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tag,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: tagColor),
          ),
        ),
      ],
    );
  }

  // 4. All Events Table Section
  Widget _buildAllEventsTableSection() {
    // Filter events based on active tab and search
    final filtered = _allEvents.where((e) {
      final matchesSearch = e['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      if (_activeTab == 'All') return matchesSearch;
      return matchesSearch && e['status'] == _activeTab;
    }).toList();

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
            "All Events",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)),
          ),
          const SizedBox(height: 12),
          // Search & controls row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: const InputDecoration(
                      hintText: "Search events by name...",
                      hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                      prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildIconButton(Icons.filter_list, "Filter"),
              const SizedBox(width: 8),
              _buildIconButton(Icons.file_download_outlined, "Export"),
            ],
          ),
          const SizedBox(height: 14),
          // Tab bar indicators
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabChip("All", 24),
                _buildTabChip("Upcoming", 8),
                _buildTabChip("Ongoing", 2),
                _buildTabChip("Completed", 13),
                _buildTabChip("Cancelled", 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Scrollable Table Grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20,
              headingRowHeight: 40,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 48,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
              columns: const [
                DataColumn(label: Text("Event Name", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Type", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Date & Time", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Venue", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Organized By", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Status", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
                DataColumn(label: Text("Action", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875)))),
              ],
              rows: filtered.map((e) {
                final isUpcoming = e['status'] == 'Upcoming';
                final isCompleted = e['status'] == 'Completed';
                final isCancelled = e['status'] == 'Cancelled';
                
                Color statusColor = Colors.orange;
                if (isUpcoming) {
                  statusColor = Colors.green;
                } else if (isCompleted) {
                  statusColor = Colors.blue;
                } else if (isCancelled) {
                  statusColor = Colors.red;
                }

                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.event_note_outlined, size: 14, color: statusColor),
                          const SizedBox(width: 6),
                          Text(e['name'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                        ],
                      ),
                    ),
                    DataCell(Text(e['type'], style: const TextStyle(fontSize: 11, color: Color(0xFF757897)))),
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e['date'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                          Text(e['time'], style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                    ),
                    DataCell(Text(e['venue'], style: const TextStyle(fontSize: 11, color: Color(0xFF757897)))),
                    DataCell(Text(e['organizer'], style: const TextStyle(fontSize: 11, color: Color(0xFF757897)))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          e['status'],
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: statusColor),
                        ),
                      ),
                    ),
                    DataCell(IconButton(icon: const Icon(Icons.more_vert, size: 16), onPressed: () {})),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Pagination row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Showing 1 to ${filtered.length} of ${filtered.length} entries",
                style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              Row(
                children: [
                  _buildPageButton("<"),
                  _buildPageButton("1", active: true),
                  _buildPageButton("2"),
                  _buildPageButton("3"),
                  _buildPageButton(">"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFF1E2875), size: 18),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$label clicked"))),
      ),
    );
  }

  Widget _buildTabChip(String label, int count) {
    final isSelected = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E2875) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF1E2875) : Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade600),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$count",
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFF1E2875)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageButton(String text, {bool active = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1E2875) : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: active ? const Color(0xFF1E2875) : Colors.grey.shade200),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.grey),
      ),
    );
  }
}
