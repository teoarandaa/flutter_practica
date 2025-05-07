import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import 'all_tasks_tab.dart';
import '../../utils/localizations.dart';

/// Widget que muestra la pestaña de tareas completadas.
/// 
/// Esta pestaña muestra una lista de todas las tareas que han sido marcadas
/// como completadas. Implementa AutomaticKeepAliveClientMixin para mantener
/// su estado cuando se cambia entre pestañas.
/// 
/// Características principales:
/// - Filtra y muestra solo las tareas completadas
/// - Permite navegar al detalle de cada tarea
/// - Permite marcar tareas como pendientes nuevamente
/// - Mantiene su estado al cambiar entre pestañas
/// - Muestra un mensaje informativo cuando no hay tareas completadas
class CompletedTasksTab extends StatefulWidget {
  const CompletedTasksTab({super.key});

  @override
  State<CompletedTasksTab> createState() => _CompletedTasksTabState();
}

/// Estado del widget CompletedTasksTab.
/// 
/// Gestiona el ciclo de vida de la pestaña y mantiene su estado entre cambios
/// de pestaña usando AutomaticKeepAliveClientMixin. Se encarga de:
/// - Inicializar y mantener el filtro de tareas completadas
/// - Mostrar una lista de tareas completadas
/// - Mostrar un mensaje cuando no hay tareas completadas
/// - Gestionar la navegación al detalle de tareas
/// - Controlar el estado de completado de las tareas
class _CompletedTasksTabState extends State<CompletedTasksTab> with AutomaticKeepAliveClientMixin {
  /// Indica si el widget ha sido inicializado.
  /// 
  /// Se utiliza para controlar la inicialización del filtro y evitar
  /// múltiples inicializaciones innecesarias.
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
        
        // Mostrar mensaje cuando no hay tareas completadas
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
        
        // Construir la lista de tareas completadas
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            // Obtener la categoría correspondiente a la tarea
            final category = Categories.all.firstWhere(
              (cat) => cat.id == task.category,
              orElse: () => Categories.all.first,
            );
            
            // Renderizar cada tarea usando el widget TaskListItem
            return TaskListItem(
              task: task,
              category: category,
              onTaskTap: () {
                // Navegar a la vista de detalle de la tarea
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetailView(taskId: task.id),
                  ),
                ).then((_) {
                  // Actualizar la lista al volver de la vista de detalle
                  viewModel.refreshTasks();
                });
              },
              onTaskToggle: () {
                // Cambiar el estado de completado de la tarea
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