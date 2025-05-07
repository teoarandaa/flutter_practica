// Importaciones necesarias para la vista principal de la aplicación
// Material Design para la interfaz de usuario
import 'package:flutter/material.dart';
// Provider para la gestión del estado de la aplicación
import 'package:provider/provider.dart';
// Modelos de datos
import '../models/category.dart';
// ViewModel para la gestión de la lista de tareas
import '../viewmodels/task_list_viewmodel.dart';
// Pestañas para diferentes vistas de tareas
import 'tabs/all_tasks_tab.dart';
import 'tabs/pending_tasks_tab.dart';
import 'tabs/completed_tasks_tab.dart';
// Vistas adicionales
import 'task_create_view.dart';
import 'category_tasks_view.dart';
import 'settings_view.dart';
// Utilidades para la internacionalización
import '../utils/localizations.dart';
// Servicio de idioma para actualizar la interfaz
import '../services/language_service.dart';

/// Widget que representa la vista principal de la aplicación.
/// 
/// Esta vista implementa:
/// - Un sistema de pestañas para mostrar diferentes listas de tareas
/// - Un menú lateral (drawer) con acceso a categorías y configuración
/// - Un botón flotante para crear nuevas tareas
/// 
/// Utiliza StatefulWidget con SingleTickerProviderStateMixin para manejar
/// el controlador de pestañas y sus animaciones.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  // Controlador para gestionar las pestañas y sus animaciones
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    // Inicialización del controlador con 3 pestañas
    _tabController = TabController(length: 3, vsync: this);
    
    // Agregar un listener para detectar cambios de pestaña
    // Esto permite actualizar el filtro de tareas cuando cambia la pestaña
    _tabController.addListener(_handleTabSelection);
  }
  
  /// Maneja el cambio de selección de pestaña.
  /// 
  /// Este método se ejecuta cuando el usuario cambia de pestaña y:
  /// 1. Verifica si el cambio es real (no solo una animación)
  /// 2. Actualiza el filtro en el ViewModel según la pestaña seleccionada:
  ///    - Pestaña 0: Todas las tareas
  ///    - Pestaña 1: Tareas pendientes
  ///    - Pestaña 2: Tareas completadas
  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      // Obtener el viewModel y actualizar según la pestaña seleccionada
      final viewModel = Provider.of<TaskListViewModel>(context, listen: false);
      switch (_tabController.index) {
        case 0:
          viewModel.setFilter('all');
          break;
        case 1:
          viewModel.setFilter('pending');
          break;
        case 2:
          viewModel.setFilter('completed');
          break;
      }
    }
  }

  @override
  void dispose() {
    // Limpieza de recursos cuando el widget se destruye
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtención de las utilidades de internacionalización
    final i18n = AppLocalizations.of(context);
    
    // Forzar una escucha explícita al servicio de idioma
    // Esto asegura que la UI se actualice cuando cambie el idioma
    Provider.of<LanguageService>(context);
    
    // Obtener el viewModel compartido desde el Provider
    final viewModel = Provider.of<TaskListViewModel>(context);
    
    return Scaffold(
      // Barra superior con título y pestañas
      appBar: AppBar(
        title: Text(i18n.text('app_name')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.list), text: i18n.text('all')),
            Tab(icon: const Icon(Icons.pending), text: i18n.text('pending')),
            Tab(icon: const Icon(Icons.done_all), text: i18n.text('completed')),
          ],
        ),
      ),
      // Menú lateral con categorías y configuración
      drawer: _buildDrawer(viewModel),
      // Contenido principal con las diferentes vistas de tareas
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllTasksTab(),
          PendingTasksTab(),
          CompletedTasksTab(),
        ],
      ),
      // Botón flotante para crear nuevas tareas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Usar un microtask para evitar excepciones de Provider durante la navegación
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TaskCreateView()),
            ).then((_) => viewModel.refreshTasks());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Construye el menú lateral (drawer) de la aplicación.
  /// 
  /// El drawer incluye:
  /// - Encabezado con logo y nombre de la aplicación
  /// - Enlace a la vista principal
  /// - Lista de categorías con sus iconos y colores
  /// - Enlace a la configuración
  /// 
  /// @param viewModel El ViewModel para la gestión de tareas
  Widget _buildDrawer(TaskListViewModel viewModel) {
    final i18n = AppLocalizations.of(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Encabezado del drawer con logo y título
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.task_alt, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  i18n.text('app_name'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  i18n.text('organize_tasks'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Enlace a la vista principal
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          // Título de la sección de categorías
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
            child: Text(
              i18n.text('category'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          // Lista de categorías generada dinámicamente
          ...Categories.all.map((category) {
            return ListTile(
              leading: Icon(category.icon, color: category.color),
              title: Text(i18n.text(category.id)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryTasksView(category: category),
                  ),
                ).then((_) => viewModel.refreshTasks());
              },
            );
          }),
          const Divider(),
          // Enlace a la configuración
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(i18n.text('settings')),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsView()),
              );
            },
          ),
        ],
      ),
    );
  }
} 