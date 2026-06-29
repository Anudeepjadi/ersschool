import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/admin_bottom_nav_bar.dart';
import 'package:ersschool/core/localization/language_manager.dart';

class AdminAboutUsScreen extends StatefulWidget {
  const AdminAboutUsScreen({super.key});

  @override
  State<AdminAboutUsScreen> createState() => _AdminAboutUsScreenState();
}

class _AdminAboutUsScreenState extends State<AdminAboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "About Us",
        subtitle: "Know more about our mission, vision and values",
      ),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 4),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFF9FAFB),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              SizedBox(height: 32),
              _buildStatsRow(),
              SizedBox(height: 32),
              _buildMissionVisionRow(),
              SizedBox(height: 32),
              _buildCoreValues(),
              SizedBox(height: 32),
              _buildLeadership(),
              SizedBox(height: 32),
              _buildHistory(),
              SizedBox(height: 32),
              _buildGetInTouch(),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---
  Widget _buildHero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Empowering Education,\nInspiring Futures".tr,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2875), height: 1.3),
        ),
        SizedBox(height: 16),
        Text("At Ecstasy School, we are committed to providing quality education through innovation, technology and a student-first approach.".tr,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
        ),
        SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?q=80&w=600&auto=format&fit=crop',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.school, "5,200+", "Students", Color(0xFF0038FF))),
            SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.person, "320+", "Teachers", Color(0xFF10B981))),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.domain, "15+", "Years", Color(0xFFF59E0B))),
            SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.emoji_events, "45+", "Awards", Color(0xFFEC4899))),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        SizedBox(height: 12),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMissionVisionRow() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.track_changes, color: Color(0xFF0038FF), size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Our Mission".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  SizedBox(height: 8),
                  Text("To deliver a world-class education that nurtures curiosity, builds character and empowers every student to achieve their full potential.".tr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.remove_red_eye, color: Color(0xFF0038FF), size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Our Vision".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  SizedBox(height: 8),
                  Text("To be a global leader in education, recognized for academic excellence, innovation and the holistic development of students.".tr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoreValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Our Core Values".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: Text("Learn More".tr, style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.person, "Integrity", "We act with honesty, transparency and strong ethics.", Color(0xFF0038FF))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.diamond, "Excellence", "We strive for the highest standards in everything we do.", Color(0xFF10B981))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.lightbulb, "Innovation", "We embrace new ideas and technology.", Color(0xFFF59E0B))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.group, "Collaboration", "We believe in the power of teamwork.", Color(0xFF8B5CF6))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.favorite, "Empathy", "We care for our students and staff.", Color(0xFFEC4899))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoreValueItem(IconData icon, String title, String desc, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildLeadership() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Leadership Team".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: Text("View All".tr, style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 160, child: _buildLeaderProfile("Mr. Rajesh Sharma", "Principal", "20+ years of experience in education leadership.")),
              SizedBox(width: 160, child: _buildLeaderProfile("Ms. Anita Verma", "Vice Principal", "Expert in academic planning.")),
              SizedBox(width: 160, child: _buildLeaderProfile("Mr. Vikram Singh", "Head of Academics", "Passionate about curriculum innovation.")),
              SizedBox(width: 160, child: _buildLeaderProfile("Ms. Neha Gupta", "Head of Operations", "Specialist in operations.")),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderProfile(String name, String role, String desc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          SizedBox(height: 4),
          Text(role, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
          SizedBox(height: 8),
          Text("in".tr, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0077B5))),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Our History".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: Text("Read More".tr, style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: [
            _buildTimelineItem("2009", "Foundation", "Ecstasy School was established with a vision to transform education.", true),
            _buildTimelineItem("2013", "Growth", "Expanded infrastructure and introduced innovative learning programs.", false),
            _buildTimelineItem("2018", "Innovation", "Launched digital learning initiatives and smart classrooms.", false),
            _buildTimelineItem("2024", "Excellence", "Continuing our journey of excellence and impacting more lives.", false),
          ],
        ),
        SizedBox(height: 24),
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("“".tr, style: TextStyle(fontSize: 60, color: Color(0xFF0038FF), height: 0.8)),
              Text("Education is the most powerful weapon which you can use to change the world.".tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875), height: 1.5),
              ),
              SizedBox(height: 16),
              Text("— Nelson Mandela".tr, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String year, String title, String desc, bool isFirst) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(Icons.business, color: isFirst ? Color(0xFF0038FF) : Colors.transparent, size: 24),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF0038FF), width: 2),
                color: isFirst ? Color(0xFF0038FF) : Colors.white,
              ),
            ),
            if (year != "2024") Container(width: 2, height: 60, color: Colors.grey.shade300),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(year, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  SizedBox(width: 16),
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 6),
              Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
              SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGetInTouch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Get in Touch".tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        SizedBox(height: 8),
        Text("We're here to help you with any questions or information you need.", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        SizedBox(height: 20),
        Column(
          children: [
            _buildContactItem(Icons.phone, "+91 98765 43210", "Mon - Sat, 9 AM - 6 PM"),
            SizedBox(height: 16),
            _buildContactItem(Icons.email, "info@ecstasyschool.edu", "We reply within 24 hours"),
            SizedBox(height: 16),
            _buildContactItem(Icons.location_on, "123 Education Street,", "New Delhi, India - 110001"),
          ],
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF0038FF).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Color(0xFF0038FF), size: 20),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}
