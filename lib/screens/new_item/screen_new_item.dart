import 'package:flutter/material.dart';
import 'package:shopping_list/objects/item.dart';

class ScreenNewItem extends StatelessWidget {
  ScreenNewItem({super.key})
      : itemForm = Item(title: "", quantity: 1, category: Category.fruit),
        isEditing = false;

  ScreenNewItem.edit({super.key, required this.itemForm}) : isEditing = true;

  bool isEditing;
  Item itemForm;

  final _formKey = GlobalKey<FormState>();

  void _saveItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(itemForm);
    }
  }

  late Category categoryPicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Item" : "New Item"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: itemForm.title,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLength: 30,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1) return "Title is too short";
                },
                onChanged: (value) {
                  itemForm.title = value;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: itemForm.quantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0)
                          return "Quantity must be positive number";
                      },
                      onChanged: (value) {
                        dynamic temp = int.tryParse(value);
                        itemForm.quantity = temp;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: itemForm.category,
                      onChanged: (value) {
                        itemForm.category = value!;
                      },
                      decoration: InputDecoration(),
                      items: [
                        for (var cat in Category.values)
                          DropdownMenuItem(
                            value: cat,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: categoryColors[cat],
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  cat.name,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _saveItem(context);
                    },
                    child: Text(isEditing ? "Edit" : "Add item"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
