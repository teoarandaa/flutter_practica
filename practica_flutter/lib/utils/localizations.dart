import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/language_service.dart';

// Helper class para acceder fácilmente a las traducciones
class AppLocalizations {
  final BuildContext context;
  
  AppLocalizations(this.context);
  
  // Método para obtener el texto traducido
  String text(String key) {
    final languageService = Provider.of<LanguageService>(context, listen: true);
    return languageService.translate(key);
  }
  
  // Factory method para obtener una instancia de AppLocalizations
  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(context);
  }
} 