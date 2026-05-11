import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

class NadaSobraApp extends StatelessWidget {
  const NadaSobraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NadaSobra',
      theme: AppTheme.theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
