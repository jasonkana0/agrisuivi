/// Représente un conseil saisonnier. Contenu statique, chargé depuis
/// assets/conseils.json (voir ConseilsService), non modifiable par
/// l'utilisateur.
class Conseil {
  final String id;
  final String titre;
  final String categorie;
  final String saison;
  final String texte;

  Conseil({
    required this.id,
    required this.titre,
    required this.categorie,
    required this.saison,
    required this.texte,
  });

  factory Conseil.fromJson(Map<String, dynamic> json) {
    return Conseil(
      id: json['id'] as String,
      titre: json['titre'] as String,
      categorie: json['categorie'] as String,
      saison: json['saison'] as String,
      texte: json['texte'] as String,
    );
  }
}
