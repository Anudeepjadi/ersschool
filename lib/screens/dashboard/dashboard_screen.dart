import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';
<<<<<<< Updated upstream
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
      ClassTab(onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      const FeeTab(),
      const ExamsTab(),
      const MoreTab(),
    ];
  }

  // ── Per-tab AppBar titles ─────────────────────────────────────────────────
  static const List<_TabMeta> _tabs = [
    _TabMeta('Ecstasy School ERP', ''),
    _TabMeta('My Information', 'View and manage your personal details'),
    _TabMeta('Class', 'Your class schedule & resources'),
    _TabMeta('Fee', 'Fee details & payment history'),
    _TabMeta('Exams', 'Upcoming exams & results'),
    _TabMeta('More', 'Settings & other options'),
  ];

  // ── Tab bodies ────────────────────────────────────────────────────────────
  Widget _buildBody() {
    switch (currentIndex) {
      case 1:
        return const MyInfoScreen();
      case 2:
        return _ComingSoon(icon: Icons.menu_book, label: 'Class');
      case 3:
        return _ComingSoon(icon: Icons.currency_rupee, label: 'Fee');
      case 4:
        return _ComingSoon(icon: Icons.assignment_outlined, label: 'Exams');
      case 5:
        return _ComingSoon(icon: Icons.more_horiz, label: 'More');
      default:
        return _buildHomeBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[currentIndex];

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
<<<<<<< Updated upstream
=======
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tab.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            if (tab.subtitle.isNotEmpty)
              Text(
                tab.subtitle,
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
>>>>>>> Stashed changes
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.primary.withValues(alpha: 0.7),
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
<<<<<<< Updated upstream
      body: _tabs[currentIndex],
=======
      body: _buildBody(),
    );
  }

  // ── Home tab body ────────────────────────────────────────────────────────────
  Widget _buildHomeBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Here is your school overview for today",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: const [
                StatCard(title: "Students", value: "1,250", icon: Icons.school, color: AppColors.primary),
                StatCard(title: "Teachers", value: "85", icon: Icons.people, color: Colors.teal),
                StatCard(title: "Attendance", value: "96%", icon: Icons.fact_check, color: Colors.orange),
                StatCard(title: "Fees Collected", value: "₹8.5L", icon: Icons.currency_rupee, color: Colors.purple),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                QuickActionCard(title: "Attendance", icon: Icons.check_circle, onTap: () {}),
                QuickActionCard(title: "Fees", icon: Icons.payment, onTap: () {}),
                QuickActionCard(title: "Exams", icon: Icons.quiz, onTap: () {}),
                QuickActionCard(title: "Events", icon: Icons.event, onTap: () {}),
                QuickActionCard(title: "Certificates", icon: Icons.workspace_premium, onTap: () {}),
                QuickActionCard(title: "Help Desk", icon: Icons.help, onTap: () {}),
              ],
            ),
            const SizedBox(height: 25),

            const Text(
              "Announcements",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.campaign, color: Colors.white),
                ),
                title: Text("School Reopens on June 15", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("All students must report before 9:00 AM."),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.event, color: Colors.white),
                ),
                title: Text("Annual Day Celebration", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Event scheduled for August 10, 2026"),
              ),
            ),
          ],
        ),
      ),
>>>>>>> Stashed changes
    );
  }
}

// ── Tab metadata ──────────────────────────────────────────────────────────────
class _TabMeta {
  final String title;
  final String subtitle;
  const _TabMeta(this.title, this.subtitle);
}

// ── Coming-soon placeholder ───────────────────────────────────────────────────
class _ComingSoon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ComingSoon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            '$label – Coming Soon',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
