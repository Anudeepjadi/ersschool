import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset(
      'assets/animations/ers_animation.mp4',
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      if (!mounted) return;

      setState(() => _videoInitialized = true);

      await _videoController.setVolume(0.0);
      await _videoController.setPlaybackSpeed(3.0);
      await _videoController.play();

      _videoController.addListener(_onVideoProgress);
    } catch (e) {
      debugPrint('Video init failed: $e');
      if (mounted) {
        Future.delayed(const Duration(seconds: 3), () => _navigateToLogin());
      }
    }
  }

  void _onVideoProgress() {
    if (_hasNavigated) return;

    final position = _videoController.value.position;
    final duration = _videoController.value.duration;

    if (duration > Duration.zero &&
        position >= duration - const Duration(milliseconds: 100)) {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: animation,
            child: const LoginScreen(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoProgress);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _videoInitialized
            ? SizedBox(
                width: 220,
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
