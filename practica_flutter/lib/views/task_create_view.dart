import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../viewmodels/task_list_viewmodel.dart';
import 'package:uuid/uuid.dart';
import '../utils/localizations.dart';
import '../services/language_service.dart';

class TaskCreateView extends StatefulWidget {
  const TaskCreateView({super.key});

  @override
  State<TaskCreateView> createState() => _TaskCreateViewState();
}

class _TaskCreateViewState extends State<TaskCreateView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late DateTime _selectedDate;
  late String _selectedCategory;
  int _selectedPriority = 1; // Default to low priority
  
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _selectedCategory = Categories.all.first.id;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    // Forzar escucha de cambios de idioma
    Provider.of<LanguageService>(context);
    
    // Obtener referencia al viewModel fuera del método _saveTask
    final taskListViewModel = Provider.of<TaskListViewModel>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.text('create_task')),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _saveTask(i18n, taskListViewModel),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: i18n.text('title'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
  
  Widget _buildDatePicker(AppLocalizations i18n) {
    return InkWell(
      onTap: () async {
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
  
  void _saveTask(AppLocalizations i18n, TaskListViewModel viewModel) {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(i18n.text('enter_title'))),
      );
      return;
    }
    
    final uuid = const Uuid();
    
    final newTask = Task(
      id: uuid.v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDate,
      category: _selectedCategory,
      priority: _selectedPriority,
    );
    
    viewModel.addTask(newTask);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${i18n.text("task_created")}: ${newTask.title}')),
    );
    
    Navigator.pop(context);
  }
} 