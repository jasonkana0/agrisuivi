/// Statut d'un rappel par rapport à la date du jour.
enum StatutRappel { enRetard, bientot, aVenir }

/// Détermine le statut d'un rappel en comparant sa date à la date actuelle.
///
/// Cette fonction est volontairement pure (aucune dépendance à
/// BuildContext, à la base de données ou à l'heure système autre que celle
/// passée en paramètre) afin d'être facilement testable unitairement,
/// suivant le même principe que calculerMoyenneClasse() dans l'activité 5.
///
/// - [StatutRappel.enRetard] si la date de rappel est strictement passée.
/// - [StatutRappel.bientot] si la date de rappel tombe dans les 2 prochains
///   jours (inclus).
/// - [StatutRappel.aVenir] sinon.
StatutRappel calculerStatutRappel(DateTime dateRappel, DateTime maintenant) {
  final debutAujourdhui = DateTime(maintenant.year, maintenant.month, maintenant.day);
  final debutRappel = DateTime(dateRappel.year, dateRappel.month, dateRappel.day);
  final difference = debutRappel.difference(debutAujourdhui).inDays;

  if (difference < 0) {
    return StatutRappel.enRetard;
  } else if (difference <= 2) {
    return StatutRappel.bientot;
  } else {
    return StatutRappel.aVenir;
  }
}
