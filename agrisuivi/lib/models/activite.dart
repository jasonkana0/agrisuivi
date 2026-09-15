/// Types d'activités possibles dans le carnet.
class TypeActivite {
  static const arrosage = 'Arrosage';
  static const fertilisation = 'Fertilisation';
  static const traitement = 'Traitement';
  static const recolte = 'Récolte';
  static const autre = 'Autre';

  static const List<String> valeurs = [
    arrosage,
    fertilisation,
    traitement,
    recolte,
    autre,
  ];
}

/// Représente une action du carnet d'activités, liée à une culture.
///
/// Le champ [dateRappel] porte la fonctionnalité "rappel" du cahier des
/// charges : s'il est renseigné et proche (ou dépassé), l'activité apparaît
/// mise en avant sur le tableau de bord. Il ne s'agit pas d'une notification
/// système (voir README), mais d'un rappel affiché dans l'application.
class Activite {
  final int? id;
  final int cultureId;
  final String type;
  final DateTime date;
  final String note;
  final DateTime? dateRappel;

  Activite({
    this.id,
    required this.cultureId,
    required this.type,
    required this.date,
    this.note = '',
    this.dateRappel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'culture_id': cultureId,
      'type': type,
      'date': date.toIso8601String(),
      'note': note,
      'date_rappel': dateRappel?.toIso8601String(),
    };
  }

  factory Activite.fromMap(Map<String, dynamic> map) {
    return Activite(
      id: map['id'] as int?,
      cultureId: map['culture_id'] as int,
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
      note: (map['note'] as String?) ?? '',
      dateRappel: map['date_rappel'] != null
          ? DateTime.parse(map['date_rappel'] as String)
          : null,
    );
  }
}
