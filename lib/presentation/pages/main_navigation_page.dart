import 'package:flutter/material.dart';
import '../../config/localization/generated/app_localizations.dart';
import 'scoring_page.dart';
import 'settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  
  // Persistent scoring state
  int _arrowsPerEnd = 3;
  int _endsPerSet = 12;
  List<List<String>> _scores = [];
  
  @override
  void initState() {
    super.initState();
    _initializeScores();
  }
  
  void _initializeScores() {
    _scores = List.generate(
      _endsPerSet,
      (index) => List.generate(_arrowsPerEnd, (index) => ''),
    );
  }
  
  void _onArrowsPerEndChanged(int arrows) {
    setState(() {
      _arrowsPerEnd = arrows;
      _endsPerSet = arrows == 3 ? 10 : 6;
      // Note: The actual score preservation dialog logic will be handled by ScoringPage
      // This is just to keep the navigation-level state in sync
    });
  }
  
  void _onScoresUpdated(List<List<String>> newScores) {
    setState(() {
      _scores = newScores;
    });
  }
  
  List<Widget> get _pages => [
    ScoringPage(
      initialArrowsPerEnd: _arrowsPerEnd,
      initialEndsPerSet: _endsPerSet,
      initialScores: _scores,
      onArrowsPerEndChanged: _onArrowsPerEndChanged,
      onScoresUpdated: _onScoresUpdated,
    ),
    const SettingsPage(),
  ];

  List<String> _getPageTitles(BuildContext context) => [
    AppLocalizations.of(context)!.navMainScorer,
    AppLocalizations.of(context)!.navSettings,
  ];

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pageTitles = _getPageTitles(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appVersion,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sports),
              title: Text(l10n.navMainScorer),
              selected: _selectedIndex == 0,
              onTap: () => _onNavigationItemSelected(0),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.navSettings),
              selected: _selectedIndex == 1,
              onTap: () => _onNavigationItemSelected(1),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.devTodoLocalization,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}