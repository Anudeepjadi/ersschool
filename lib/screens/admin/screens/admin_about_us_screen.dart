import 'package:flutter/material.dart';
import '../widgets/admin_app_bar.dart';

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
      appBar: const AdminAppBar(
        title: "About Us",
        subtitle: "Know more about our mission, vision and values",
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF9FAFB),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHero(),
              const SizedBox(height: 32),
              _buildStatsRow(),
              const SizedBox(height: 32),
              _buildMissionVisionRow(),
              const SizedBox(height: 32),
              _buildCoreValues(),
              const SizedBox(height: 32),
              _buildLeadership(),
              const SizedBox(height: 32),
              _buildHistory(),
              const SizedBox(height: 32),
              _buildGetInTouch(),
              const SizedBox(height: 32),
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
        const Text(
          "Empowering Education,\nInspiring Futures",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E2875), height: 1.3),
        ),
        const SizedBox(height: 16),
        Text(
          "At Ecstasy School, we are committed to providing quality education through innovation, technology and a student-first approach.",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
        ),
        const SizedBox(height: 24),
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
            Expanded(child: _buildStatItem(Icons.school, "5,200+", "Students", const Color(0xFF0038FF))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.person, "320+", "Teachers", const Color(0xFF10B981))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.domain, "15+", "Years", const Color(0xFFF59E0B))),
            const SizedBox(width: 16),
            Expanded(child: _buildStatItem(Icons.emoji_events, "45+", "Awards", const Color(0xFFEC4899))),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 12),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        const SizedBox(height: 4),
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
            const Icon(Icons.track_changes, color: Color(0xFF0038FF), size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Our Mission", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  const SizedBox(height: 8),
                  Text("To deliver a world-class education that nurtures curiosity, builds character and empowers every student to achieve their full potential.", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.remove_red_eye, color: Color(0xFF0038FF), size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Our Vision", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  const SizedBox(height: 8),
                  Text("To be a global leader in education, recognized for academic excellence, innovation and the holistic development of students.", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
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
            const Text("Our Core Values", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: const Text("Learn More", style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.person, "Integrity", "We act with honesty, transparency and strong ethics.", const Color(0xFF0038FF))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.diamond, "Excellence", "We strive for the highest standards in everything we do.", const Color(0xFF10B981))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.lightbulb, "Innovation", "We embrace new ideas and technology.", const Color(0xFFF59E0B))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.group, "Collaboration", "We believe in the power of teamwork.", const Color(0xFF8B5CF6))),
              SizedBox(width: 140, child: _buildCoreValueItem(Icons.favorite, "Empathy", "We care for our students and staff.", const Color(0xFFEC4899))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoreValueItem(IconData icon, String title, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 8),
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
            const Text("Leadership Team", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 160, child: _buildLeaderProfile("Mr. Rajesh Sharma", "Principal", "20+ years of experience in education leadership.", 'https://randomuser.me/api/portraits/men/32.jpg')),
              SizedBox(width: 160, child: _buildLeaderProfile("Ms. Anita Verma", "Vice Principal", "Expert in academic planning.", 'https://randomuser.me/api/portraits/women/44.jpg')),
              SizedBox(width: 160, child: _buildLeaderProfile("Mr. Vikram Singh", "Head of Academics", "Passionate about curriculum innovation.", 'https://randomuser.me/api/portraits/men/46.jpg')),
              SizedBox(width: 160, child: _buildLeaderProfile("Ms. Neha Gupta", "Head of Operations", "Specialist in operations.", 'https://randomuser.me/api/portraits/women/65.jpg')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderProfile(String name, String role, String desc, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(height: 12),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
          const SizedBox(height: 4),
          Text(role, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
          const SizedBox(height: 8),
          const Text("in", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0077B5))),
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
            const Text("Our History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
            TextButton(onPressed: () {}, child: const Text("Read More", style: TextStyle(fontSize: 12, color: Color(0xFF0038FF), fontWeight: FontWeight.bold))),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            _buildTimelineItem("2009", "Foundation", "Ecstasy School was established with a vision to transform education.", true),
            _buildTimelineItem("2013", "Growth", "Expanded infrastructure and introduced innovative learning programs.", false),
            _buildTimelineItem("2018", "Innovation", "Launched digital learning initiatives and smart classrooms.", false),
            _buildTimelineItem("2024", "Excellence", "Continuing our journey of excellence and impacting more lives.", false),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("“", style: TextStyle(fontSize: 60, color: Color(0xFF0038FF), height: 0.8)),
              const Text(
                "Education is the most powerful weapon which you can use to change the world.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875), height: 1.5),
              ),
              const SizedBox(height: 16),
              Text("— Nelson Mandela", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
            Icon(Icons.business, color: isFirst ? const Color(0xFF0038FF) : Colors.transparent, size: 24),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0038FF), width: 2),
                color: isFirst ? const Color(0xFF0038FF) : Colors.white,
              ),
            ),
            if (year != "2024") Container(width: 2, height: 60, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(year, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
                  const SizedBox(width: 16),
                  Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Text(desc, style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4)),
              const SizedBox(height: 24),
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
        const Text("Get in Touch", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
        const SizedBox(height: 8),
        Text("We're here to help you with any questions or information you need.", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 20),
        Column(
          children: [
            _buildContactItem(Icons.phone, "+91 98765 43210", "Mon - Sat, 9 AM - 6 PM"),
            const SizedBox(height: 16),
            _buildContactItem(Icons.email, "info@ecstasyschool.edu", "We reply within 24 hours"),
            const SizedBox(height: 16),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0038FF).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0038FF), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E2875))),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }
}
