import 'package:flutter/material.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/helpers/transition_animation.dart';
import 'package:frontend/screens/add_expense_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DeviceDimensions.init(context);
    return Scaffold(
      body: const Center(
        child: Text(
          'Dashboard',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: SizedBox(
        width: DeviceDimensions.width * 0.15,
        height: DeviceDimensions.width * 0.15,
        child: FloatingActionButton(
          onPressed: () {
            navigateWithFade(context, AddExpenseScreen());
          },
          backgroundColor: const Color(0xFF29756F),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
