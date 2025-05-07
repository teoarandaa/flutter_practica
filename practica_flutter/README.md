# Gestor de Tareas

Una aplicación en Flutter para gestionar tareas diarias, implementando navegación jerárquica (Navigator), pestañas (TabController) y panel lateral (Drawer), siguiendo la arquitectura MVVM.

## Características

- **Arquitectura MVVM**: Clara separación entre interfaz de usuario (Vistas), lógica de negocio (ViewModels) y datos (Modelos).
- **Múltiples Tipos de Navegación**:
  - Navegación Jerárquica entre pantallas
  - Navegación por Pestañas para diferentes estados de tareas (todas, pendientes, completadas)
  - Navegación con Panel Lateral para secciones y categorías
- **Gestión Completa de Tareas**:
  - Crear nuevas tareas
  - Visualizar detalles de tareas
  - Editar tareas existentes
  - Eliminar tareas
  - Categorizar tareas (trabajo, personal, compras, salud, etc.)
  - Establecer prioridades (alta, media, baja)
  - Definir fechas de vencimiento
  - Marcar tareas como completadas/pendientes
- **Filtrado de Tareas**:
  - Por estado (completadas/pendientes)
  - Por categoría
- **Interfaz Moderna con Material Design**
- **Soporte para Múltiples Idiomas**

## Estructura del Proyecto

```
lib/
├── models/           # Modelos de datos
│   ├── task.dart     # Modelo de tarea
│   └── category.dart # Modelo de categoría
├── views/            # Componentes UI
│   ├── home_view.dart         # Vista principal
│   ├── task_create_view.dart  # Creación de tareas
│   ├── task_detail_view.dart  # Detalles de tarea
│   ├── task_edit_view.dart    # Edición de tareas
│   ├── category_tasks_view.dart # Tareas por categoría
│   ├── settings_view.dart     # Configuración
│   └── tabs/                  # Vistas de pestañas
│       ├── all_tasks_tab.dart    # Todas las tareas
│       ├── pending_tasks_tab.dart # Tareas pendientes
│       └── completed_tasks_tab.dart # Tareas completadas
├── viewmodels/       # Lógica de negocio
│   ├── task_list_viewmodel.dart  # ViewModel para listas de tareas
│   └── task_detail_viewmodel.dart # ViewModel para detalles de tarea
├── services/         # Servicios de datos
│   ├── task_service.dart     # Operaciones con tareas
│   └── language_service.dart # Gestión de idiomas
├── utils/            # Utilidades
│   └── localizations.dart # Gestión de traducciones
├── theme/            # Temas de la aplicación
│   └── app_theme.dart # Definición del tema
└── main.dart         # Punto de entrada
```

## Guía de Instalación

1. Clona el repositorio:
   ```
   git clone [URL del repositorio]
   ```
2. Navega al directorio del proyecto:
   ```
   cd practica_flutter
   ```
3. Instala las dependencias:
   ```
   flutter pub get
   ```
4. Ejecuta la aplicación:
   ```
   flutter run
   ```

## Arquitectura MVVM

Esta aplicación sigue la arquitectura MVVM (Modelo-Vista-ViewModel):

- **Modelos**: Definen las estructuras de datos (Task, Category)
  - `Task`: Representa una tarea con propiedades como título, descripción, fecha de vencimiento, categoría, prioridad y estado.
  - `Category`: Define las categorías disponibles para clasificar tareas.

- **Vistas**: Gestionan la interfaz de usuario y las interacciones
  - Pantallas principales para visualizar, crear y editar tareas
  - Componentes reutilizables para mostrar tareas

- **ViewModels**: Manejan la lógica de negocio y el estado
  - `TaskListViewModel`: Gestiona listas de tareas, filtrado y operaciones básicas
  - `TaskDetailViewModel`: Gestiona detalles y operaciones sobre una tarea específica

- **Servicios**: Manejan operaciones de datos
  - `TaskService`: Realiza operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre tareas
  - `LanguageService`: Gestiona la configuración de idioma

## Flujo de la Aplicación

1. **Pantalla Principal**: Muestra pestañas para todas las tareas, pendientes y completadas
2. **Panel Lateral**: Permite navegar entre categorías y configuración
3. **Creación de Tareas**: Formulario para añadir nuevas tareas
4. **Detalles de Tarea**: Muestra información detallada y opciones para editar o eliminar
5. **Edición de Tareas**: Modificación de tareas existentes

## Gestión del Estado

La aplicación utiliza el paquete `Provider` para la gestión del estado:
- Los ViewModels extienden `ChangeNotifier` para notificar a las vistas sobre cambios
- Las vistas utilizan `Consumer` y `Provider.of` para acceder y reaccionar a los cambios en los ViewModels

## Dependencias

- **provider**: ^6.1.1 - Para gestión del estado
- **uuid**: ^4.3.3 - Para generar identificadores únicos

## Características para Desarrolladores

Esta aplicación demuestra:
- Implementación del patrón MVVM en Flutter
- Múltiples patrones de navegación (jerárquica, pestañas, panel lateral)
- Gestión del estado con Provider
- Diseño de UI con componentes Material
- Internacionalización (i18n)
- Uso de widgets personalizados
- Validación de formularios

## Posibles Mejoras Futuras

- Sincronización con backend/nube
- Notificaciones para tareas próximas a vencer
- Temas claro/oscuro
- Vista de calendario
- Estadísticas de productividad
- Búsqueda y filtros avanzados

---
## Icono
<img width="399" alt="Captura de pantalla 2025-05-07 a las 16 20 49" src="https://github.com/user-attachments/assets/3a8a0e61-a833-40af-8a0a-093ef8998900" />
