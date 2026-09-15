/// Représente une culture suivie par l'utilisateur.
///
/// Simplification assumée par rapport au dossier de conception technique :
/// la "parcelle" est ici un simple champ texte (nom de la parcelle) plutôt
/// qu'une table relationnelle séparée. Les wireframes de la semaine 5 ne
/// prévoyaient pas d'écran dédié à la gestion des parcelles ; cette
/// simplification permet de rester dans un périmètre réaliste pour la
/// semaine 6, conformément à la recommandation du support de cours.
class Culture {
  final int? id;
  final String nom;
  final String variete;
  final String parcelle;
  final DateTime dateSemis;
  final String statut; // ex : "En cours", "Récoltée"

  Culture({
    this.id,
    required this.nom,
    required this.variete,
    required this.parcelle,
    required this.dateSemis,
    this.statut = 'En cours',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'variete': variete,
      'parcelle': parcelle,
      'date_semis': dateSemis.toIso8601String(),
      'statut': statut,
    };
  }

  factory Culture.fromMap(Map<String, dynamic> map) {
    return Culture(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      variete: map['variete'] as String,
      parcelle: map['parcelle'] as String,
      dateSemis: DateTime.parse(map['date_semis'] as String),
      statut: map['statut'] as String,
    );
  }

  Culture copyWith({
    int? id,
    String? nom,
    String? variete,
    String? parcelle,
    DateTime? dateSemis,
    String? statut,
  }) {
    return Culture(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      variete: variete ?? this.variete,
      parcelle: parcelle ?? this.parcelle,
      dateSemis: dateSemis ?? this.dateSemis,
      statut: statut ?? this.statut,
    );
  }
}
