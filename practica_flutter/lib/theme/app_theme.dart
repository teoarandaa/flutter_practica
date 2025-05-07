import 'package:flutter/material.dart';

/// Clase que define los temas de la aplicación.
/// 
/// Esta clase contiene las definiciones de los temas claro y oscuro de la aplicación,
/// utilizando Material Design 3. Cada tema define un conjunto de estilos y colores
/// que se aplican consistentemente en toda la aplicación.
class AppTheme {
  /// Tema claro de la aplicación.
  /// 
  /// Define los estilos y colores para el modo claro de la aplicación:
  /// - Utiliza Material Design 3
  /// - Esquema de colores basado en azul como color semilla
  /// - Barra de aplicación centrada y sin elevación
  /// - Botones elevados con texto blanco y fondo azul
  /// - Botón flotante de acción con fondo azul y texto blanco
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );

  /// Tema oscuro de la aplicación.
  /// 
  /// Define los estilos y colores para el modo oscuro de la aplicación:
  /// - Utiliza Material Design 3
  /// - Esquema de colores basado en azul como color semilla
  /// - Barra de aplicación centrada y sin elevación
  /// - Botones elevados con texto blanco y fondo azul
  /// - Botón flotante de acción con fondo azul y texto blanco
  /// 
  /// Nota: Aunque los colores son los mismos que en el tema claro, el esquema
  /// de colores se ajusta automáticamente para el modo oscuro.
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    ),
  );
} 