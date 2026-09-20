import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/culture.dart';

class CultureCard extends StatelessWidget {
  final Culture culture;
  final VoidCallback onTap;

  const CultureCard({super.key, required this.culture, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateFormatee = DateFormat('dd/MM/yyyy').format(culture.dateSemis);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.eco, color: Colors.green),
        ),
        title: Text(culture.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${culture.parcelle} — semé le $dateFormatee'),
        trailing: Chip(
          label: Text(culture.statut, style: const TextStyle(fontSize: 12)),
          backgroundColor: culture.statut == 'Récoltée'
              ? Colors.grey.shade300
              : Colors.green.shade100,
        ),
        onTap: onTap,
      ),
    );
  }
}
