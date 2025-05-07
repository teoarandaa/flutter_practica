// Importaciones necesarias para la vista de configuración
// Material Design para la interfaz de usuario
import 'package:flutter/material.dart';
// Provider para la gestión del estado de la aplicación
import 'package:provider/provider.dart';
// Proveedor de tema para gestionar el modo claro/oscuro
import '../theme/theme_provider.dart';
// Servicio de idioma para gestionar la internacionalización
import '../services/language_service.dart';
// Utilidades para la internacionalización
import '../utils/localizations.dart';

/// Widget que muestra la pantalla de configuración de la aplicación.
/// 
/// Esta vista permite al usuario:
/// - Cambiar el tema de la aplicación (claro/oscuro/sistema)
/// - Cambiar el idioma (español/inglés)
/// - Ver información sobre la aplicación
/// 
/// Utiliza StatefulWidget para manejar el estado de los diálogos y opciones.
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    // Obtención de los providers necesarios
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageService = Provider.of<LanguageService>(context);
    final i18n = AppLocalizations.of(context);
    
    return Scaffold(
      // Barra superior con título
      appBar: AppBar(
        title: Text(i18n.text('settings')),
      ),
      // Lista desplazable con las diferentes secciones de configuración
      body: ListView(
        children: [
          // Sección de apariencia (tema)
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: Text(
              i18n.text('appearance').toUpperCase(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Tarjeta para la opción de tema
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.brightness_6, color: Colors.blue),
              title: Text(i18n.text('theme')),
              subtitle: Text(_getThemeText(themeProvider.themeMode, i18n)),
              onTap: () {
                _showThemeDialog(context, themeProvider, i18n);
              },
            ),
          ),
          
          // Sección de idioma
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: Text(
              i18n.text('language').toUpperCase(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Tarjeta para la opción de idioma
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: Text(i18n.text('language')),
              subtitle: Text(_getLanguageText(languageService.currentLanguage, i18n)),
              onTap: () {
                _showLanguageDialog(context, languageService, i18n);
              },
            ),
          ),
          
          // Sección de información
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: Text(
              i18n.text('information').toUpperCase(),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // Tarjeta para la información de la aplicación
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: Text(i18n.text('about')),
              subtitle: Text('${i18n.text("version")} 1.0.0'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AboutDialog(
                      applicationName: i18n.text('app_name'),
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.task_alt,
                        size: 50,
                        color: Colors.blue,
                      ),
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'Una aplicación de gestión de tareas desarrollada con Flutter siguiendo la arquitectura MVVM.',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '© 2023 Task Manager Team',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// Obtiene el texto traducido correspondiente al modo de tema actual.
  /// 
  /// @param themeMode El modo de tema actual (claro/oscuro/sistema)
  /// @param i18n Instancia de AppLocalizations para las traducciones
  /// @return El texto traducido del modo de tema
  String _getThemeText(ThemeMode themeMode, AppLocalizations i18n) {
    switch (themeMode) {
      case ThemeMode.light:
        return i18n.text('light');
      case ThemeMode.dark:
        return i18n.text('dark');
      default:
        return i18n.text('system');
    }
  }
  
  /// Obtiene el texto traducido correspondiente al idioma actual.
  /// 
  /// @param language El idioma actual
  /// @param i18n Instancia de AppLocalizations para las traducciones
  /// @return El texto traducido del idioma
  String _getLanguageText(String language, AppLocalizations i18n) {
    switch (language) {
      case 'Spanish':
        return i18n.text('spanish');
      default:
        return i18n.text('english');
    }
  }
  
  /// Muestra un diálogo para seleccionar el tema de la aplicación.
  /// 
  /// El diálogo muestra tres opciones:
  /// - Sistema: Sigue la configuración del sistema
  /// - Claro: Tema claro
  /// - Oscuro: Tema oscuro
  /// 
  /// @param context El contexto de construcción
  /// @param themeProvider El proveedor de tema
  /// @param i18n Instancia de AppLocalizations para las traducciones
  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider, AppLocalizations i18n) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.text('theme')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context, 
                i18n.text('system'), 
                i18n.text('follows_system'), 
                Icons.settings, 
                ThemeMode.system, 
                themeProvider
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                context, 
                i18n.text('light'), 
                i18n.text('light_theme'), 
                Icons.light_mode, 
                ThemeMode.light, 
                themeProvider
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                context, 
                i18n.text('dark'), 
                i18n.text('dark_theme'), 
                Icons.dark_mode, 
                ThemeMode.dark, 
                themeProvider
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(i18n.text('close')),
            ),
          ],
        );
      },
    );
  }
  
  /// Construye una opción de tema para el diálogo de selección.
  /// 
  /// Cada opción incluye:
  /// - Un icono representativo
  /// - Un título
  /// - Una descripción
  /// - Un radio button para selección
  /// 
  /// @param context El contexto de construcción
  /// @param title El título de la opción
  /// @param subtitle La descripción de la opción
  /// @param icon El icono a mostrar
  /// @param themeMode El modo de tema que representa esta opción
  /// @param themeProvider El proveedor de tema
  Widget _buildThemeOption(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    ThemeMode themeMode, 
    ThemeProvider themeProvider
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<ThemeMode>(
        value: themeMode,
        groupValue: themeProvider.themeMode,
        onChanged: (ThemeMode? value) {
          if (value != null) {
            themeProvider.setThemeMode(value);
            Navigator.of(context).pop();
          }
        },
      ),
      onTap: () {
        themeProvider.setThemeMode(themeMode);
        Navigator.of(context).pop();
      },
    );
  }
  
  /// Muestra un diálogo para seleccionar el idioma de la aplicación.
  /// 
  /// El diálogo muestra dos opciones:
  /// - Inglés
  /// - Español
  /// 
  /// Al cambiar el idioma:
  /// 1. Se actualiza el idioma en el servicio
  /// 2. Se muestra un mensaje de confirmación
  /// 3. Se navega al inicio para reconstruir todas las vistas
  /// 
  /// @param context El contexto de construcción
  /// @param languageService El servicio de idioma
  /// @param i18n Instancia de AppLocalizations para las traducciones
  void _showLanguageDialog(BuildContext context, LanguageService languageService, AppLocalizations i18n) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.text('language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context, 
                i18n.text('english'), 
                'English', 
                Icons.language, 
                'English', 
                languageService,
                i18n
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                context, 
                i18n.text('spanish'), 
                'Spanish', 
                Icons.language, 
                'Spanish', 
                languageService,
                i18n
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(i18n.text('close')),
            ),
          ],
        );
      },
    );
  }
  
  /// Construye una opción de idioma para el diálogo de selección.
  /// 
  /// Cada opción incluye:
  /// - Un icono de idioma
  /// - Un título traducido
  /// - El nombre del idioma
  /// - Un radio button para selección
  /// 
  /// Al seleccionar un idioma:
  /// 1. Se actualiza el idioma en el servicio
  /// 2. Se cierra el diálogo
  /// 3. Se muestra un mensaje de confirmación
  /// 4. Se navega al inicio para reconstruir todas las vistas
  /// 
  /// @param context El contexto de construcción
  /// @param title El título traducido de la opción
  /// @param subtitle El nombre del idioma
  /// @param icon El icono a mostrar
  /// @param language El código del idioma
  /// @param languageService El servicio de idioma
  /// @param i18n Instancia de AppLocalizations para las traducciones
  Widget _buildLanguageOption(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    String language, 
    LanguageService languageService,
    AppLocalizations i18n
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<String>(
        value: language,
        groupValue: languageService.currentLanguage,
        onChanged: (String? value) {
          if (value != null) {
            languageService.setLanguage(value);
            Navigator.of(context).pop();
            
            // Mostrar un SnackBar indicando el cambio de idioma
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(languageService.getLanguageChangedMessage())),
            );
            
            // Navegar al inicio para reconstruir todas las vistas
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
      ),
      onTap: () {
        languageService.setLanguage(language);
        Navigator.of(context).pop();
        
        // Mostrar un SnackBar indicando el cambio de idioma
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(languageService.getLanguageChangedMessage())),
        );
        
        // Navegar al inicio para reconstruir todas las vistas
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
} 