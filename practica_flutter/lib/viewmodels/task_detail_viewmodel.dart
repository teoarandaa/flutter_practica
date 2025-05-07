import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetailViewModel extends ChangeNotifier {
  static final TaskService _taskService = TaskService();
  Task? _task;
  
  Task? get task => _task;
  
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
  
  void updateTask(Task updatedTask) {
    _taskService.updateTask(updatedTask);
    _task = updatedTask;
    notifyListeners();
  }
  
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
  
  void deleteTask() {
    if (_task != null) {
      _taskService.deleteTask(_task!.id);
      _task = null;
      notifyListeners();
    }
  }
} 