import 'package:flutter/material.dart';

enum Category {
  meat,
  dairy,
  fish,
  vegetable,
  bakery,
  fruit,
  nuts,
  oil,
  grain,
}

Map<Category, Color> categoryColors = {
  Category.meat: Colors.red,
  Category.dairy: Colors.blue,
  Category.fish: Colors.teal,
  Category.vegetable: Colors.green,
  Category.bakery: Colors.brown,
  Category.fruit: Colors.orange,
  Category.nuts: Colors.purple,
  Category.oil: Colors.yellow,
  Category.grain: Colors.amber,
};

class Item {
  Item({
    required this.title,
    required this.quantity,
    required this.category,
    this.color = Colors.black,
  });

  String title;
  int quantity;
  Color color;
  Category category;
}
