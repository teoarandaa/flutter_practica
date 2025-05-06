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
  
  void setFilter(String filter) {
    if (_currentFilter != filter) {
      _currentFilter = filter;
      refreshTasks();
    }
  }
  
  void addTask(Task task) {
    _taskService.addTask(task);
    Future.microtask(() => refreshTasks());
  }
  
  void updateTask(Task task) {
    _taskService.updateTask(task);
    Future.microtask(() => refreshTasks());
  }
  
  void deleteTask(String taskId) {
    _taskService.deleteTask(taskId);
    Future.microtask(() => refreshTasks());
  }
  
  void toggleTaskCompletion(String taskId) {
    _taskService.toggleTaskCompletion(taskId);
    Future.microtask(() => refreshTasks());
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