import 'package:flutter/material.dart';
import 'presentation/pages/main_navigation_page.dart';

void main() {
  runApp(const ArcheryScorerApp());
}

class ArcheryScorerApp extends StatelessWidget {
  const ArcheryScorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archery scorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationPage(),
    );
  }
}