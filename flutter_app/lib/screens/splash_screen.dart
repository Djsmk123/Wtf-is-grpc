import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/login.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/grpc_services.dart';
import 'package:flutter_app/services/notification.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      updateAddress();
    });
    //initAsync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void updateAddress() {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Add server address"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: GrpcService.host,
                  decoration: const InputDecoration(
                    labelText: "Enter Server Address",
                  ),
                  onChanged: (value) {
                    GrpcService.host = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: GrpcService.port.toString(),
                  decoration: const InputDecoration(
                    labelText: "Enter port",
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && int.tryParse(value) != null) {
                      GrpcService.port = int.parse(value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Next"),
              ),
              ElevatedButton(
                onPressed: () {
                  GrpcService.updateChannel();
                  Navigator.of(context).pop();
                },
                child: const Text("Update"),
              ),
            ],
          );
        }).then((value) {
      initAsync();
    });
  }

  Future<void> initAsync() async {
    try {
      await NotificationServices.initializeService();
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
      log(e.toString());
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
