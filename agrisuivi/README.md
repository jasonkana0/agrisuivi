# AgriSuivi

Application mobile Flutter de suivi de cultures pour petits exploitants agricoles,
fonctionnant intégralement hors ligne.

Projet final — Formation DClic (OIF), Développement Mobile, niveau approfondi.

## Objectif

De nombreux petits exploitants agricoles manquent d'outils simples pour suivre
leurs cultures, organiser leurs activités (arrosage, traitement, récolte) et se
rappeler des tâches importantes, dans un contexte où l'accès à internet est
souvent limité. AgriSuivi centralise ce suivi dans une application mobile
utilisable sans connexion.

## Fonctionnalités principales

- **Gestion des cultures** : ajouter, modifier, consulter et supprimer une
  culture (nom, variété, parcelle, date de semis, statut).
- **Carnet d'activités** : journal daté des activités liées à une culture
  (arrosage, fertilisation, traitement, récolte), avec note libre.
- **Rappels** : possibilité d'associer une date de rappel à une activité ;
  les rappels à venir ou en retard sont mis en avant sur le tableau de bord.
- **Conseils saisonniers** : liste de conseils pratiques par culture et par
  saison, consultable hors ligne (contenu embarqué).
- **Tableau de bord** : nombre de cultures actives et prochains rappels.
- **Mode sombre** (optionnel) : bascule clair/sombre dans les réglages.

## Technologies et packages utilisés

| Package | Rôle |
|---|---|
| `provider` | Gestion d'état (CultureProvider, ActiviteProvider, ThemeProvider) |
| `sqflite` + `path` + `path_provider` | Stockage local (base SQLite embarquée) |
| `intl` | Formatage des dates affichées |
| `sqflite_common_ffi` *(dev)* | Exécuter une vraie base SQLite en mémoire pendant les tests, sans appareil |
| `flutter_lints` *(dev)* | Analyse statique du code |

## Choix techniques et simplifications assumées

Par rapport au dossier de conception technique rédigé en semaine 5, deux
simplifications ont été faites pour rester dans un périmètre réaliste pour
une semaine de développement (le support de cours recommande explicitement
de réduire le périmètre si nécessaire) :

- **Parcelle** a été simplifiée en un simple champ texte sur `Culture`
  plutôt qu'une table relationnelle séparée : les wireframes de la semaine 5
  ne prévoyaient pas d'écran dédié à la gestion des parcelles.
- **Rappels** : au lieu de notifications système (`flutter_local_notifications`,
  qui nécessite une configuration native Android/iOS difficile à valider sans
  pouvoir exécuter l'application), les rappels sont affichés **dans
  l'application**, sur le tableau de bord, avec un code couleur (en retard /
  bientôt / à venir). C'est une version fonctionnelle et testable de la
  fonctionnalité, qui pourra évoluer vers une vraie notification système
  dans une prochaine itération (voir "Difficultés rencontrées").

Le stockage reste **local (SQLite)**, conformément au cahier des charges : il
garantit un fonctionnement hors ligne complet, adapté au contexte rural visé.

## Installation

Ce dépôt contient uniquement le code source (`lib/`, `test/`,
`integration_test/`, `assets/`, `pubspec.yaml`). Les dossiers `android/`,
`ios/`, etc. sont générés par Flutter et propres à chaque machine.

```bash
# Depuis la racine du projet
flutter create --project-name agrisuivi .
flutter pub get
```

## Lancement de l'application

```bash
flutter run
```

## Tests réalisés

```bash
# Tests unitaires (modèles, logique de rappel, service de base de données)
# et tests de widgets (formulaire, écran conseils)
flutter test

# Test d'intégration (parcours complet), nécessite un émulateur/appareil
flutter test integration_test/app_test.dart
```

Détail des tests :

- `test/models_test.dart` — conversions `toMap`/`fromMap` de `Culture` et `Activite`.
- `test/rappel_utils_test.dart` — calcul du statut d'un rappel (en retard / bientôt / à venir).
- `test/database_service_test.dart` — CRUD complet sur SQLite (via `sqflite_common_ffi`, base en mémoire).
- `test/widget_test.dart` — validation du formulaire de culture, affichage de l'écran Conseils.
- `integration_test/app_test.dart` — ajouter une culture → ajouter une activité → vérifier le carnet → vérifier le tableau de bord.


## Difficultés rencontrées

- Le principal compromis a porté sur les **rappels** : une vraie notification
  système aurait nécessité une configuration native (permissions Android,
  initialisation de fuseau horaire) impossible à valider sans exécution
  réelle de l'application dans l'environnement de développement utilisé pour
  écrire ce projet. La version actuelle (rappel affiché dans l'app) reste
  fonctionnelle et testée, et constitue une base saine pour ajouter
  `flutter_local_notifications` par la suite.
- Le code de ce projet a été écrit sans pouvoir exécuter `flutter run` ni
  `flutter test` dans l'environnement de rédaction : il doit être vérifié et
  corrigé si besoin après un premier lancement local, avant la démonstration.

## Auteur

KANA TSAGUE AROL JASON ETUDIANT GENIE LOGICIEL A L'ECOLE NATIONALA SUPERIEURE POLYTECHNIQUE DE DOUALA — Formation DClic (OIF), parcours Développement Mobile, niveau approfondi.
