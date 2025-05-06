import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_detail_viewmodel.dart';
import '../models/category.dart';
import 'task_edit_view.dart';
import '../utils/localizations.dart';

class TaskDetailView extends StatelessWidget {
  final String taskId;
  
  const TaskDetailView({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    
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
              title: Text(i18n.text('task_details')),
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
                    _showDeleteConfirmation(context, viewModel, i18n);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: task.isCompleted 
                          ? Colors.green.withOpacity(0.2) 
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          task.isCompleted 
                              ? Icons.check_circle 
                              : Icons.pending_actions,
                          color: task.isCompleted ? Colors.green : Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.isCompleted ? i18n.text('task_completed') : i18n.text('task_pending'),
                          style: TextStyle(
                            color: task.isCompleted ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
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
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(
                              i18n.text(category.id),
                              style: TextStyle(
                                color: category.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(i18n.text('due_date'), '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}', Icons.calendar_today, context),
                  const SizedBox(height: 16),
                  _buildInfoCard(i18n.text('priority'), _getPriorityText(task.priority, i18n), Icons.flag, context, color: _getPriorityColor(task.priority)),
                  const SizedBox(height: 24),
                  Text(
                    i18n.text('description'),
                    style: const TextStyle(
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
                      style: TextStyle(
                        fontSize: 16,
                        color: task.isCompleted ? Colors.grey : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        viewModel.toggleTaskCompletion();
                      },
                      icon: Icon(task.isCompleted ? Icons.refresh : Icons.check_circle),
                      label: Text(
                        task.isCompleted
                            ? i18n.text('mark_as_pending')
                            : i18n.text('mark_as_completed'),
                        style: const TextStyle(fontSize: 16),
                      ),
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
  
  Widget _buildInfoCard(String title, String value, IconData icon, BuildContext context, {Color? color}) {
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
  
  void _showDeleteConfirmation(BuildContext context, TaskDetailViewModel viewModel, AppLocalizations i18n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(i18n.text('delete_task_title')),
        content: Text(i18n.text('delete_task_message')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(i18n.text('cancel')),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteTask();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(i18n.text('delete')),
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

  String _getPriorityText(int priority, AppLocalizations i18n) {
    switch (priority) {
      case 3:
        return i18n.text('high');
      case 2:
        return i18n.text('medium');
      case 1:
        return i18n.text('low');
      default:
        return i18n.text('none');
    }
  }
} 