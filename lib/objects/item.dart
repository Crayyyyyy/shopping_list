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

Category? getEnumFromString(String categoryName) {
  for (Category category in Category.values) {
    if (category.toString().split('.').last == categoryName) {
      return category;
    }
  }
  return null;
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
    this.id,
    this.color = Colors.black,
  });

  String title;
  String? id;
  int quantity;
  Color color;
  Category category;

  set setID(String newID) {
    id = newID;
  }

  set setTitle(String newTitle) {
    title = newTitle;
  }

  set setQuantity(int newQuantity) {
    quantity = newQuantity;
  }

  set setCategory(Category newCategory) {
    category = newCategory;
  }
}
