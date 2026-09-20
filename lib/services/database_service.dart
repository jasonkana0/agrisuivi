import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/culture.dart';
import '../models/activite.dart';

/// Isole tous les accès à la base de données locale (SQLite via sqflite).
///
/// Ce choix de stockage local est justifié dans le cahier des charges par
/// le besoin d'un fonctionnement complet hors ligne (zones rurales à
/// connectivité limitée) et par la sobriété (pas d'appels réseau).
class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agrisuivi.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cultures(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            variete TEXT NOT NULL,
            parcelle TEXT NOT NULL,
            date_semis TEXT NOT NULL,
            statut TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE activites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            culture_id INTEGER NOT NULL,
            type TEXT NOT NULL,
            date TEXT NOT NULL,
            note TEXT,
            date_rappel TEXT,
            FOREIGN KEY (culture_id) REFERENCES cultures (id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // ---------- CULTURES ----------

  Future<int> insererCulture(Culture culture) async {
    final db = await database;
    return db.insert('cultures', culture.toMap()..remove('id'));
  }

  Future<List<Culture>> listerCultures() async {
    final db = await database;
    final maps = await db.query('cultures', orderBy: 'date_semis DESC');
    return maps.map((m) => Culture.fromMap(m)).toList();
  }

  Future<int> modifierCulture(Culture culture) async {
    final db = await database;
    return db.update(
      'cultures',
      culture.toMap(),
      where: 'id = ?',
      whereArgs: [culture.id],
    );
  }

  Future<int> supprimerCulture(int id) async {
    final db = await database;
    // Les activités liées sont supprimées grâce à ON DELETE CASCADE.
    return db.delete('cultures', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- ACTIVITÉS ----------

  Future<int> insererActivite(Activite activite) async {
    final db = await database;
    return db.insert('activites', activite.toMap()..remove('id'));
  }

  Future<List<Activite>> listerActivitesPourCulture(int cultureId) async {
    final db = await database;
    final maps = await db.query(
      'activites',
      where: 'culture_id = ?',
      whereArgs: [cultureId],
      orderBy: 'date DESC',
    );
    return maps.map((m) => Activite.fromMap(m)).toList();
  }

  /// Toutes les activités qui portent un rappel, toutes cultures confondues,
  /// triées par date de rappel croissante (utile pour le tableau de bord).
  Future<List<Activite>> listerActivitesAvecRappel() async {
    final db = await database;
    final maps = await db.query(
      'activites',
      where: 'date_rappel IS NOT NULL',
      orderBy: 'date_rappel ASC',
    );
    return maps.map((m) => Activite.fromMap(m)).toList();
  }

  Future<int> supprimerActivite(int id) async {
    final db = await database;
    return db.delete('activites', where: 'id = ?', whereArgs: [id]);
  }
}
