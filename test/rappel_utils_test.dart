import 'package:flutter_test/flutter_test.dart';
import 'package:agrisuivi/utils/rappel_utils.dart';

void main() {
  group('calculerStatutRappel', () {
    final maintenant = DateTime(2026, 6, 15);

    test('une date passée est en retard', () {
      final resultat = calculerStatutRappel(DateTime(2026, 6, 10), maintenant);
      expect(resultat, StatutRappel.enRetard);
    });

    test('aujourd\'hui est considéré "bientôt"', () {
      final resultat = calculerStatutRappel(DateTime(2026, 6, 15), maintenant);
      expect(resultat, StatutRappel.bientot);
    });

    test('dans 2 jours est encore "bientôt"', () {
      final resultat = calculerStatutRappel(DateTime(2026, 6, 17), maintenant);
      expect(resultat, StatutRappel.bientot);
    });

    test('dans 3 jours ou plus est "à venir"', () {
      final resultat = calculerStatutRappel(DateTime(2026, 6, 18), maintenant);
      expect(resultat, StatutRappel.aVenir);
    });

    test('une date lointaine est "à venir"', () {
      final resultat = calculerStatutRappel(DateTime(2026, 9, 1), maintenant);
      expect(resultat, StatutRappel.aVenir);
    });
  });
}
