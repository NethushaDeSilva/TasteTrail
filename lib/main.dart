import 'package:flutter/material.dart';

import 'models/app_user.dart';
import 'ui/auth/login_screen.dart';
import 'ui/main_screen.dart';
import 'services/auth_service.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RestaurantReviewApp());
}

class RestaurantReviewApp extends StatelessWidget {
  const RestaurantReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colombo Eats',
      debugShowCheckedModeBanner: false,

      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,

      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: AuthService.authChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == null) {
          return const LoginScreen();
        }

        return const MainScreen();
      },
    );
  }
}
