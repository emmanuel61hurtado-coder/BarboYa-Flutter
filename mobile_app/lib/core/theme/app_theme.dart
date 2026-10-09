import 'package:flutter/material.dart';

class AppTheme {
  // BarboYa Design System: Electric Lime & Sophisticated Dark Charcoal
  static const Color primaryLime = Color(0xFFC6F600);
  static const Color primaryLimeDark = Color(0xFFA3D000);
  static const Color darkCharcoal = Color(0xFF151914);
  static const Color surfaceDark = Color(0xFF1E231D);
  static const Color backgroundLight = Color(0xFFF4F6F0);
  static const Color surfaceLight = Colors.white;
  static const Color errorRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color accentBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFB8C00);
  static const Color textMuted = Color(0xFF6B7280);

  // Status Color Helper
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CREADO':
      case 'SOLICITADO':
      case 'PENDIENTE':
        return accentOrange;
      case 'ACEPTADO':
      case 'OFERTADO':
        return accentBlue;
      case 'PREPARANDO':
      case 'ASIGNADA':
        return const Color(0xFF8E24AA);
      case 'LISTO':
      case 'EN_CURSO':
      case 'EN_CAMINO':
      case 'RECOGIDO':
        return const Color(0xFF00897B);
      case 'ENTREGADO':
      case 'ENTREGADA':
      case 'FINALIZADO':
      case 'ACTIVO':
        return successGreen;
      case 'CANCELADO':
      case 'CANCELADA':
      case 'BLOQUEADO':
        return errorRed;
      default:
        return textMuted;
    }
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLime,
        primary: primaryLime,
        onPrimary: darkCharcoal,
        secondary: darkCharcoal,
        surface: surfaceLight,
        error: errorRed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceLight,
        foregroundColor: darkCharcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkCharcoal,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLime,
          foregroundColor: darkCharcoal,
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: darkCharcoal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
      ),
    );
  }
}
