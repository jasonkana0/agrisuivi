import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:agrisuivi/services/database_service.dart';
import 'package:agrisuivi/models/culture.dart';
import 'package:agrisuivi/models/activite.dart';

void main() {
  // sqflite dépend normalement d'un plugin de plateforme (Android/iOS).
  // sqflite_common_ffi permet d'exécuter une vraie base SQLite en mémoire
  // dans l'environnement de test (Dart VM), sans appareil ni émulateur.
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseService service;

  setUp(() async {
    // Base en mémoire, réinitialisée à chaque test pour l'isolation.
    databaseFactory = databaseFactoryFfi;
    service = DatabaseService.instance;
  });

  tearDown(() async {
    // DatabaseService est un singleton qui garde sa connexion ouverte pour
    // toute la durée des tests : on nettoie donc les tables entre chaque
    // test plutôt que de fermer la connexion, afin de garder les tests
    // indépendants sans invalider la connexion mise en cache.
    final db = await service.database;
    await db.delete('activites');
    await db.delete('cultures');
  });

  group('CRUD Culture', () {
    test('insérer puis lister une culture', () async {
      final id = await service.insererCulture(Culture(
        nom: 'Maïs',
        variete: 'Jaune local',
        parcelle: 'Nord',
        dateSemis: DateTime(2026, 6, 2),
      ));

      expect(id, greaterThan(0));

      final cultures = await service.listerCultures();
      expect(cultures.length, 1);
      expect(cultures.first.nom, 'Maïs');
    });

    test('modifier une culture existante', () async {
      final id = await service.insererCulture(Culture(
        nom: 'Tomate',
        variete: 'Roma',
        parcelle: 'Sud',
        dateSemis: DateTime(2026, 7, 15),
      ));

      final cultures = await service.listerCultures();
      final culture = cultures.first;
      await service.modifierCulture(culture.copyWith(statut: 'Récoltée'));

      final apres = await service.listerCultures();
      expect(apres.first.statut, 'Récoltée');
      expect(apres.first.id, id);
    });

    test('supprimer une culture la retire de la liste', () async {
      final id = await service.insererCulture(Culture(
        nom: 'Haricot',
        variete: 'Vert nain',
        parcelle: 'Est',
        dateSemis: DateTime(2026, 8, 20),
      ));

      await service.supprimerCulture(id);

      final cultures = await service.listerCultures();
      expect(cultures.where((c) => c.id == id), isEmpty);
    });
  });

  group('CRUD Activite', () {
    test('insérer une activité et la retrouver pour sa culture', () async {
      final cultureId = await service.insererCulture(Culture(
        nom: 'Maïs',
        variete: 'Jaune local',
        parcelle: 'Nord',
        dateSemis: DateTime(2026, 6, 2),
      ));

      await service.insererActivite(Activite(
        cultureId: cultureId,
        type: TypeActivite.arrosage,
        date: DateTime(2026, 6, 12),
      ));

      final activites = await service.listerActivitesPourCulture(cultureId);
      expect(activites.length, 1);
      expect(activites.first.type, TypeActivite.arrosage);
    });

    test('une activité avec rappel apparaît dans listerActivitesAvecRappel', () async {
      final cultureId = await service.insererCulture(Culture(
        nom: 'Tomate',
        variete: 'Roma',
        parcelle: 'Sud',
        dateSemis: DateTime(2026, 7, 15),
      ));

      await service.insererActivite(Activite(
        cultureId: cultureId,
        type: TypeActivite.traitement,
        date: DateTime(2026, 7, 20),
        dateRappel: DateTime(2026, 7, 25),
      ));
      await service.insererActivite(Activite(
        cultureId: cultureId,
        type: TypeActivite.arrosage,
        date: DateTime(2026, 7, 21),
        // pas de rappel
      ));

      final rappels = await service.listerActivitesAvecRappel();
      expect(rappels.length, 1);
      expect(rappels.first.type, TypeActivite.traitement);
    });
  });
}
