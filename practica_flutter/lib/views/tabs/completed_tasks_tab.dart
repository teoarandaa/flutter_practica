import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import 'all_tasks_tab.dart';
import '../../utils/localizations.dart';

class CompletedTasksTab extends StatefulWidget {
  const CompletedTasksTab({super.key});

  @override
  State<CompletedTasksTab> createState() => _CompletedTasksTabState();
}

class _CompletedTasksTabState extends State<CompletedTasksTab> with AutomaticKeepAliveClientMixin {
  bool _initialized = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
    // Siempre establecer el filtro al entrar en esta pestaña, no solo la primera vez
    Future.microtask(() => viewModel.setFilter('completed'));
    _initialized = true;
  }
  
  @override
  void didUpdateWidget(CompletedTasksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar el filtro cada vez que la pestaña se vuelva a mostrar
    final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
    Future.microtask(() => viewModel.setFilter('completed'));
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final i18n = AppLocalizations.of(context);
    
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
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
                Text(
                  i18n.text('no_completed_tasks'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  i18n.text('complete_some_tasks'),
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
  
  @override
  bool get wantKeepAlive => true;
} 