import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kSeedColour = Color(0xFF00695C); // teal

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColour,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColour,
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
);
