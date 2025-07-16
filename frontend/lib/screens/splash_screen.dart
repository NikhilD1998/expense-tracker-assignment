import 'package:flutter/material.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/helpers/transition_animation.dart';
import 'dart:async';

import 'package:frontend/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      navigateWithFade(context, LoginScreen());
    });
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
