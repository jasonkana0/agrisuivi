import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class ReglagesScreen extends StatelessWidget {
  const ReglagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Réglages')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Réduit la consommation d\'écran'),
            value: themeProvider.estSombre,
            onChanged: (v) => context.read<ThemeProvider>().basculer(v),
          ),
          const Divider(),
          const ListTile(
            title: Text('À propos de AgriSuivi'),
            subtitle: Text(
              "Application de suivi de cultures fonctionnant hors ligne, "
              "destinée aux petits exploitants agricoles. Projet réalisé "
              "dans le cadre de la formation DClic (OIF) - Développement Mobile.",
            ),
          ),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
