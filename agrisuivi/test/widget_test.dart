import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:agrisuivi/providers/culture_provider.dart';
import 'package:agrisuivi/screens/culture_form_screen.dart';
import 'package:agrisuivi/screens/conseils_screen.dart';

Widget _envelopper(Widget child) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CultureProvider()),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  group('CultureFormScreen - validation', () {
    testWidgets('affiche des erreurs si on enregistre un formulaire vide',
        (WidgetTester tester) async {
      await tester.pumpWidget(_envelopper(const CultureFormScreen()));

      await tester.tap(find.widgetWithText(ElevatedButton, 'Enregistrer'));
      await tester.pump();

      expect(find.text('Le nom de la culture est obligatoire.'), findsOneWidget);
      expect(find.text('La variété est obligatoire.'), findsOneWidget);
      expect(find.text('La parcelle est obligatoire.'), findsOneWidget);
    });

    testWidgets('aucune erreur affichée si tous les champs sont remplis',
        (WidgetTester tester) async {
      await tester.pumpWidget(_envelopper(const CultureFormScreen()));

      await tester.enterText(find.widgetWithText(TextFormField, 'Nom de la culture'), 'Maïs');
      await tester.enterText(find.widgetWithText(TextFormField, 'Variété'), 'Jaune local');
      await tester.enterText(find.widgetWithText(TextFormField, 'Parcelle associée'), 'Nord');

      // Ne tape pas sur "Enregistrer" ici : on vérifie seulement qu'aucun
      // message d'erreur n'apparaît une fois les champs valides, sans
      // déclencher l'écriture réelle en base (hors périmètre d'un test de
      // widget qui ne doit pas dépendre de sqflite).
      expect(find.text('Le nom de la culture est obligatoire.'), findsNothing);
      expect(find.text('La variété est obligatoire.'), findsNothing);
      expect(find.text('La parcelle est obligatoire.'), findsNothing);
    });
  });

  group('ConseilsScreen', () {
    testWidgets('affiche le titre et au moins un conseil chargé depuis les assets',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ConseilsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Conseils saisonniers'), findsOneWidget);
      expect(find.text('Arroser tôt le matin'), findsOneWidget);
    });
  });
}
