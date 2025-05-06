import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskListViewModel extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  
  String _currentFilter = 'all'; // 'all', 'completed', 'pending', or a category ID
  String get currentFilter => _currentFilter;
  
  TaskListViewModel() {
    refreshTasks();
  }
  
  void refreshTasks() {
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
  
  void setFilter(String filter) {
    _currentFilter = filter;
    refreshTasks();
  }
  
  void addTask(Task task) {
    _taskService.addTask(task);
    refreshTasks();
  }
  
  void updateTask(Task task) {
    _taskService.updateTask(task);
    refreshTasks();
  }
  
  void deleteTask(String taskId) {
    _taskService.deleteTask(taskId);
    refreshTasks();
  }
  
  void toggleTaskCompletion(String taskId) {
    _taskService.toggleTaskCompletion(taskId);
    refreshTasks();
  }
  
  List<Task> getTasksByPriority(int priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }
  
  // Sort tasks by due date
  void sortTasksByDueDate() {
    _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    notifyListeners();
  }
  
  // Sort tasks by priority
  void sortTasksByPriority() {
    _tasks.sort((a, b) => b.priority.compareTo(a.priority));
    notifyListeners();
  }
} 