import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activite.dart';

IconData _iconePourType(String type) {
  switch (type) {
    case TypeActivite.arrosage:
      return Icons.water_drop;
    case TypeActivite.fertilisation:
      return Icons.grass;
    case TypeActivite.traitement:
      return Icons.bug_report;
    case TypeActivite.recolte:
      return Icons.agriculture;
    default:
      return Icons.edit_note;
  }
}

class ActiviteTile extends StatelessWidget {
  final Activite activite;
  final VoidCallback? onSupprimer;

  const ActiviteTile({super.key, required this.activite, this.onSupprimer});

  @override
  Widget build(BuildContext context) {
    final dateFormatee = DateFormat('dd/MM/yyyy').format(activite.date);
    return ListTile(
      leading: Icon(_iconePourType(activite.type), color: Colors.brown),
      title: Text('${activite.type} — $dateFormatee'),
      subtitle: activite.note.isNotEmpty ? Text(activite.note) : null,
      trailing: onSupprimer != null
          ? IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: onSupprimer,
            )
          : null,
    );
  }
}
