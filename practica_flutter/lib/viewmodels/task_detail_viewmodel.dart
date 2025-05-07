import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

/// ViewModel que gestiona la lógica de negocio para la vista de detalle de tarea.
/// 
/// Este ViewModel implementa el patrón ChangeNotifier para notificar a la vista
/// cuando cambia el estado de la tarea. Se encarga de cargar, actualizar y
/// eliminar tareas individuales, así como de gestionar su estado de completado.
class TaskDetailViewModel extends ChangeNotifier {
  /// Instancia única del servicio de tareas.
  /// 
  /// Se utiliza para realizar operaciones CRUD en las tareas.
  static final TaskService _taskService = TaskService();
  
  /// Tarea actual que se está visualizando.
  /// 
  /// Puede ser null si no se ha cargado ninguna tarea o si se ha eliminado.
  Task? _task;
  
  /// Obtiene la tarea actual.
  /// 
  /// Devuelve la tarea que se está visualizando o null si no hay ninguna.
  Task? get task => _task;
  
  /// Carga una tarea específica por su ID.
  /// 
  /// [taskId] - El identificador único de la tarea a cargar.
  /// 
  /// Este método:
  /// 1. Obtiene todas las tareas del servicio
  /// 2. Busca la tarea con el ID especificado
  /// 3. Actualiza el estado interno
  /// 4. Notifica a los oyentes del cambio
  /// 
  /// Si no se encuentra la tarea, se establece _task como null.
  void loadTask(String taskId) {
    final allTasks = _taskService.getAllTasks();
    try {
      _task = allTasks.firstWhere(
        (task) => task.id == taskId,
      );
    } catch (e) {
      // Si no se encuentra la tarea, asignar null
      _task = null;
    }
    notifyListeners();
  }
  
  /// Actualiza una tarea existente.
  /// 
  /// [updatedTask] - La tarea con los datos actualizados.
  /// 
  /// Este método:
  /// 1. Actualiza la tarea en el servicio
  /// 2. Actualiza el estado interno
  /// 3. Notifica a los oyentes del cambio
  void updateTask(Task updatedTask) {
    _taskService.updateTask(updatedTask);
    _task = updatedTask;
    notifyListeners();
  }
  
  /// Cambia el estado de completado de la tarea actual.
  /// 
  /// Este método:
  /// 1. Verifica que exista una tarea cargada
  /// 2. Cambia el estado de completado en el servicio
  /// 3. Actualiza el estado local inmediatamente
  /// 4. Notifica a los oyentes del cambio
  /// 5. Realiza una segunda notificación después de un breve delay
  ///    para asegurar que todas las vistas se actualicen correctamente
  void toggleTaskCompletion() {
    if (_task != null) {
      _taskService.toggleTaskCompletion(_task!.id);
      
      // Actualizar el estado local inmediatamente
      _task = _task!.copyWith(isCompleted: !_task!.isCompleted);
      
      // Notificar a los oyentes que la tarea ha cambiado
      notifyListeners();
      
      // Usar un delay mínimo para permitir que el estado se propague correctamente
      Future.delayed(const Duration(milliseconds: 50), () {
        // Esta llamada garantiza que todas las vistas asociadas con TaskListViewModel se actualicen
        notifyListeners();
      });
    }
  }
  
  /// Elimina la tarea actual.
  /// 
  /// Este método:
  /// 1. Verifica que exista una tarea cargada
  /// 2. Elimina la tarea del servicio
  /// 3. Establece el estado interno como null
  /// 4. Notifica a los oyentes del cambio
  void deleteTask() {
    if (_task != null) {
      _taskService.deleteTask(_task!.id);
      _task = null;
      notifyListeners();
    }
  }
} 