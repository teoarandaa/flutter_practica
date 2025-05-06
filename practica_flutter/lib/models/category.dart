import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Predefined categories
class Categories {
  static final List<Category> all = [
    Category(
      id: '1',
      name: 'Work',
      icon: Icons.work,
      color: Colors.blue,
    ),
    Category(
      id: '2',
      name: 'Personal',
      icon: Icons.person,
      color: Colors.green,
    ),
    Category(
      id: '3',
      name: 'Study',
      icon: Icons.school,
      color: Colors.orange,
    ),
    Category(
      id: '4',
      name: 'Health',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    Category(
      id: '5',
      name: 'Shopping',
      icon: Icons.shopping_cart,
      color: Colors.purple,
    ),
  ];
} 