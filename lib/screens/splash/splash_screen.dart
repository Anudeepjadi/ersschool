import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:flutter/services.dart';
>>>>>>> Stashed changes
import 'package:video_player/video_player.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
<<<<<<< Updated upstream
  late VideoPlayerController _videoController;
  bool _videoInitialized = false;
  bool _hasNavigated = false;
=======
  VideoPlayerController? _videoController;
  bool _videoReady = false;
  Timer? _safetyTimer;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();

<<<<<<< Updated upstream
    _videoController = VideoPlayerController.asset(
      'assets/animations/ecstasy_splash.mp4',
    );

    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _videoController.initialize();
      if (!mounted) return;

      setState(() => _videoInitialized = true);

      await _videoController.setVolume(0.0);
      await _videoController.play();

      _videoController.addListener(_onVideoProgress);
    } catch (e) {
      debugPrint('Video init failed: $e');
      if (mounted) {
        Future.delayed(const Duration(seconds: 3), () => _navigateToLogin());
      }
=======
    // Hide system UI for a truly full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/animations/ers_animation.mp4',
      );

      await _videoController!.initialize();

      if (!mounted) return;

      setState(() => _videoReady = true);

      _videoController!.addListener(_onVideoProgress);
      _videoController!.play();

      // Safety fallback in case the video listener doesn't fire
      _safetyTimer = Timer(const Duration(seconds: 10), _navigateToLogin);
    } catch (_) {
      // Video failed — go straight to login
      if (mounted) _navigateToLogin();
>>>>>>> Stashed changes
    }
  }

  void _onVideoProgress() {
<<<<<<< Updated upstream
    if (_hasNavigated) return;

    final position = _videoController.value.position;
    final duration = _videoController.value.duration;

    if (duration > Duration.zero &&
        position >= duration - const Duration(milliseconds: 100)) {
=======
    final ctrl = _videoController;
    if (ctrl == null) return;
    final pos = ctrl.value.position;
    final dur = ctrl.value.duration;
    if (dur.inMilliseconds > 0 &&
        pos >= dur - const Duration(milliseconds: 200)) {
>>>>>>> Stashed changes
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
<<<<<<< Updated upstream
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
=======
    _safetyTimer?.cancel();
    _videoController?.removeListener(_onVideoProgress);
    if (!mounted) return;

    // Restore normal system UI before leaving splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
>>>>>>> Stashed changes
  }

  @override
  void dispose() {
<<<<<<< Updated upstream
    _videoController.removeListener(_onVideoProgress);
    _videoController.dispose();
=======
    _safetyTimer?.cancel();
    _videoController?.removeListener(_onVideoProgress);
    _videoController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
>>>>>>> Stashed changes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
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
=======
      backgroundColor: Colors.black,
      body: _videoReady
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          : const SizedBox.shrink(), // pure black while loading
>>>>>>> Stashed changes
    );
  }
}
