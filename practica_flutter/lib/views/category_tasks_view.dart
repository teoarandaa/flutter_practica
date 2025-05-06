import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../viewmodels/task_list_viewmodel.dart';
import 'task_detail_view.dart';
import 'task_create_view.dart';
import 'tabs/all_tasks_tab.dart';
import '../utils/localizations.dart';

class CategoryTasksView extends StatelessWidget {
  final Category category;
  
  const CategoryTasksView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    
    return ChangeNotifierProvider(
      create: (_) => TaskListViewModel(),
      child: Consumer<TaskListViewModel>(
        builder: (context, viewModel, child) {
          viewModel.setFilter(category.id);
          final tasks = viewModel.tasks;
          
          return Scaffold(
            appBar: AppBar(
              title: Text('${i18n.text(category.id)} ${i18n.text('tasks')}'),
              backgroundColor: category.color.withOpacity(0.8),
            ),
            body: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          size: 64,
                          color: category.color.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${i18n.text('no')} ${i18n.text(category.id)} ${i18n.text('tasks')} ${i18n.text('yet')}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TaskCreateView()),
                            ).then((_) => viewModel.refreshTasks());
                          },
                          icon: const Icon(Icons.add),
                          label: Text(i18n.text('add_task')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: category.color,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      
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
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskCreateView()),
                ).then((_) => viewModel.refreshTasks());
              },
              backgroundColor: category.color,
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
} 