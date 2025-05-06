import 'dart:math';
import '../models/task.dart';
import '../models/category.dart';
import 'package:flutter/material.dart';

// This simulates a service that would normally interact with a database or API
class TaskService {
  final List<Task> _tasks = [];
  
  // Constructor with sample data
  TaskService() {
    _generateSampleTasks();
  }
  
  // Get all tasks
  List<Task> getAllTasks() {
    return List.unmodifiable(_tasks);
  }
  
  // Get tasks by category
  List<Task> getTasksByCategory(String categoryId) {
    return _tasks.where((task) => task.category == categoryId).toList();
  }
  
  // Get tasks by completion status
  List<Task> getTasksByCompletionStatus(bool isCompleted) {
    return _tasks.where((task) => task.isCompleted == isCompleted).toList();
  }
  
  // Add a new task
  void addTask(Task task) {
    _tasks.add(task);
  }
  
  // Update an existing task
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }
  
  // Delete a task
  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
  }
  
  // Toggle task completion status
  void toggleTaskCompletion(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
    }
  }
  
  // Generate sample tasks for demonstration
  void _generateSampleTasks() {
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