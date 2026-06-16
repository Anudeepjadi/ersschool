import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
import 'tabs/home_tab.dart';
import 'tabs/my_info_tab.dart';
import 'tabs/class_tab.dart';
import 'tabs/fee_tab.dart';
import 'tabs/exams_tab.dart';
import 'tabs/more_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final List<Widget> _tabWidgets;

  @override
  void initState() {
    super.initState();
    _tabWidgets = [
      HomeTab(onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      const MyInfoTab(),
      const ClassTab(),
      const FeeTab(),
      const ExamsTab(),
      const MoreTab(),
    ];
  }

  // ── Per-tab AppBar titles ─────────────────────────────────────────────────
  static const List<_TabMeta> _tabsMeta = [
    _TabMeta('Ecstasy School ERP', ''),
    _TabMeta('My Information', 'View and manage your personal details'),
    _TabMeta('Class', 'Your class schedule & resources'),
    _TabMeta('Fee', 'Fee details & payment history'),
    _TabMeta('Exams', 'Upcoming exams & results'),
    _TabMeta('More', 'Settings & other options'),
  ];

  @override
  Widget build(BuildContext context) {
    final tabMeta = _tabsMeta[currentIndex];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
              accountName: Text(
                "Ananya Sharma",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text("ananya.sharma@school.com"),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: const Text("Home"),
              selected: currentIndex == 0,
              onTap: () {
                setState(() => currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("My Info"),
              selected: currentIndex == 1,
              onTap: () {
                setState(() => currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: const Text("Class"),
              selected: currentIndex == 2,
              onTap: () {
                setState(() => currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text("Fee"),
              selected: currentIndex == 3,
              onTap: () {
                setState(() => currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: const Text("Exams"),
              selected: currentIndex == 4,
              onTap: () {
                setState(() => currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tabMeta.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            if (tabMeta.subtitle.isNotEmpty)
              Text(
                tabMeta.subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No new notifications")),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '5',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile tapped")),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF1E2875),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "My Info"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Class"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: "Fee"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
      body: _tabWidgets[currentIndex],
    );
  }
}

// ── Tab metadata ──────────────────────────────────────────────────────────────
class _TabMeta {
  final String title;
  final String subtitle;
  const _TabMeta(this.title, this.subtitle);
}
