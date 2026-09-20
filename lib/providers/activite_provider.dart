import 'package:flutter/foundation.dart';

import '../models/activite.dart';
import '../services/database_service.dart';

/// Gère le carnet d'activités : celles d'une culture précise, et la liste
/// globale des rappels utilisée par le tableau de bord.
class ActiviteProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  final Map<int, List<Activite>> _activitesParCulture = {};
  List<Activite> _rappels = [];

  List<Activite> activitesPour(int cultureId) =>
      List.unmodifiable(_activitesParCulture[cultureId] ?? const []);

  List<Activite> get rappels => List.unmodifiable(_rappels);

  Future<void> chargerActivites(int cultureId) async {
    _activitesParCulture[cultureId] =
        await _db.listerActivitesPourCulture(cultureId);
    notifyListeners();
  }

  Future<void> chargerRappels() async {
    _rappels = await _db.listerActivitesAvecRappel();
    notifyListeners();
  }

  Future<void> ajouterActivite(Activite activite) async {
    await _db.insererActivite(activite);
    await chargerActivites(activite.cultureId);
    await chargerRappels();
  }

  Future<void> supprimerActivite(int id, int cultureId) async {
    await _db.supprimerActivite(id);
    await chargerActivites(cultureId);
    await chargerRappels();
  }
}
