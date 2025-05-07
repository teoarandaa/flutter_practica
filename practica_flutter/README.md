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
│   ├── app_theme.dart # Definición del tema
│   └── theme_provider.dart # Proveedor de tema
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

## Capturas de pantalla de la UI

**🏠Home:**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 34 54" src="https://github.com/user-attachments/assets/3e839638-b902-41f9-b02b-172a8be94724" />

**🔄Pendiente**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 35 13" src="https://github.com/user-attachments/assets/261cc52c-979b-40a7-bef3-6ae30c4ffa9a" />

**✅Completado**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 35 23" src="https://github.com/user-attachments/assets/a4ef05d0-7a01-4541-b612-7397c8057159" />

**🧭Menú lateral**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 35 33" src="https://github.com/user-attachments/assets/6b5e9c29-df3f-4037-9ee1-c15283e09a24" />

**💼Trabajo**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 35 47" src="https://github.com/user-attachments/assets/60281342-c472-406d-8313-c69d1578ab6d" />

**👤Personal**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 35 59" src="https://github.com/user-attachments/assets/ba8defd5-625d-4dae-86c7-adbc32d4681d" />

**✏️Estudio**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 36 12" src="https://github.com/user-attachments/assets/43311930-82f1-4b01-8e1f-febac1e64257" />

**⛑️Salud**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 36 57" src="https://github.com/user-attachments/assets/ab976159-4a26-4132-a576-2a4375ab755e" />

**🛒Compras**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 37 10" src="https://github.com/user-attachments/assets/34dbd8b4-c1aa-4119-af55-878c8b20c604" />

**⚙️Ajustes**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 37 24" src="https://github.com/user-attachments/assets/3fe79c47-4f13-43bf-bddc-ca74771e7d0f" />

**🔎View de una tarea en detalle**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 38 30" src="https://github.com/user-attachments/assets/89fed853-c048-4c81-bcd9-a3541b44b13e" />

**🛠️View de creació de tareas**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 37 41" src="https://github.com/user-attachments/assets/2593cc3c-f545-453a-9978-04aed10f1f3e" />

**🧷View de edición de tareas**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 38 53" src="https://github.com/user-attachments/assets/c60e5dd6-9f6b-41a6-82db-a8c1044371db" />

**🗑️View de eliminación de una tarea**
<img width="1512" alt="Captura de pantalla 2025-05-07 a las 16 39 32" src="https://github.com/user-attachments/assets/4ec1b7c5-d199-4da8-8ab8-30ebcde5b99a" />
