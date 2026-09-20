import 'package:flutter/material.dart';

import 'accueil_screen.dart';
import 'cultures_list_screen.dart';
import 'conseils_screen.dart';
import 'reglages_screen.dart';

/// Conteneur des 4 sections principales de l'application, conformément au
/// layout général défini dans le dossier de conception visuelle
/// (AppBar + BottomNavigationBar).
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _indexActif = 0;

  final List<Widget> _ecrans = const [
    AccueilScreen(),
    CulturesListScreen(),
    ConseilsScreen(),
    ReglagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indexActif, children: _ecrans),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexActif,
        onDestinationSelected: (index) => setState(() => _indexActif = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.eco_outlined), selectedIcon: Icon(Icons.eco), label: 'Cultures'),
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), selectedIcon: Icon(Icons.lightbulb), label: 'Conseils'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Réglages'),
        ],
      ),
    );
  }
}
