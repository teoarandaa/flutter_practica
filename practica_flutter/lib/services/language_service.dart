import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService with ChangeNotifier {
  String _currentLanguage = 'English';
  
  String get currentLanguage => _currentLanguage;
  
  LanguageService() {
    _loadLanguageFromPrefs();
  }
  
  void _loadLanguageFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('app_language') ?? 'English';
      notifyListeners();
    } catch (e) {
      // Si hay un error, mantenemos el idioma predeterminado
    }
  }
  
  Future<void> setLanguage(String language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
      
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_language', language);
      } catch (e) {
        // Si hay un error, seguimos con el idioma en memoria
      }
    }
  }
} 