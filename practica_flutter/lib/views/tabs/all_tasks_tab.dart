import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';

class AllTasksTab extends StatelessWidget {
  const AllTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        viewModel.setFilter('all');
        final tasks = viewModel.tasks;
        
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks available. Add a new task!'),
          );
        }
        
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            final category = Categories.all.firstWhere(
              (cat) => cat.id == task.category,
              orElse: () => Categories.all.first,
            );
            
            return TaskListItem(
              task: task,
              category: category,
              onTaskTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailView(taskId: task.id),
                  ),
                ).then((_) {
                  viewModel.refreshTasks();
                });
              },
              onTaskToggle: () {
                viewModel.toggleTaskCompletion(task.id);
              },
            );
          },
        );
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  final Task task;
  final Category category;
  final VoidCallback onTaskTap;
  final VoidCallback onTaskToggle;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.category,
    required this.onTaskTap,
    required this.onTaskToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: category.color.withOpacity(0.2),
              child: Icon(category.icon, color: category.color),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: task.isCompleted ? Colors.grey : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getPriorityText(task.priority),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: task.isCompleted ? Colors.green.withOpacity(0.7) : Colors.orange.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        task.isCompleted ? 'COMPLETADA' : 'PENDIENTE',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                task.isCompleted ? Icons.refresh : Icons.check_circle_outline,
                color: task.isCompleted ? Colors.orange : Colors.green,
                size: 28,
              ),
              onPressed: onTaskToggle,
            ),
            onTap: onTaskTap,
          ),
          if (!task.isCompleted)
            InkWell(
              onTap: onTaskToggle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Marcar como completada',
                        style: TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (task.isCompleted)
            InkWell(
              onTap: onTaskToggle,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.refresh, color: Colors.orange, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Marcar como pendiente',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
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