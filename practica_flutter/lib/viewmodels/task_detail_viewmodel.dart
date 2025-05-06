import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetailViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  Task? _task;
  
  Task? get task => _task;
  
  void loadTask(String taskId) {
    final allTasks = _taskService.getAllTasks();
    _task = allTasks.firstWhere((task) => task.id == taskId, orElse: () => throw Exception('Task not found'));
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
      _task = _task!.copyWith(isCompleted: !_task!.isCompleted);
      notifyListeners();
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