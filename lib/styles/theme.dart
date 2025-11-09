import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ColorScheme kColorSchemeEscuro = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 136, 88, 224),

//  brightness: Brightness.dark,
);

final TextTheme kTextThemeEscuro = GoogleFonts.lexendTextTheme(
  // Pegamos o tema de texto escuro padrão do Flutter (que tem cores claras)
  // e aplicamos a fonte "Lexend" a ele.
  // ThemeData(brightness: Brightness.dark).textTheme,
);

final ThemeData theme = ThemeData(
  // brightness: Brightness.dark,
  colorScheme: kColorSchemeEscuro,
  textTheme: kTextThemeEscuro,
  scaffoldBackgroundColor: kColorSchemeEscuro.surface,

  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: kColorSchemeEscuro.surface,
    foregroundColor: kColorSchemeEscuro.onSurface,
  ),

  cardTheme: CardThemeData(
    elevation: 2.0,
    color: kColorSchemeEscuro.surfaceContainerHighest,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kColorSchemeEscuro.primary,
      foregroundColor: kColorSchemeEscuro.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: kColorSchemeEscuro.surfaceContainerHighest.withValues(alpha: 0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: kColorSchemeEscuro.primary),
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: kColorSchemeEscuro.primary,
    foregroundColor: kColorSchemeEscuro.onPrimary,
    elevation: 4.0,
  ),
);