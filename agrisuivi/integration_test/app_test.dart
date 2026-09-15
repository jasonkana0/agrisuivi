import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:agrisuivi/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Parcours complet AgriSuivi', () {
    testWidgets(
        'ajouter une culture, ajouter une activité, la retrouver dans le carnet',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AgriSuiviApp());
      await tester.pumpAndSettle();

      // Étape 1 : aller sur l'onglet Cultures.
      await tester.tap(find.text('Cultures'));
      await tester.pumpAndSettle();
      expect(find.text('Mes cultures'), findsOneWidget);

      // Étape 2 : ajouter une nouvelle culture.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Nouvelle culture'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextFormField, 'Nom de la culture'), 'Test Maïs');
      await tester.enterText(find.widgetWithText(TextFormField, 'Variété'), 'Jaune local');
      await tester.enterText(find.widgetWithText(TextFormField, 'Parcelle associée'), 'Nord');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Enregistrer'));
      await tester.pumpAndSettle();

      // Étape 3 : la culture apparaît dans la liste.
      expect(find.text('Test Maïs'), findsOneWidget);

      // Étape 4 : ouvrir son détail.
      await tester.tap(find.text('Test Maïs'));
      await tester.pumpAndSettle();
      expect(find.text("Carnet d'activités"), findsOneWidget);

      // Étape 5 : ajouter une activité.
      await tester.tap(find.widgetWithText(ElevatedButton, 'Ajouter une activité'));
      await tester.pumpAndSettle();
      expect(find.text('Nouvelle activité'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Enregistrer'));
      await tester.pumpAndSettle();

      // Étape 6 : l'activité apparaît dans le carnet (type par défaut : Arrosage).
      expect(find.text("Carnet d'activités"), findsOneWidget);
      expect(find.textContaining('Arrosage'), findsWidgets);

      // Étape 7 : retour à l'accueil, le compteur de cultures actives est à jour.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Accueil'));
      await tester.pumpAndSettle();
      expect(find.textContaining('culture(s) active(s)'), findsOneWidget);
    });
  });
}
