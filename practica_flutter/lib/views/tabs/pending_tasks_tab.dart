import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import 'all_tasks_tab.dart';
import '../../utils/localizations.dart';

class PendingTasksTab extends StatelessWidget {
  const PendingTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        viewModel.setFilter('pending');
        final tasks = viewModel.tasks;
        
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.green.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  i18n.text('no_pending_tasks'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  i18n.text('all_tasks_completed'),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
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