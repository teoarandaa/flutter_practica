import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../viewmodels/task_detail_viewmodel.dart';
import '../viewmodels/task_list_viewmodel.dart';
import '../utils/localizations.dart';
import '../services/language_service.dart';

/// Widget que permite editar una tarea existente.
/// Utiliza StatefulWidget para manejar el estado de los campos del formulario.
class TaskEditView extends StatefulWidget {
  final Task task;
  
  const TaskEditView({super.key, required this.task});

  @override
  State<TaskEditView> createState() => _TaskEditViewState();
}

class _TaskEditViewState extends State<TaskEditView> {
  // Controladores para los campos de texto
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  
  // Variables de estado para los campos seleccionables
  late DateTime _selectedDate;
  late String _selectedCategory;
  late int _selectedPriority;
  
  @override
  void initState() {
    super.initState();
    // Inicialización de los controladores y variables con los valores actuales de la tarea
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.dueDate;
    _selectedCategory = widget.task.category;
    _selectedPriority = widget.task.priority;
  }
  
  @override
  void dispose() {
    // Limpieza de los controladores cuando el widget se destruye
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    // Forzar la escucha de cambios de idioma para actualizar la interfaz
    Provider.of<LanguageService>(context);
    
    // Obtención de los ViewModels necesarios para la gestión de datos
    final detailViewModel = Provider.of<TaskDetailViewModel>(context, listen: false);
    final listViewModel = Provider.of<TaskListViewModel>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.text('edit_task')),
        actions: [
          // Botón de guardar en la barra superior
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveTask(i18n, detailViewModel, listViewModel),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: i18n.text('title'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de descripción con múltiples líneas
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: i18n.text('description'),
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            _buildDatePicker(i18n),
            const SizedBox(height: 16),
            _buildCategoryDropdown(i18n),
            const SizedBox(height: 16),
            _buildPrioritySelector(i18n),
          ],
        ),
      ),
    );
  }
  
  /// Construye el selector de fecha con un diseño personalizado
  Widget _buildDatePicker(AppLocalizations i18n) {
    return InkWell(
      onTap: () async {
        // Muestra el selector de fecha nativo
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i18n.text('due_date'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Construye el selector de categoría con un diseño personalizado
  Widget _buildCategoryDropdown(AppLocalizations i18n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCategory,
          items: Categories.all.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Row(
                children: [
                  Icon(category.icon, color: category.color),
                  const SizedBox(width: 16),
                  Text(i18n.text(category.id)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
            }
          },
        ),
      ),
    );
  }
  
  /// Construye el selector de prioridad con tres opciones: baja, media y alta
  Widget _buildPrioritySelector(AppLocalizations i18n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18n.text('priority'),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriorityOption(1, i18n.text('low'), Colors.green, i18n),
            const SizedBox(width: 8),
            _buildPriorityOption(2, i18n.text('medium'), Colors.orange, i18n),
            const SizedBox(width: 8),
            _buildPriorityOption(3, i18n.text('high'), Colors.red, i18n),
          ],
        ),
      ],
    );
  }
  
  /// Construye una opción individual de prioridad con su propio estilo y comportamiento
  Widget _buildPriorityOption(int priority, String label, Color color, AppLocalizations i18n) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPriority = priority;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedPriority == priority
                ? color.withOpacity(0.2)
                : Colors.transparent,
            border: Border.all(
              color: _selectedPriority == priority ? color : Colors.grey,
              width: _selectedPriority == priority ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Icon(
                Icons.flag,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: _selectedPriority == priority ? color : Colors.black,
                  fontWeight: _selectedPriority == priority
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Guarda los cambios realizados en la tarea
  /// Valida que el título no esté vacío y actualiza la tarea en los ViewModels
  void _saveTask(
    AppLocalizations i18n, 
    TaskDetailViewModel detailViewModel, 
    TaskListViewModel listViewModel
  ) {
    // Validación del título
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(i18n.text('enter_title'))),
      );
      return;
    }
    
    // Creación de una nueva tarea con los valores actualizados
    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      category: _selectedCategory,
      priority: _selectedPriority,
    );
    
    // Actualización de la tarea en los ViewModels
    detailViewModel.updateTask(updatedTask);
    listViewModel.refreshTasks(); // Actualización de la lista de tareas
    
    Navigator.pop(context);
  }
} 