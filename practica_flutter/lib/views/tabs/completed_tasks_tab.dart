import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import 'all_tasks_tab.dart';

class CompletedTasksTab extends StatelessWidget {
  const CompletedTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        viewModel.setFilter('completed');
        final tasks = viewModel.tasks;
        
        if (tasks.isEmpty) {
          return const Center(
            child: Text('No completed tasks yet. Complete some tasks!'),
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