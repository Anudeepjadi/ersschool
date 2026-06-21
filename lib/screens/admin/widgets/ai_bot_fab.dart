import 'package:flutter/material.dart';
import '../screens/admin_chat_support_screen.dart';

class AiBotFab extends StatefulWidget {
  const AiBotFab({super.key});

  @override
  State<AiBotFab> createState() => _AiBotFabState();
}

class _AiBotFabState extends State<AiBotFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_animation.value),
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 6, right: 2),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(4), // Pointing to the FAB
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "Hi, Need any help?",
              style: TextStyle(
                color: Color(0xFF0038FF),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          mini: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminChatSupportScreen(openBotChat: true)));
          },
          backgroundColor: Colors.white,
          child: const Icon(Icons.smart_toy, color: Color(0xFF0038FF), size: 22),
        ),
        ],
      ),
    );
  }
}
