import 'package:flutter/material.dart';

import '../models/conseil.dart';
import '../services/conseils_service.dart';
import '../widgets/conseil_card.dart';
import '../widgets/empty_state.dart';

class ConseilsScreen extends StatefulWidget {
  const ConseilsScreen({super.key});

  @override
  State<ConseilsScreen> createState() => _ConseilsScreenState();
}

class _ConseilsScreenState extends State<ConseilsScreen> {
  final ConseilsService _service = ConseilsService();
  late Future<List<Conseil>> _futureConseils;

  @override
  void initState() {
    super.initState();
    _futureConseils = _service.chargerConseils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conseils saisonniers')),
      body: FutureBuilder<List<Conseil>>(
        future: _futureConseils,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return EmptyState(
              icon: Icons.error_outline,
              message: 'Impossible de charger les conseils.\n${snapshot.error}',
            );
          }
          final conseils = snapshot.data ?? [];
          if (conseils.isEmpty) {
            return const EmptyState(icon: Icons.lightbulb_outline, message: 'Aucun conseil disponible.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conseils.length,
            itemBuilder: (context, index) => ConseilCard(conseil: conseils[index]),
          );
        },
      ),
    );
  }
}
