import 'dart:math';
import '../models/task.dart';
import '../models/category.dart';

/// Servicio que gestiona las operaciones relacionadas con las tareas.
/// 
/// Este servicio implementa el patrón Singleton para garantizar una única instancia
/// que maneje todas las operaciones de tareas en la aplicación. Simula un servicio
/// que normalmente interactuaría con una base de datos o API.
class TaskService {
  /// Instancia única del servicio de tareas.
  /// 
  /// Se utiliza para implementar el patrón Singleton y garantizar
  /// que solo exista una instancia del servicio en toda la aplicación.
  static final TaskService _instance = TaskService._internal();
  
  /// Constructor factory que devuelve la instancia única.
  /// 
  /// Este constructor garantiza que siempre se devuelva la misma instancia
  /// del servicio de tareas.
  factory TaskService() {
    return _instance;
  }
  
  /// Constructor privado que inicializa el servicio.
  /// 
  /// Se llama solo una vez cuando se crea la instancia única.
  /// Inicializa la lista de tareas y genera tareas de ejemplo.
  TaskService._internal() {
    _generateSampleTasks();
  }

  /// Lista interna que almacena todas las tareas.
  /// 
  /// Esta lista es privada y solo se puede acceder a ella a través
  /// de los métodos públicos del servicio.
  final List<Task> _tasks = [];
  
  /// Obtiene todas las tareas almacenadas.
  /// 
  /// Devuelve una lista inmutable de todas las tareas para evitar
  /// modificaciones directas fuera del servicio.
  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }
  
  /// Obtiene las tareas filtradas por categoría.
  /// 
  /// [categoryId] - El identificador de la categoría por la que filtrar.
  /// 
  /// Devuelve una lista de tareas que pertenecen a la categoría especificada.
  List<Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.category == categoryId).toList();
  }
  
  /// Obtiene las tareas filtradas por estado de completado.
  /// 
  /// [isCompleted] - El estado de completado por el que filtrar.
  /// 
  /// Devuelve una lista de tareas que coinciden con el estado especificado.
  List<Task> getTasksByCompletionStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }
  
  /// Añade una nueva tarea al servicio.
  /// 
  /// [task] - La tarea que se va a añadir.
  void addTask(Task task) {
    _tasks.add(task);
  }
  
  /// Actualiza una tarea existente.
  /// 
  /// [updatedTask] - La tarea con los datos actualizados.
  /// 
  /// Si la tarea no existe, no se realiza ninguna acción.
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }
  
  /// Elimina una tarea del servicio.
  /// 
  /// [taskId] - El identificador de la tarea a eliminar.
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
  }
  
  /// Cambia el estado de completado de una tarea.
  /// 
  /// [taskId] - El identificador de la tarea a modificar.
  /// 
  /// Si la tarea existe, invierte su estado de completado.
  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    }
  }
  
  /// Genera tareas de ejemplo para la demostración.
  /// 
  /// Este método privado crea 15 tareas de ejemplo con datos aleatorios
  /// para mostrar la funcionalidad de la aplicación. Solo se ejecuta
  /// cuando la lista de tareas está vacía.
  void _generateSampleTasks() {
    if (_tasks.isNotEmpty) return; // Solo genera si la lista está vacía
    
    final random = Random();
    
    for (int i = 0; i < 15; i++) {
      final categoryIndex = random.nextInt(Categories.all.length);
      final category = Categories.all[categoryIndex];
      
      _tasks.add(
        Task(
          id: 'task-${i + 1}',
          title: 'Sample Task ${i + 1}',
          description: 'This is a sample task description for task ${i + 1}',
          dueDate: DateTime.now().add(Duration(days: random.nextInt(10))),
          category: category.id,
          priority: random.nextInt(3) + 1,
          isCompleted: random.nextBool(),
        ),
      );
    }
  }
} 