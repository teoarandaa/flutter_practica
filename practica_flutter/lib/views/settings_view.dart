import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/language_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageService = Provider.of<LanguageService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: ListView(
        children: [
          // Sección de tema
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: const Text(
              'APARIENCIA',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.brightness_6, color: Colors.blue),
              title: const Text('Tema'),
              subtitle: Text(_getThemeText(themeProvider.themeMode)),
              onTap: () {
                _showThemeDialog(context, themeProvider);
              },
            ),
          ),
          
          // Sección de idioma
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: const Text(
              'IDIOMA',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('Idioma'),
              subtitle: Text(_getLanguageText(languageService.currentLanguage)),
              onTap: () {
                _showLanguageDialog(context, languageService);
              },
            ),
          ),
          
          // Sección de información
          Container(
            margin: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
            child: const Text(
              'INFORMACIÓN',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('Acerca de'),
              subtitle: const Text('Versión 1.0.0'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AboutDialog(
                      applicationName: 'Task Manager',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(
                        Icons.task_alt,
                        size: 50,
                        color: Colors.blue,
                      ),
                      children: const [
                        SizedBox(height: 16),
                        Text(
                          'Una aplicación de gestión de tareas desarrollada con Flutter siguiendo la arquitectura MVVM.',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
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
  
  String _getThemeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      default:
        return 'Sistema';
    }
  }
  
  String _getLanguageText(String language) {
    switch (language) {
      case 'Spanish':
        return 'Español';
      default:
        return 'Inglés';
    }
  }
  
  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildThemeOption(
                context, 
                'Sistema', 
                'Sigue la configuración del sistema', 
                Icons.settings, 
                ThemeMode.system, 
                themeProvider
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                context, 
                'Claro', 
                'Tema claro', 
                Icons.light_mode, 
                ThemeMode.light, 
                themeProvider
              ),
              const SizedBox(height: 16),
              _buildThemeOption(
                context, 
                'Oscuro', 
                'Tema oscuro', 
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
              child: const Text('CERRAR'),
            ),
          ],
        );
      },
    );
  }
  
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
  
  void _showLanguageDialog(BuildContext context, LanguageService languageService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Idioma'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context, 
                'Inglés', 
                'English', 
                Icons.language, 
                'English', 
                languageService
              ),
              const SizedBox(height: 16),
              _buildLanguageOption(
                context, 
                'Español', 
                'Spanish', 
                Icons.language, 
                'Spanish', 
                languageService
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CERRAR'),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context, 
    String title, 
    String subtitle, 
    IconData icon, 
    String language, 
    LanguageService languageService
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
          }
        },
      ),
      onTap: () {
        languageService.setLanguage(language);
        Navigator.of(context).pop();
      },
    );
  }
} 