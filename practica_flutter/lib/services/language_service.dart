import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService with ChangeNotifier {
  String _currentLanguage = 'en';
  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Common
      'app_name': 'Task Manager',
      'ok': 'OK',
      'cancel': 'Cancel',
      'close': 'Close',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      
      // Task status
      'task_completed': 'COMPLETED',
      'task_pending': 'PENDING',
      'mark_as_completed': 'Mark as completed',
      'mark_as_pending': 'Mark as pending',
      
      // Task properties
      'title': 'Title',
      'description': 'Description',
      'due_date': 'Due Date',
      'category': 'Category',
      'priority': 'Priority',
      'high': 'HIGH',
      'medium': 'MEDIUM',
      'low': 'LOW',
      'none': 'NONE',
      
      // Categories
      'work': 'Work',
      'personal': 'Personal',
      'study': 'Study',
      'health': 'Health',
      'shopping': 'Shopping',
      
      // Tabs
      'all': 'All',
      'pending': 'Pending',
      'completed': 'Completed',
      
      // Empty states
      'no_tasks': 'No tasks available. Add a new task!',
      'no_pending_tasks': 'No pending tasks. Good job!',
      'no_completed_tasks': 'No completed tasks yet. Complete some tasks!',
      'all_tasks_completed': 'All your tasks are completed',
      'complete_some_tasks': 'Complete some tasks and they will appear here',
      
      // Settings
      'settings': 'Settings',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'language': 'Language',
      'information': 'Information',
      'about': 'About',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'english': 'English',
      'spanish': 'Spanish',
      'follows_system': 'Follows system settings',
      'light_theme': 'Light theme',
      'dark_theme': 'Dark theme',
      'version': 'Version',
      'language_changed': 'Language changed to English',
      
      // Task actions
      'add_task': 'Add Task',
      'edit_task': 'Edit Task',
      'create_task': 'Create Task',
      'task_details': 'Task Details',
      'delete_task_title': 'Delete Task',
      'delete_task_message': 'Are you sure you want to delete this task? This action cannot be undone.',
      'enter_title': 'Please enter a title',
      
      // Additional needed keys
      'tasks': 'Tasks',
      'no': 'No',
      'yet': 'yet',
    },
    
    'es': {
      // Common
      'app_name': 'Gestor de Tareas',
      'ok': 'Aceptar',
      'cancel': 'Cancelar',
      'close': 'Cerrar',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      
      // Task status
      'task_completed': 'COMPLETADA',
      'task_pending': 'PENDIENTE',
      'mark_as_completed': 'Marcar como completada',
      'mark_as_pending': 'Marcar como pendiente',
      
      // Task properties
      'title': 'Título',
      'description': 'Descripción',
      'due_date': 'Fecha límite',
      'category': 'Categoría',
      'priority': 'Prioridad',
      'high': 'ALTA',
      'medium': 'MEDIA',
      'low': 'BAJA',
      'none': 'NINGUNA',
      
      // Categories
      'work': 'Trabajo',
      'personal': 'Personal',
      'study': 'Estudio',
      'health': 'Salud',
      'shopping': 'Compras',
      
      // Tabs
      'all': 'Todas',
      'pending': 'Pendientes',
      'completed': 'Completadas',
      
      // Empty states
      'no_tasks': '¡No hay tareas disponibles. Añade una nueva tarea!',
      'no_pending_tasks': '¡No hay tareas pendientes. ¡Buen trabajo!',
      'no_completed_tasks': 'No hay tareas completadas aún. ¡Completa algunas tareas!',
      'all_tasks_completed': 'Todas tus tareas están completadas',
      'complete_some_tasks': 'Completa algunas tareas y aparecerán aquí',
      
      // Settings
      'settings': 'Ajustes',
      'appearance': 'Apariencia',
      'theme': 'Tema',
      'language': 'Idioma',
      'information': 'Información',
      'about': 'Acerca de',
      'system': 'Sistema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'english': 'Inglés',
      'spanish': 'Español',
      'follows_system': 'Sigue la configuración del sistema',
      'light_theme': 'Tema claro',
      'dark_theme': 'Tema oscuro',
      'version': 'Versión',
      'language_changed': 'Idioma cambiado a Español',
      
      // Task actions
      'add_task': 'Añadir Tarea',
      'edit_task': 'Editar Tarea',
      'create_task': 'Crear Tarea',
      'task_details': 'Detalles de la Tarea',
      'delete_task_title': 'Eliminar Tarea',
      'delete_task_message': '¿Estás seguro de que quieres eliminar esta tarea? Esta acción no se puede deshacer.',
      'enter_title': 'Por favor, introduce un título',
      
      // Additional needed keys
      'tasks': 'Tareas',
      'no': 'No hay',
      'yet': 'aún',
    }
  };
  
  String _currentCodeLanguage = 'en';
  
  LanguageService() {
    _loadLanguageFromPrefs();
  }
  
  // Getters
  String get currentLanguage => _currentLanguage;
  Locale get locale => Locale(_currentCodeLanguage);
  
  // Obtener texto traducido
  String translate(String key) {
    if (_localizedValues.containsKey(_currentCodeLanguage) && 
        _localizedValues[_currentCodeLanguage]!.containsKey(key)) {
      return _localizedValues[_currentCodeLanguage]![key]!;
    }
    
    // Fallback al inglés si no se encuentra la clave
    if (_localizedValues['en']!.containsKey(key)) {
      return _localizedValues['en']![key]!;
    }
    
    // Si no existe ni en el idioma actual ni en inglés, devolver la clave
    return key;
  }
  
  void _loadLanguageFromPrefs() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('app_language') ?? 'English';
      
      // Convertir el nombre del idioma al código
      _currentCodeLanguage = _currentLanguage == 'Spanish' ? 'es' : 'en';
      
      notifyListeners();
    } catch (e) {
      // Si hay un error, mantenemos el idioma predeterminado
    }
  }
  
  Future<void> setLanguage(String language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      _currentCodeLanguage = language == 'Spanish' ? 'es' : 'en';
      notifyListeners();
      
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('app_language', language);
      } catch (e) {
        // Si hay un error, seguimos con el idioma en memoria
      }
    }
  }
  
  // Helper para obtener el mensaje de cambio de idioma
  String getLanguageChangedMessage() {
    return translate('language_changed');
  }
} 