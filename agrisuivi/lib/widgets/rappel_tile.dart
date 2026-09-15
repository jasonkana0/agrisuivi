import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activite.dart';
import '../utils/rappel_utils.dart';

class RappelTile extends StatelessWidget {
  final Activite activite;
  final String nomCulture;

  const RappelTile({super.key, required this.activite, required this.nomCulture});

  @override
  Widget build(BuildContext context) {
    final dateRappel = activite.dateRappel!;
    final statut = calculerStatutRappel(dateRappel, DateTime.now());

    Color couleur;
    String libelleStatut;
    switch (statut) {
      case StatutRappel.enRetard:
        couleur = Colors.red;
        libelleStatut = 'En retard';
        break;
      case StatutRappel.bientot:
        couleur = Colors.orange;
        libelleStatut = 'Bientôt';
        break;
      case StatutRappel.aVenir:
        couleur = Colors.green;
        libelleStatut = 'À venir';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: couleur.withOpacity(0.15),
          child: Icon(Icons.alarm, color: couleur),
        ),
        title: Text('${activite.type} — $nomCulture'),
        subtitle: Text('Prévu le ${DateFormat('dd/MM/yyyy').format(dateRappel)}'),
        trailing: Chip(
          label: Text(libelleStatut, style: const TextStyle(fontSize: 11, color: Colors.white)),
          backgroundColor: couleur,
        ),
      ),
    );
  }
}
