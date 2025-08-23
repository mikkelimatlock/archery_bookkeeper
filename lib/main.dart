import 'package:flutter/material.dart';
import 'presentation/pages/main_navigation_page.dart';

void main() {
  runApp(const ArcheryBookkeeperApp());
}

class ArcheryBookkeeperApp extends StatelessWidget {
  const ArcheryBookkeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archery Bookkeeper',
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