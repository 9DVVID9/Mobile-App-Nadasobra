import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  final VoidCallback? onGoToFridge;
  const HomeScreen({super.key, this.onGoToFridge});
  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Center(child: Text('Home — coming soon')));
}
