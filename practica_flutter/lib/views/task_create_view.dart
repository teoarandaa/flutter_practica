// Importaciones necesarias para la vista de creación de tareas
// Material Design para la interfaz de usuario
import 'package:flutter/material.dart';
// Provider para la gestión del estado de la aplicación
import 'package:provider/provider.dart';
// Modelos de datos
import '../models/task.dart';
import '../models/category.dart';
// ViewModel para la gestión de la lista de tareas
import '../viewmodels/task_list_viewmodel.dart';
// Paquete para generar IDs únicos
import 'package:uuid/uuid.dart';
// Utilidades para la internacionalización
import '../utils/localizations.dart';
// Servicio de idioma para actualizar la interfaz
import '../services/language_service.dart';

/// Widget que permite crear una nueva tarea.
/// 
/// Este widget proporciona un formulario completo con los siguientes campos:
/// - Título: Campo de texto obligatorio
/// - Descripción: Campo de texto multilínea opcional
/// - Fecha de vencimiento: Selector de fecha con calendario
/// - Categoría: Selector desplegable con iconos y colores
/// - Prioridad: Selector visual con tres niveles (baja, media, alta)
/// 
/// El widget utiliza StatefulWidget para manejar el estado del formulario
/// y gestionar las interacciones del usuario.
class TaskCreateView extends StatefulWidget {
  const TaskCreateView({super.key});

  @override
  State<TaskCreateView> createState() => _TaskCreateViewState();
}

class _TaskCreateViewState extends State<TaskCreateView> {
  // Controladores para los campos de texto
  // Estos controladores permiten acceder y modificar el contenido de los campos
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Variables de estado para los campos seleccionables
  // Estas variables mantienen el estado actual de las selecciones del usuario
  late DateTime _selectedDate;      // Fecha de vencimiento seleccionada
  late String _selectedCategory;    // ID de la categoría seleccionada
  int _selectedPriority = 1;        // Nivel de prioridad (1: baja, 2: media, 3: alta)
  
  @override
  void initState() {
    super.initState();
    // Inicialización de valores por defecto
    // La fecha se establece a mañana para dar tiempo a completar la tarea
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    // Se selecciona la primera categoría disponible
    _selectedCategory = Categories.all.first.id;
  }
  
  @override
  void dispose() {
    // Limpieza de recursos cuando el widget se destruye
    // Es importante liberar los controladores para evitar fugas de memoria
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtención de las utilidades de internacionalización
    final i18n = AppLocalizations.of(context);
    // Forzar la escucha de cambios de idioma para actualizar la interfaz
    // Esto asegura que la UI se actualice cuando cambie el idioma
    Provider.of<LanguageService>(context);
    
    // Obtención del ViewModel para la gestión de tareas
    // Se usa listen: false porque no necesitamos reconstruir el widget cuando cambie la lista
    final taskListViewModel = Provider.of<TaskListViewModel>(context, listen: false);
    
    return Scaffold(
      // Barra superior con título y botón de guardar
      appBar: AppBar(
        title: Text(i18n.text('create_task')),
        actions: [
          // Botón de guardar en la barra superior
          // Al pulsarlo se ejecuta el método _saveTask
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveTask(i18n, taskListViewModel),
          ),
        ],
      ),
      // Cuerpo del formulario con scroll para adaptarse a diferentes tamaños de pantalla
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de título con borde y etiqueta
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: i18n.text('title'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Campo de descripción con múltiples líneas y borde
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
            // Selector de fecha personalizado
            _buildDatePicker(i18n),
            const SizedBox(height: 16),
            // Selector de categoría personalizado
            _buildCategoryDropdown(i18n),
            const SizedBox(height: 16),
            // Selector de prioridad personalizado
            _buildPrioritySelector(i18n),
          ],
        ),
      ),
    );
  }
  
  /// Construye el selector de fecha con un diseño personalizado.
  /// 
  /// Este widget muestra la fecha actual seleccionada y permite al usuario
  /// seleccionar una nueva fecha mediante un calendario nativo.
  /// 
  /// @param i18n Instancia de AppLocalizations para las traducciones
  Widget _buildDatePicker(AppLocalizations i18n) {
    return InkWell(
      onTap: () async {
        // Muestra el selector de fecha nativo
        // Permite seleccionar fechas desde hoy hasta un año en el futuro
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
  
  /// Construye el selector de categoría con un diseño personalizado.
  /// 
  /// Este widget muestra un menú desplegable con todas las categorías disponibles,
  /// cada una con su icono y color correspondiente.
  /// 
  /// @param i18n Instancia de AppLocalizations para las traducciones
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
  
  /// Construye el selector de prioridad con tres opciones: baja, media y alta.
  /// 
  /// Este widget muestra tres opciones visuales para seleccionar la prioridad
  /// de la tarea, cada una con su propio color y estilo.
  /// 
  /// @param i18n Instancia de AppLocalizations para las traducciones
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
  
  /// Construye una opción individual de prioridad con su propio estilo y comportamiento.
  /// 
  /// Este widget representa una opción de prioridad con:
  /// - Un icono de bandera
  /// - Un texto descriptivo
  /// - Un estilo visual que cambia según si está seleccionada o no
  /// 
  /// @param priority Nivel de prioridad (1: baja, 2: media, 3: alta)
  /// @param label Texto descriptivo de la prioridad
  /// @param color Color asociado a la prioridad
  /// @param i18n Instancia de AppLocalizations para las traducciones
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
  
  /// Guarda la nueva tarea con los datos del formulario.
  /// 
  /// Este método:
  /// 1. Valida que el título no esté vacío
  /// 2. Genera un ID único para la tarea
  /// 3. Crea una nueva tarea con los datos del formulario
  /// 4. Añade la tarea al ViewModel
  /// 5. Muestra un mensaje de confirmación
  /// 6. Vuelve a la pantalla anterior
  /// 
  /// @param i18n Instancia de AppLocalizations para las traducciones
  /// @param viewModel ViewModel para la gestión de tareas
  void _saveTask(AppLocalizations i18n, TaskListViewModel viewModel) {
    // Validación del título
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(i18n.text('enter_title'))),
      );
      return;
    }
    
    // Generar un ID único para la nueva tarea
    final uuid = const Uuid();
    
    // Crear la nueva tarea con los datos del formulario
    final newTask = Task(
      id: uuid.v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      category: _selectedCategory,
      priority: _selectedPriority,
    );
    
    // Añadir la tarea al ViewModel
    viewModel.addTask(newTask);
    
    // Mostrar mensaje de confirmación con el título de la tarea creada
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${i18n.text("task_created")}: ${newTask.title}')),
    );
    
    // Volver a la pantalla anterior
    Navigator.pop(context);
  }
} 