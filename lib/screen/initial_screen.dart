import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/screen/daily_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth(authController);
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkAuth(AuthController authController) async {
    await Future.delayed(const Duration(seconds: 1));
    final isLoggedIn = await authController.checkAuth();

    if (isLoggedIn) {
      final bool mostrarResumen = DateTime.now().hour < 12;

      if (mostrarResumen) {
        Get.offAll(() => const DailySummaryScreen());
      } else {
        Get.offAllNamed('/medications');
      }
    } else {
      Get.offAllNamed('/login');
    }
  }
}
