import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

/// Clase de utilidad para acceder fácilmente a las traducciones de la aplicación.
/// 
/// Esta clase proporciona una interfaz simplificada para acceder a las traducciones
/// a través del LanguageService. Implementa el patrón Factory Method para crear
/// instancias de manera conveniente y encapsula la lógica de acceso al servicio
/// de idiomas.
class AppLocalizations {
  /// Contexto de construcción de Flutter.
  /// 
  /// Se utiliza para acceder al LanguageService a través del Provider.
  final BuildContext context;
  
  /// Constructor de la clase AppLocalizations.
  /// 
  /// [context] - El contexto de construcción de Flutter necesario para acceder
  /// al LanguageService a través del Provider.
  AppLocalizations(this.context);
  
  /// Obtiene el texto traducido para una clave específica.
  /// 
  /// [key] - La clave de traducción a buscar.
  /// 
  /// Este método:
  /// 1. Obtiene una instancia del LanguageService usando Provider
  /// 2. Utiliza el servicio para traducir la clave proporcionada
  /// 3. Devuelve el texto traducido en el idioma actual
  /// 
  /// El parámetro `listen: true` asegura que el widget se reconstruya
  /// cuando cambie el idioma de la aplicación.
  String text(String key) {
    final languageService = Provider.of<LanguageService>(context, listen: true);
    return languageService.translate(key);
  }
  
  /// Factory method para obtener una instancia de AppLocalizations.
  /// 
  /// [context] - El contexto de construcción de Flutter.
  /// 
  /// Este método estático proporciona una forma conveniente de obtener
  /// una instancia de AppLocalizations sin necesidad de crear una nueva
  /// instancia manualmente. Es el método recomendado para acceder a las
  /// traducciones desde cualquier parte de la aplicación.
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final translations = AppLocalizations.of(context);
  /// final translatedText = translations.text('hello_world');
  /// ```
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(context);
  }
} 