import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/profile_manager.dart';
import 'core/localization/language_manager.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProfileManager().init();
  runApp(const ERPApp());
}

class ERPApp extends StatelessWidget {
  const ERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: LanguageManager.instance,
      builder: (context, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: ProfileManager().themeMode,
          builder: (context, themeMode, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Ecstasy School ERP",
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: kIsWeb ? ThemeMode.light : themeMode,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
