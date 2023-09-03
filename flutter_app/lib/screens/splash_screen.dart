import 'package:flutter/material.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/services/auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  Future<void> initAsync() async {
    try {
      final isAuth = await AuthService.isAuthAvailable();
      if (isAuth) {
        final user = await AuthService.getUser();
        if (user != null) {
          navigateToHome();
        } else {
          navigateToLogin();
        }
      } else {
        navigateToLogin();
      }
    } catch (e) {
      navigateToLogin();
    }
  }

  void navigateToHome() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => const HomeScreen()),
    );
  }

  void navigateToLogin() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
