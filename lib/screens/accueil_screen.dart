import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/culture_provider.dart';
import '../providers/activite_provider.dart';
import '../widgets/rappel_tile.dart';
import '../widgets/empty_state.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  @override
  void initState() {
    super.initState();
    // Chargement initial des données au premier affichage de l'écran.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CultureProvider>().chargerCultures();
      context.read<ActiviteProvider>().chargerRappels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cultureProvider = context.watch<CultureProvider>();
    final activiteProvider = context.watch<ActiviteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('AgriSuivi')),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CultureProvider>().chargerCultures();
          await context.read<ActiviteProvider>().chargerRappels();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Bonjour, Producteur !',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.eco, color: Colors.green, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      '${cultureProvider.nombreCulturesActives} culture(s) active(s)',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Prochaines activités',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (activiteProvider.rappels.isEmpty)
              const EmptyState(
                icon: Icons.alarm_off,
                message: "Aucun rappel programmé pour l'instant.\n"
                    "Ajoutez-en un depuis le détail d'une culture.",
              )
            else
              ...activiteProvider.rappels.map((activite) {
                final culture = cultureProvider.parId(activite.cultureId);
                return RappelTile(
                  activite: activite,
                  nomCulture: culture?.nom ?? 'Culture supprimée',
                );
              }),
          ],
        ),
      ),
    );
  }
}
