import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import 'all_tasks_tab.dart';
import '../../utils/localizations.dart';

/// Widget que muestra la lista de tareas pendientes.
/// 
/// Esta pestaña muestra todas las tareas que aún no han sido completadas.
/// Implementa AutomaticKeepAliveClientMixin para mantener su estado cuando
/// se cambia entre pestañas.
/// 
/// Características principales:
/// - Filtra y muestra solo las tareas pendientes
/// - Permite navegar al detalle de cada tarea
/// - Permite marcar tareas como completadas
/// - Mantiene su estado al cambiar entre pestañas
/// - Muestra un mensaje informativo cuando no hay tareas pendientes
class PendingTasksTab extends StatefulWidget {
  const PendingTasksTab({super.key});

  @override
  State<PendingTasksTab> createState() => _PendingTasksTabState();
}

/// Estado del widget PendingTasksTab.
/// 
/// Gestiona el ciclo de vida de la pestaña y mantiene su estado entre cambios
/// de pestaña usando AutomaticKeepAliveClientMixin. Se encarga de:
/// - Inicializar y mantener el filtro de tareas pendientes
/// - Mostrar una lista de tareas pendientes
/// - Mostrar un mensaje cuando no hay tareas pendientes
/// - Gestionar la navegación al detalle de tareas
/// - Controlar el estado de completado de las tareas
class _PendingTasksTabState extends State<PendingTasksTab> with AutomaticKeepAliveClientMixin {
  /// Indica si el widget ya ha sido inicializado.
  /// 
  /// Se utiliza para controlar la inicialización del filtro y evitar
  /// múltiples inicializaciones innecesarias.
  bool _initialized = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
    // Siempre establecer el filtro al entrar en esta pestaña, no solo la primera vez
    Future.microtask(() => viewModel.setFilter('pending'));
    _initialized = true;
  }
  
  @override
  void didUpdateWidget(PendingTasksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar el filtro cada vez que la pestaña se vuelva a mostrar
    final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
    Future.microtask(() => viewModel.setFilter('pending'));
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final i18n = AppLocalizations.of(context);
    
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        final tasks = viewModel.tasks;
        
        // Si no hay tareas pendientes, mostrar un mensaje informativo
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
        
        // Construir la lista de tareas pendientes
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