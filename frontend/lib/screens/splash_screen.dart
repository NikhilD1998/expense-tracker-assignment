import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/helpers/transition_animation.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/dashboard_screen.dart';
import 'package:frontend/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for a short splash delay
    await Future.delayed(const Duration(seconds: 2));
    // Wait for autoLogin to complete
    await ref.read(authProvider.notifier).autoLogin();
    final authState = ref.read(authProvider);
    if (authState.token != null) {
      navigateWithFade(context, const DashboardScreen());
    } else {
      navigateWithFade(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceDimensions.init(context);
    return const Scaffold(
      body: Center(
        child: Text(
          'Welcome to\nExpense Tracker',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
