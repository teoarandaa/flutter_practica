import 'package:flutter/material.dart';

/// Modelo que representa una categoría en la aplicación.
/// 
/// Esta clase define la estructura de datos para una categoría, incluyendo sus propiedades
/// visuales y de identificación. Las categorías son inmutables (todos los campos son final)
/// para garantizar la consistencia de los datos.
class Category {
  /// Identificador único de la categoría.
  /// 
  /// Este campo es requerido y debe ser único para cada categoría.
  /// Se utiliza como clave para identificar la categoría en la aplicación.
  final String id;

  /// Nombre de la categoría.
  /// 
  /// Representa el nombre legible de la categoría que se mostrará en la interfaz.
  final String name;

  /// Icono asociado a la categoría.
  /// 
  /// Define el icono visual que representa la categoría en la interfaz.
  /// Utiliza el tipo IconData de Flutter para definir el icono.
  final IconData icon;

  /// Color asociado a la categoría.
  /// 
  /// Define el color principal que se utilizará para representar
  /// visualmente la categoría en la interfaz.
  final Color color;

  /// Constructor de la clase Category.
  /// 
  /// Todos los parámetros son requeridos para crear una categoría válida.
  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// Clase que contiene las categorías predefinidas de la aplicación.
/// 
/// Esta clase proporciona una lista estática de categorías predefinidas
/// que se utilizan en toda la aplicación. Cada categoría tiene un ID único,
/// nombre, icono y color asociados.
class Categories {
  /// Lista de todas las categorías predefinidas disponibles en la aplicación.
  /// 
  /// Esta lista contiene las categorías base que se utilizan para clasificar
  /// las tareas. Cada categoría tiene propiedades visuales y de identificación
  /// específicas.
  static final List<Category> all = [
    Category(
      id: 'work',
      name: 'Work',
      icon: Icons.work,
      color: Colors.blue,
    ),
    Category(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person,
      color: Colors.green,
    ),
    Category(
      id: 'study',
      name: 'Study',
      icon: Icons.school,
      color: Colors.orange,
    ),
    Category(
      id: 'health',
      name: 'Health',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_cart,
      color: Colors.purple,
    ),
  ];
} 