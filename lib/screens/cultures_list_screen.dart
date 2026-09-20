import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/culture_provider.dart';
import '../widgets/culture_card.dart';
import '../widgets/empty_state.dart';
import 'culture_detail_screen.dart';
import 'culture_form_screen.dart';

class CulturesListScreen extends StatefulWidget {
  const CulturesListScreen({super.key});

  @override
  State<CulturesListScreen> createState() => _CulturesListScreenState();
}

class _CulturesListScreenState extends State<CulturesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CultureProvider>().chargerCultures();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CultureProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes cultures')),
      body: provider.enChargement
          ? const Center(child: CircularProgressIndicator())
          : provider.cultures.isEmpty
              ? const EmptyState(
                  icon: Icons.eco_outlined,
                  message: "Aucune culture enregistrée pour l'instant.\n"
                      "Appuyez sur + pour en ajouter une.",
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.cultures.length,
                  itemBuilder: (context, index) {
                    final culture = provider.cultures[index];
                    return CultureCard(
                      culture: culture,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CultureDetailScreen(cultureId: culture.id!),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CultureFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
