import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../services/language_service.dart';
import '../utils/localizations.dart';

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
    final i18n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.text('settings')),
      ),
      body: ListView(
        children: [
          // Sección de tema
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
  
  String _getLanguageText(String language, AppLocalizations i18n) {
    switch (language) {
      case 'Spanish':
        return i18n.text('spanish');
      default:
        return i18n.text('english');
    }
  }
  
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
      },
    );
  }
} 