/// Modelo que representa una tarea en la aplicación.
/// 
/// Esta clase define la estructura de datos para una tarea, incluyendo sus propiedades
/// y métodos para manipular su estado. Las tareas son inmutables (todos los campos son final)
/// para garantizar la consistencia de los datos.
class Task {
  /// Identificador único de la tarea.
  /// 
  /// Este campo es requerido y debe ser único para cada tarea.
  final String id;

  /// Título o nombre de la tarea.
  /// 
  /// Representa el nombre corto y descriptivo de la tarea.
  final String title;

  /// Descripción detallada de la tarea.
  /// 
  /// Contiene información adicional sobre lo que implica la tarea.
  final String description;

  /// Fecha límite para completar la tarea.
  /// 
  /// Indica cuándo debe estar completada la tarea.
  final DateTime dueDate;

  /// Estado de completado de la tarea.
  /// 
  /// - `true`: La tarea está completada
  /// - `false`: La tarea está pendiente
  /// 
  /// Por defecto es `false` cuando se crea una nueva tarea.
  final bool isCompleted;

  /// Categoría a la que pertenece la tarea.
  /// 
  /// Debe coincidir con el ID de una categoría predefinida.
  final String category;

  /// Nivel de prioridad de la tarea.
  /// 
  /// Valores posibles:
  /// - 1: Baja prioridad
  /// - 2: Prioridad media
  /// - 3: Alta prioridad
  final int priority; // 1-3 where 3 is highest

  /// Constructor de la clase Task.
  /// 
  /// Todos los parámetros son requeridos excepto `isCompleted`, que por defecto es `false`.
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.category,
    required this.priority,
  });

  /// Crea una nueva instancia de Task con valores opcionalmente modificados.
  /// 
  /// Este método permite crear una nueva tarea basada en la actual, modificando
  /// solo los campos que se especifiquen. Los campos no especificados mantienen
  /// sus valores originales.
  /// 
  /// Ejemplo:
  /// ```dart
  /// final updatedTask = task.copyWith(isCompleted: true);
  /// ```
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
    int? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
    );
  }
} 