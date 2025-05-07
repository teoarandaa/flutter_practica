import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_detail_viewmodel.dart';
import '../models/category.dart';
import 'task_edit_view.dart';
import '../utils/localizations.dart';

/// Widget que muestra los detalles de una tarea específica.
/// Permite ver toda la información de la tarea, marcarla como completada/pendiente,
/// editarla o eliminarla.
class TaskDetailView extends StatefulWidget {
  final String taskId;
  
  const TaskDetailView({super.key, required this.taskId});

  @override
  State<TaskDetailView> createState() => _TaskDetailViewState();
}

class _TaskDetailViewState extends State<TaskDetailView> {
  // Future para manejar la carga inicial de la tarea
  late Future<void> _loadTaskFuture;
  
  @override
  void initState() {
    super.initState();
    // Inicializar la carga de la tarea al crear el widget
    _loadTaskFuture = _loadTask();
  }
  
  /// Carga la tarea desde el ViewModel
  /// Espera a que el frame termine de construirse para evitar problemas de contexto
  Future<void> _loadTask() async {
    // Esperar a que el frame termine de construirse
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    // Cargar la tarea usando el ViewModel
    final viewModel = Provider.of<TaskDetailViewModel>(context, listen: false);
    viewModel.loadTask(widget.taskId);
  }
  
  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.text('task_details')),
        actions: [
          // Botón de eliminar que solo se muestra si la tarea existe
          Consumer<TaskDetailViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.task == null) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmation(context, i18n);
                },
              );
            },
          ),
        ],
      ),
      // FutureBuilder para manejar el estado de carga inicial
      body: FutureBuilder(
        future: _loadTaskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          // Consumer para reconstruir la UI cuando cambia la tarea
          return Consumer<TaskDetailViewModel>(
            builder: (context, viewModel, child) {
              final task = viewModel.task;
              
              if (task == null) {
                return Center(
                  child: Text(i18n.text('task_not_found')),
                );
              }
              
              // Obtener la categoría correspondiente a la tarea
              final category = Categories.all.firstWhere(
                (cat) => cat.id == task.category,
                orElse: () => Categories.all.first,
              );
              
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Indicador de estado de la tarea (completada/pendiente)
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
                    // Encabezado con título y categoría
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
                    // Información de fecha de vencimiento
                    _buildInfoCard(i18n.text('due_date'), '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}', Icons.calendar_today, context),
                    const SizedBox(height: 16),
                    // Información de prioridad
                    _buildInfoCard(i18n.text('priority'), _getPriorityText(task.priority, i18n), Icons.flag, context, color: _getPriorityColor(task.priority)),
                    const SizedBox(height: 24),
                    // Descripción de la tarea
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
                    // Botón para marcar como completada/pendiente
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
              );
            },
          );
        },
      ),
      // Botón flotante para editar la tarea
      floatingActionButton: Consumer<TaskDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.task == null) return const SizedBox.shrink();
          
          return FloatingActionButton(
            heroTag: "editTask",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskEditView(task: viewModel.task!),
                ),
              ).then((_) {
                // Recargar la tarea después de la edición
                viewModel.loadTask(widget.taskId);
              });
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.edit),
          );
        },
      ),
    );
  }
  
  /// Construye una tarjeta de información con un título, valor e icono
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
  
  /// Obtiene el color correspondiente a la prioridad de la tarea
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

  /// Obtiene el texto traducido correspondiente a la prioridad de la tarea
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

  /// Muestra un diálogo de confirmación antes de eliminar la tarea
  void _showDeleteConfirmation(BuildContext context, AppLocalizations i18n) {
    final viewModel = Provider.of<TaskDetailViewModel>(context, listen: false);
    
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
} 