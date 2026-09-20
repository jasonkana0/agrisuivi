import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/culture_provider.dart';
import 'providers/activite_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/root_screen.dart';

void main() {
  runApp(const AgriSuiviApp());
}

class AgriSuiviApp extends StatelessWidget {
  const AgriSuiviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CultureProvider()),
        ChangeNotifierProvider(create: (_) => ActiviteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'AgriSuivi',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              colorSchemeSeed: Colors.green,
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.green,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            home: const RootScreen(),
          );
        },
      ),
    );
  }
}
