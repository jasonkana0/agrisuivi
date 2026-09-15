import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/culture_provider.dart';
import '../providers/activite_provider.dart';
import '../widgets/activite_tile.dart';
import '../widgets/empty_state.dart';
import 'activite_form_screen.dart';
import 'culture_form_screen.dart';

class CultureDetailScreen extends StatefulWidget {
  final int cultureId;

  const CultureDetailScreen({super.key, required this.cultureId});

  @override
  State<CultureDetailScreen> createState() => _CultureDetailScreenState();
}

class _CultureDetailScreenState extends State<CultureDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiviteProvider>().chargerActivites(widget.cultureId);
    });
  }

  Future<void> _confirmerSuppressionCulture() async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette culture ?'),
        content: const Text('Le carnet d\'activités associé sera également supprimé.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirmer == true && mounted) {
      await context.read<CultureProvider>().supprimerCulture(widget.cultureId);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final culture = context.watch<CultureProvider>().parId(widget.cultureId);
    final activites = context.watch<ActiviteProvider>().activitesPour(widget.cultureId);

    if (culture == null) {
      return const Scaffold(body: Center(child: Text('Culture introuvable.')));
    }

    final dateFormatee = DateFormat('dd/MM/yyyy').format(culture.dateSemis);

    return Scaffold(
      appBar: AppBar(
        title: Text(culture.nom),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CultureFormScreen(cultureAModifier: culture)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmerSuppressionCulture,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Variété : ${culture.variete}', style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 4),
          Text('Parcelle : ${culture.parcelle}  |  Semé le : $dateFormatee',
              style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ActiviteFormScreen(cultureId: culture.id!)),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajouter une activité'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
          ),
          const SizedBox(height: 20),
          const Text("Carnet d'activités", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (activites.isEmpty)
            const EmptyState(icon: Icons.edit_note, message: "Aucune activité enregistrée pour cette culture.")
          else
            ...activites.map((a) => ActiviteTile(
                  activite: a,
                  onSupprimer: () => context.read<ActiviteProvider>().supprimerActivite(a.id!, culture.id!),
                )),
        ],
      ),
    );
  }
}
