import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio que gestiona la internacionalización de la aplicación.
/// 
/// Este servicio implementa el patrón ChangeNotifier para notificar a los widgets
/// cuando cambia el idioma de la aplicación. Mantiene un mapa de traducciones
/// para diferentes idiomas y permite cambiar entre ellos.
class LanguageService with ChangeNotifier {
  /// Idioma actual de la aplicación.
  /// 
  /// Almacena el nombre del idioma actual (por ejemplo, 'English' o 'Spanish').
  String _currentLanguage = 'en';

  /// Mapa de traducciones para diferentes idiomas.
  /// 
  /// Estructura:
  /// - Clave: código del idioma ('en' o 'es')
  /// - Valor: mapa de claves de traducción y sus valores traducidos
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
      
      // Additional keys
      'organize_tasks': 'Organize your tasks',
      'task_created': 'Task created',
      'task_not_found': 'Task not found',
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
      
      // Additional keys
      'organize_tasks': 'Organiza tus tareas',
      'task_created': 'Tarea creada',
      'task_not_found': 'Tarea no encontrada',
    }
  };
  
  /// Código del idioma actual.
  /// 
  /// Almacena el código del idioma actual ('en' o 'es').
  String _currentCodeLanguage = 'en';
  
  /// Constructor del servicio de idioma.
  /// 
  /// Inicializa el servicio y carga el idioma guardado en las preferencias.
  LanguageService() {
    _loadLanguageFromPrefs();
  }
  
  /// Obtiene el idioma actual.
  /// 
  /// Devuelve el nombre del idioma actual.
  String get currentLanguage => _currentLanguage;

  /// Obtiene la configuración regional actual.
  /// 
  /// Devuelve un objeto Locale que representa el idioma actual.
  Locale get locale => Locale(_currentCodeLanguage);
  
  /// Traduce una clave a su valor en el idioma actual.
  /// 
  /// [key] - La clave de traducción a buscar.
  /// 
  /// Devuelve el texto traducido. Si no se encuentra en el idioma actual,
  /// intenta usar el inglés como respaldo. Si tampoco está en inglés,
  /// devuelve la clave original.
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
  
  /// Carga el idioma guardado en las preferencias.
  /// 
  /// Este método privado se llama durante la inicialización del servicio
  /// para cargar el idioma guardado previamente.
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
  
  /// Cambia el idioma de la aplicación.
  /// 
  /// [language] - El nombre del nuevo idioma ('English' o 'Spanish').
  /// 
  /// Actualiza el idioma actual, guarda la preferencia y notifica a los oyentes.
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
  
  /// Obtiene el mensaje de cambio de idioma.
  /// 
  /// Devuelve el texto traducido que indica que el idioma ha sido cambiado.
  String getLanguageChangedMessage() {
    return translate('language_changed');
  }
} 