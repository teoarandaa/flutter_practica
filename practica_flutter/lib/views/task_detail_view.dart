import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_detail_viewmodel.dart';
import '../models/category.dart';
import 'task_edit_view.dart';

class TaskDetailView extends StatelessWidget {
  final String taskId;
  
  const TaskDetailView({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = TaskDetailViewModel();
        viewModel.loadTask(taskId);
        return viewModel;
      },
      child: Consumer<TaskDetailViewModel>(
        builder: (context, viewModel, child) {
          final task = viewModel.task;
          
          if (task == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final category = Categories.all.firstWhere(
            (cat) => cat.id == task.category,
            orElse: () => Categories.all.first,
          );
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Task Details'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskEditView(task: task),
                      ),
                    ).then((_) {
                      viewModel.loadTask(taskId);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmation(context, viewModel);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: category.color.withOpacity(0.2),
                        radius: 24,
                        child: Icon(category.icon, color: category.color, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              category.name,
                              style: TextStyle(
                                color: category.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) {
                          viewModel.toggleTaskCompletion();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard('Due Date', '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}', Icons.calendar_today),
                  const SizedBox(height: 16),
                  _buildInfoCard('Priority', _getPriorityText(task.priority), Icons.flag, color: _getPriorityColor(task.priority)),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildInfoCard(String title, String value, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, TaskDetailViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteTask();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
  
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 1:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 3:
        return 'HIGH';
      case 2:
        return 'MEDIUM';
      case 1:
        return 'LOW';
      default:
        return 'NONE';
    }
  }
} 