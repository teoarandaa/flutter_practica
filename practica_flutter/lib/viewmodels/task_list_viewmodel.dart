import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// ViewModel que gestiona la lógica de negocio para la lista de tareas.
/// 
/// Este ViewModel implementa el patrón ChangeNotifier para notificar a la vista
/// cuando cambia el estado de la lista de tareas. Se encarga de cargar, filtrar,
/// ordenar y gestionar las tareas, así como de realizar operaciones CRUD.
class TaskListViewModel extends ChangeNotifier {
  /// Instancia del servicio de tareas.
  /// 
  /// Se utiliza para realizar operaciones CRUD en las tareas.
  final TaskService _taskService = TaskService();
  
  /// Lista de tareas actual.
  /// 
  /// Contiene las tareas filtradas según el filtro actual.
  List<Task> _tasks = [];
  
  /// Obtiene la lista actual de tareas.
  /// 
  /// Devuelve la lista de tareas filtrada según el filtro actual.
  List<Task> get tasks => _tasks;
  
  /// Filtro actual aplicado a la lista de tareas.
  /// 
  /// Valores posibles:
  /// - 'all': Muestra todas las tareas
  /// - 'completed': Muestra solo tareas completadas
  /// - 'pending': Muestra solo tareas pendientes
  /// - ID de categoría: Muestra tareas de una categoría específica
  String _currentFilter = 'all';
  
  /// Obtiene el filtro actual.
  /// 
  /// Devuelve el valor del filtro que se está aplicando a la lista de tareas.
  String get currentFilter => _currentFilter;
  
  /// Constructor del ViewModel.
  /// 
  /// Inicializa el ViewModel y carga las tareas iniciales.
  TaskListViewModel() {
    refreshTasks();
  }
  
  /// Actualiza la lista de tareas según el filtro actual.
  /// 
  /// Este método:
  /// 1. Obtiene las tareas del servicio según el filtro actual
  /// 2. Compara con la lista actual para evitar actualizaciones innecesarias
  /// 3. Actualiza el estado interno si hay cambios
  /// 4. Notifica a los oyentes si hubo cambios
  void refreshTasks() {
    List<Task> newTasks;
    
    if (_currentFilter == 'all') {
      newTasks = _taskService.getAllTasks();
    } else if (_currentFilter == 'completed') {
      newTasks = _taskService.getTasksByCompletionStatus(true);
    } else if (_currentFilter == 'pending') {
      newTasks = _taskService.getTasksByCompletionStatus(false);
    } else {
      // Filter by category
      newTasks = _taskService.getTasksByCategory(_currentFilter);
    }
    
    if (_tasksAreDifferent(_tasks, newTasks)) {
      _tasks = newTasks;
      notifyListeners();
    } else {
      _tasks = newTasks;
    }
  }
  
  /// Compara dos listas de tareas para detectar cambios.
  /// 
  /// [oldTasks] - La lista de tareas anterior.
  /// [newTasks] - La nueva lista de tareas.
  /// 
  /// Devuelve true si hay diferencias en:
  /// - Número de tareas
  /// - IDs de las tareas
  /// - Estado de completado
  /// - Título
  /// - Descripción
  /// - Prioridad
  /// - Categoría
  /// - Fecha de vencimiento
  bool _tasksAreDifferent(List<Task> oldTasks, List<Task> newTasks) {
    if (oldTasks.length != newTasks.length) return true;
    
    for (int i = 0; i < oldTasks.length; i++) {
      if (oldTasks[i].id != newTasks[i].id ||
          oldTasks[i].isCompleted != newTasks[i].isCompleted ||
          oldTasks[i].title != newTasks[i].title ||
          oldTasks[i].description != newTasks[i].description ||
          oldTasks[i].priority != newTasks[i].priority ||
          oldTasks[i].category != newTasks[i].category ||
          oldTasks[i].dueDate.compareTo(newTasks[i].dueDate) != 0) {
        return true;
      }
    }
    
    return false;
  }
  
  /// Establece un nuevo filtro para la lista de tareas.
  /// 
  /// [filter] - El nuevo filtro a aplicar.
  /// 
  /// Si el filtro es diferente al actual, actualiza la lista de tareas.
  void setFilter(String filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      refreshTasks();
    }
  }
  
  /// Añade una nueva tarea.
  /// 
  /// [task] - La tarea a añadir.
  /// 
  /// Añade la tarea al servicio y actualiza la lista en el siguiente ciclo.
  void addTask(Task task) {
    _taskService.addTask(task);
    Future.microtask(() => refreshTasks());
  }
  
  /// Actualiza una tarea existente.
  /// 
  /// [task] - La tarea con los datos actualizados.
  /// 
  /// Actualiza la tarea en el servicio y actualiza la lista en el siguiente ciclo.
  void updateTask(Task task) {
    _taskService.updateTask(task);
    Future.microtask(() => refreshTasks());
  }
  
  /// Elimina una tarea.
  /// 
  /// [taskId] - El ID de la tarea a eliminar.
  /// 
  /// Elimina la tarea del servicio y actualiza la lista en el siguiente ciclo.
  void deleteTask(String taskId) {
    _taskService.deleteTask(taskId);
    Future.microtask(() => refreshTasks());
  }
  
  /// Cambia el estado de completado de una tarea.
  /// 
  /// [taskId] - El ID de la tarea a modificar.
  /// 
  /// Cambia el estado en el servicio y actualiza la lista inmediatamente
  /// para asegurar que todas las vistas se actualicen correctamente.
  void toggleTaskCompletion(String taskId) {
    _taskService.toggleTaskCompletion(taskId);
    // Forzar una actualización inmediata para asegurar que todas las vistas se actualicen
    if (_currentFilter == 'all') {
      _tasks = _taskService.getAllTasks();
    } else if (_currentFilter == 'completed') {
      _tasks = _taskService.getTasksByCompletionStatus(true);
    } else if (_currentFilter == 'pending') {
      _tasks = _taskService.getTasksByCompletionStatus(false);
    } else {
      // Filter by category
      _tasks = _taskService.getTasksByCategory(_currentFilter);
    }
    notifyListeners();
  }
  
  /// Obtiene las tareas filtradas por prioridad.
  /// 
  /// [priority] - El nivel de prioridad a filtrar (1-3).
  /// 
  /// Devuelve una lista de tareas que tienen la prioridad especificada.
  List<Task> getTasksByPriority(int priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }
  
  /// Ordena las tareas por fecha de vencimiento.
  /// 
  /// Ordena la lista actual de tareas de forma ascendente según su fecha
  /// de vencimiento y notifica a los oyentes del cambio.
  void sortTasksByDueDate() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }
  
  /// Ordena las tareas por prioridad.
  /// 
  /// Ordena la lista actual de tareas de forma descendente según su
  /// prioridad (mayor a menor) y notifica a los oyentes del cambio.
  void sortTasksByPriority() {
    _tasks.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }
} 