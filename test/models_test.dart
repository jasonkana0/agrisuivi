import 'package:flutter_test/flutter_test.dart';
import 'package:agrisuivi/models/culture.dart';
import 'package:agrisuivi/models/activite.dart';

void main() {
  group('Culture - toMap / fromMap', () {
    test('un aller-retour toMap/fromMap conserve toutes les valeurs', () {
      final culture = Culture(
        id: 1,
        nom: 'Maïs',
        variete: 'Maïs jaune local',
        parcelle: 'Nord',
        dateSemis: DateTime(2026, 6, 2),
        statut: 'En cours',
      );

      final map = culture.toMap();
      final recree = Culture.fromMap(map);

      expect(recree.id, culture.id);
      expect(recree.nom, culture.nom);
      expect(recree.variete, culture.variete);
      expect(recree.parcelle, culture.parcelle);
      expect(recree.dateSemis, culture.dateSemis);
      expect(recree.statut, culture.statut);
    });

    test('copyWith ne modifie que les champs indiqués', () {
      final culture = Culture(
        nom: 'Tomate',
        variete: 'Roma',
        parcelle: 'Sud',
        dateSemis: DateTime(2026, 7, 15),
      );

      final modifiee = culture.copyWith(statut: 'Récoltée');

      expect(modifiee.statut, 'Récoltée');
      expect(modifiee.nom, culture.nom);
      expect(modifiee.parcelle, culture.parcelle);
    });
  });

  group('Activite - toMap / fromMap', () {
    test('un aller-retour toMap/fromMap conserve toutes les valeurs, y compris le rappel', () {
      final activite = Activite(
        id: 5,
        cultureId: 1,
        type: TypeActivite.arrosage,
        date: DateTime(2026, 6, 12),
        note: 'Arrosage du matin',
        dateRappel: DateTime(2026, 6, 20),
      );

      final map = activite.toMap();
      final recree = Activite.fromMap(map);

      expect(recree.id, activite.id);
      expect(recree.cultureId, activite.cultureId);
      expect(recree.type, activite.type);
      expect(recree.date, activite.date);
      expect(recree.note, activite.note);
      expect(recree.dateRappel, activite.dateRappel);
    });

    test('dateRappel absente reste nulle après un aller-retour', () {
      final activite = Activite(
        cultureId: 2,
        type: TypeActivite.recolte,
        date: DateTime(2026, 8, 1),
      );

      final recree = Activite.fromMap(activite.toMap());

      expect(recree.dateRappel, isNull);
    });
  });
}
