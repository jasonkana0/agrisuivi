import 'package:flutter/foundation.dart';

import '../models/culture.dart';
import '../services/database_service.dart';

/// Expose la liste des cultures à l'interface et centralise les opérations
/// CRUD. Les écrans écoutent ce provider (via Consumer/context.watch) et se
/// reconstruisent automatiquement lorsque notifyListeners() est appelé.
class CultureProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instance;

  List<Culture> _cultures = [];
  bool _enChargement = false;

  List<Culture> get cultures => List.unmodifiable(_cultures);
  bool get enChargement => _enChargement;
  int get nombreCulturesActives =>
      _cultures.where((c) => c.statut == 'En cours').length;

  Future<void> chargerCultures() async {
    _enChargement = true;
    notifyListeners();
    _cultures = await _db.listerCultures();
    _enChargement = false;
    notifyListeners();
  }

  Future<void> ajouterCulture(Culture culture) async {
    await _db.insererCulture(culture);
    await chargerCultures();
  }

  Future<void> modifierCulture(Culture culture) async {
    await _db.modifierCulture(culture);
    await chargerCultures();
  }

  Future<void> supprimerCulture(int id) async {
    await _db.supprimerCulture(id);
    await chargerCultures();
  }

  Culture? parId(int id) {
    try {
      return _cultures.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
