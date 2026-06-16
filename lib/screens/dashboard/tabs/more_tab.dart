import 'package:flutter/material.dart';
import '../../calendar/calendar_screen.dart';
import '../../transport/transport_screen.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate the center of the 6th bottom navigation bar item (More)
    double lineX = screenWidth - (screenWidth / 12);
    double cardWidth = 180; // Reduced card width for a compact look
    double cardLeft = lineX - 16 - cardWidth; // Compact cards right-aligned to the branch line

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: 156 + kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Branch line painter
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 156,
                child: CustomPaint(
                  painter: MoreBranchPainter(lineX: lineX),
                ),
              ),
              // 2. Transport Card (Reduced height to 44)
              Positioned(
                top: 0,
                left: cardLeft,
                width: cardWidth,
                height: 44,
                child: _buildMoreTile(
                  context,
                  Icons.directions_bus_filled_outlined,
                  "Transport",
                  () {
                    Navigator.pop(context); // Close bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransportScreen()),
                    );
                  },
                ),
              ),
              // 3. Calendar Card (Reduced height to 44, adjusted top spacing)
              Positioned(
                top: 72,
                left: cardLeft,
                width: cardWidth,
                height: 44,
                child: _buildMoreTile(
                  context,
                  Icons.calendar_month_outlined,
                  "Calendar",
                  () {
                    Navigator.pop(context); // Close bottom sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CalendarScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreTile(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color color = const Color(0xFF1E2875)}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        leading: Icon(icon, color: color, size: 18), // Reduced icon size
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 12, // Reduced letter sizes
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12), // Reduced arrow size
        onTap: onTap,
      ),
    );
  }
}

class MoreBranchPainter extends CustomPainter {
  final double lineX;
  const MoreBranchPainter({required this.lineX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2875)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Vertical stem starts at the bottom edge (which is positioned right above the bottom nav bar)
    double startY = size.height;
    
    // Goes up to the center of Transport card (y = 22)
    path.moveTo(lineX, startY);
    path.lineTo(lineX, 22);
    
    // Branch 1 (Transport) horizontal line to the left
    path.moveTo(lineX, 22);
    path.lineTo(lineX - 16, 22);
    
    // Branch 2 (Calendar) horizontal line to the left
    path.moveTo(lineX, 94);
    path.lineTo(lineX - 16, 94);
    
    canvas.drawPath(path, paint);

    // Left-pointing arrow heads
    final arrowPaint = Paint()
      ..color = const Color(0xFF1E2875)
      ..style = PaintingStyle.fill;

    _drawLeftArrow(canvas, lineX - 16, 22, arrowPaint);
    _drawLeftArrow(canvas, lineX - 16, 94, arrowPaint);
  }

  void _drawLeftArrow(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    path.moveTo(x, y);
    path.lineTo(x + 8, y - 5);
    path.lineTo(x + 8, y + 5);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MoreBranchPainter oldDelegate) {
    return oldDelegate.lineX != lineX;
  }
}
