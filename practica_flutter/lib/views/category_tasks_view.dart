// Importaciones necesarias para la vista de tareas por categoría
// Material Design para la interfaz de usuario
import 'package:flutter/material.dart';
// Provider para la gestión del estado de la aplicación
import 'package:provider/provider.dart';
// Modelo de categoría para acceder a sus propiedades
import '../models/category.dart';
// ViewModel para la gestión de la lista de tareas
import '../viewmodels/task_list_viewmodel.dart';
// Vistas para mostrar detalles y crear tareas
import 'task_detail_view.dart';
import 'task_create_view.dart';
// Componente reutilizable para mostrar elementos de tarea
import 'tabs/all_tasks_tab.dart';
// Utilidades para la internacionalización
import '../utils/localizations.dart';

/// Widget que muestra la lista de tareas filtradas por una categoría específica.
/// 
/// Esta vista implementa:
/// - Una barra superior con el nombre de la categoría y su color
/// - Una lista de tareas filtradas por la categoría seleccionada
/// - Un estado vacío con icono y botón para crear tareas
/// - Un botón flotante para crear nuevas tareas
/// 
/// Utiliza StatelessWidget ya que no necesita mantener estado interno.
class CategoryTasksView extends StatelessWidget {
  /// La categoría seleccionada para filtrar las tareas
  final Category category;
  
  const CategoryTasksView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Obtención de las utilidades de internacionalización
    final i18n = AppLocalizations.of(context);
    // Obtención del ViewModel para gestionar las tareas
    final viewModel = Provider.of<TaskListViewModel>(context);
    
    // Aplicar el filtro de categoría al ViewModel
    viewModel.setFilter(category.id);
    // Obtener la lista de tareas filtradas
    final tasks = viewModel.tasks;
    
    return Scaffold(
      // Barra superior con título y color de la categoría
      appBar: AppBar(
        title: Text('${i18n.text(category.id)} ${i18n.text('tasks')}'),
        backgroundColor: category.color.withOpacity(0.8),
      ),
      // Cuerpo principal con estado vacío o lista de tareas
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icono de la categoría con color semitransparente
                  Icon(
                    category.icon,
                    size: 64,
                    color: category.color.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  // Mensaje indicando que no hay tareas
                  Text(
                    '${i18n.text('no')} ${i18n.text(category.id)} ${i18n.text('tasks')} ${i18n.text('yet')}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  // Botón para crear una nueva tarea
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navegar a la vista de creación de tareas
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
                
                // Construir cada elemento de la lista usando el componente reutilizable
                return TaskListItem(
                  task: task,
                  category: category,
                  // Navegar a los detalles de la tarea al hacer tap
                  onTaskTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailView(taskId: task.id),
                      ),
                    ).then((_) {
                      // Actualizar la lista al regresar
                      viewModel.refreshTasks();
                    });
                  },
                  // Cambiar el estado de completado de la tarea
                  onTaskToggle: () {
                    viewModel.toggleTaskCompletion(task.id);
                  },
                );
              },
            ),
      // Botón flotante para crear nuevas tareas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la vista de creación de tareas
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskCreateView()),
          ).then((_) => viewModel.refreshTasks());
        },
        backgroundColor: category.color,
        child: const Icon(Icons.add),
      ),
    );
  }
} 