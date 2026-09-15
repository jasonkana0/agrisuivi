import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/conseil.dart';

/// Charge la liste des conseils saisonniers depuis assets/conseils.json.
///
/// Le contenu est statique et embarqué dans l'application : aucune
/// connexion réseau n'est nécessaire pour le consulter, ce qui répond à
/// l'exigence d'accès hors ligne du cahier des charges.
class ConseilsService {
  Future<List<Conseil>> chargerConseils() async {
    final contenu = await rootBundle.loadString('assets/conseils.json');
    final liste = json.decode(contenu) as List<dynamic>;
    return liste
        .map((item) => Conseil.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
