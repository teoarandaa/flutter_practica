import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proveedor de tema que gestiona el estado del tema de la aplicación.
/// 
/// Esta clase implementa el patrón ChangeNotifier para notificar a los widgets
/// cuando cambia el tema de la aplicación. Gestiona tres modos de tema:
/// - Claro (light)
/// - Oscuro (dark)
/// - Sistema (system)
/// 
/// El tema seleccionado se persiste usando SharedPreferences para mantener
/// la preferencia del usuario entre sesiones.
class ThemeProvider with ChangeNotifier {
  /// Modo de tema actual de la aplicación.
  /// 
  /// Por defecto se establece en ThemeMode.system, lo que significa que
  /// la aplicación seguirá el tema del sistema operativo.
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Obtiene el modo de tema actual.
  /// 
  /// Devuelve el ThemeMode actual que está siendo utilizado por la aplicación.
  ThemeMode get themeMode => _themeMode;
  
  /// Constructor del proveedor de tema.
  /// 
  /// Inicializa el proveedor y carga el tema guardado en las preferencias.
  ThemeProvider() {
    _loadThemeFromPrefs();
  }
  
  /// Carga el tema guardado en las preferencias.
  /// 
  /// Este método privado se llama durante la inicialización del proveedor
  /// para cargar el tema guardado previamente. Si no hay un tema guardado
  /// o ocurre un error, se utiliza el tema del sistema por defecto.
  void _loadThemeFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String themeModeString = prefs.getString('theme_mode') ?? 'system';
      
      switch (themeModeString) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
      
      notifyListeners();
    } catch (e) {
      // Si hay un error, mantenemos el tema predeterminado
    }
  }
  
  /// Establece el modo de tema de la aplicación.
  /// 
  /// [mode] - El nuevo modo de tema a establecer (light, dark o system).
  /// 
  /// Este método:
  /// 1. Actualiza el modo de tema actual
  /// 2. Notifica a los oyentes del cambio
  /// 3. Persiste la preferencia en SharedPreferences
  /// 
  /// Si ocurre un error al guardar la preferencia, el cambio se mantiene
  /// en memoria pero no se persiste.
  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String themeModeString;
      
      switch (mode) {
        case ThemeMode.light:
          themeModeString = 'light';
          break;
        case ThemeMode.dark:
          themeModeString = 'dark';
          break;
        default:
          themeModeString = 'system';
      }
      
      await prefs.setString('theme_mode', themeModeString);
    } catch (e) {
      // Si hay un error, seguimos con el tema en memoria
    }
  }
} 