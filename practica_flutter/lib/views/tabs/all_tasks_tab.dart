import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/task_list_viewmodel.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../task_detail_view.dart';
import '../../utils/localizations.dart';

/// Widget que muestra la pestaña de todas las tareas.
/// 
/// Esta pestaña muestra una lista de todas las tareas disponibles, independientemente
/// de su estado de completado. Implementa AutomaticKeepAliveClientMixin para mantener
/// su estado cuando se cambia entre pestañas.
/// 
/// Características principales:
/// - Muestra todas las tareas sin filtrar por estado
/// - Permite navegar al detalle de cada tarea
/// - Permite marcar/desmarcar tareas como completadas
/// - Mantiene su estado al cambiar entre pestañas
class AllTasksTab extends StatefulWidget {
  const AllTasksTab({super.key});

  @override
  State<AllTasksTab> createState() => _AllTasksTabState();
}

/// Estado del widget AllTasksTab.
/// 
/// Gestiona el ciclo de vida de la pestaña y mantiene su estado entre cambios
/// de pestaña usando AutomaticKeepAliveClientMixin.
/// 
/// Responsabilidades:
/// - Inicializar y mantener el filtro de todas las tareas
/// - Gestionar la actualización de la lista de tareas
/// - Manejar la navegación al detalle de tareas
/// - Controlar el estado de completado de las tareas
class _AllTasksTabState extends State<AllTasksTab> with AutomaticKeepAliveClientMixin {
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
    Future.microtask(() => viewModel.setFilter('all'));
    _initialized = true;
  }
  
  @override
  void didUpdateWidget(AllTasksTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar el filtro cada vez que la pestaña se vuelva a mostrar
    final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
    Future.microtask(() => viewModel.setFilter('all'));
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final i18n = AppLocalizations.of(context);
    
    return Consumer<TaskListViewModel>(
      builder: (context, viewModel, child) {
        final tasks = viewModel.tasks;
        
        // Mostrar mensaje cuando no hay tareas
        if (tasks.isEmpty) {
          return Center(
            child: Text(i18n.text('no_tasks')),
          );
        }
        
        // Construir la lista de tareas
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

/// Widget que representa un elemento individual de la lista de tareas.
/// 
/// Muestra la información de una tarea en una tarjeta, incluyendo:
/// - Icono y color de la categoría
/// - Título y descripción
/// - Fecha de vencimiento
/// - Nivel de prioridad
/// - Estado de completado
/// - Botones para marcar como completada/pendiente
/// 
/// Características:
/// - Diseño responsivo que se adapta al contenido
/// - Indicadores visuales de estado y prioridad
/// - Interacciones para ver detalles y cambiar estado
/// - Soporte para internacionalización
class TaskListItem extends StatelessWidget {
  /// La tarea a mostrar.
  /// 
  /// Contiene toda la información necesaria para mostrar la tarea,
  /// incluyendo título, descripción, fecha, categoría y estado.
  final Task task;
  
  /// La categoría de la tarea.
  /// 
  /// Define el icono y color que se mostrarán junto a la tarea.
  final Category category;
  
  /// Callback que se ejecuta al tocar la tarea.
  /// 
  /// Navega a la vista de detalle de la tarea.
  final VoidCallback onTaskTap;
  
  /// Callback que se ejecuta al cambiar el estado de completado.
  /// 
  /// Alterna el estado de completado de la tarea.
  final VoidCallback onTaskToggle;

  const TaskListItem({
    super.key,
    required this.task,
    required this.category,
    required this.onTaskTap,
    required this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    
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
                        _getPriorityText(task.priority, i18n),
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
                        task.isCompleted ? i18n.text('task_completed') : i18n.text('task_pending'),
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
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        i18n.text('mark_as_completed'),
                        style: const TextStyle(color: Colors.green),
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
                    children: [
                      const Icon(Icons.refresh, color: Colors.orange, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        i18n.text('mark_as_pending'),
                        style: const TextStyle(color: Colors.orange),
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

  /// Obtiene el color correspondiente al nivel de prioridad.
  /// 
  /// [priority] - El nivel de prioridad (1-3).
  /// 
  /// Devuelve:
  /// - Rojo para prioridad alta (3)
  /// - Naranja para prioridad media (2)
  /// - Verde para prioridad baja (1)
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  /// Obtiene el texto traducido para el nivel de prioridad.
  /// 
  /// [priority] - El nivel de prioridad (1-3).
  /// [i18n] - El objeto de localización.
  /// 
  /// Devuelve el texto traducido correspondiente al nivel de prioridad:
  /// - "Alta" para prioridad 3
  /// - "Media" para prioridad 2
  /// - "Baja" para prioridad 1
  String _getPriorityText(int priority, AppLocalizations i18n) {
    switch (priority) {
      case 3:
        return i18n.text('high');
      case 2:
        return i18n.text('medium');
      default:
        return i18n.text('low');
    }
  }
} 