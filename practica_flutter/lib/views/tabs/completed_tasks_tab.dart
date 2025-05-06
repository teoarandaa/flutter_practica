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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_late_outlined,
                  size: 64,
                  color: Colors.orange.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  '¡No hay tareas completadas!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Completa algunas tareas y aparecerán aquí',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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