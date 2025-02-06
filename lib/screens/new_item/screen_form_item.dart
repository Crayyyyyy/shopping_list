import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/objects/item.dart';
import 'package:http/http.dart' as http;

class ScreenFormItem extends StatefulWidget {
  ScreenFormItem({super.key})
      : itemForm = Item(title: "", quantity: 1, category: Category.fruit),
        isEditing = false;

  ScreenFormItem.edit({super.key, required this.itemForm}) : isEditing = true;

  bool isEditing;
  Item itemForm;

  @override
  State<ScreenFormItem> createState() => _ScreenFormItemState();
}

class _ScreenFormItemState extends State<ScreenFormItem> {
  bool isSending = false;
  final _formKey = GlobalKey<FormState>();

  void _saveItem(BuildContext context) async {
    setState(() {
      isSending = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Uri url = Uri.https(
          'shopify-5803a-default-rtdb.europe-west1.firebasedatabase.app',
          "shopping-list.json");

      if (!widget.isEditing) {
        try {
          final response = await http.post(
            url,
            headers: {"Content-Type": "application/json"},
            body: json.encode(
              {
                "title": widget.itemForm.title,
                "quantity": widget.itemForm.quantity,
                "category": widget.itemForm.category.name,
              },
            ),
          );
          Map<String, dynamic> resDate = json.decode(response.body);
          widget.itemForm.id = resDate["name"];
        } catch (e) {
          print('Error occured: $e');
        }
      } else {
        try {
          final response = await http.patch(
            url,
            body: jsonEncode(
              {
                '${widget.itemForm.id}': {
                  "title": widget.itemForm.title,
                  "quantity": widget.itemForm.quantity,
                  "category": widget.itemForm.category.name,
                }
              },
            ),
            headers: {"Content-Type": "application/json"},
          );
        } catch (e) {
          print("Error: $e");
        }
      }

      if (!context.mounted) return;
      Navigator.of(context).pop(widget.itemForm);
    }
  }

  late Category categoryPicked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? "Edit Item" : "New Item"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.itemForm.title,
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
                  widget.itemForm.title = value;
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
                      initialValue: widget.itemForm.quantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0)
                          return "Quantity must be positive number";
                      },
                      onChanged: (value) {
                        if (value == null) return;
                        dynamic temp = int.tryParse(value);
                        widget.itemForm.quantity = temp;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: widget.itemForm.category,
                      onChanged: (value) {
                        widget.itemForm.category = value!;
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
                    onPressed: isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () {
                            _saveItem(context);
                          },
                    child: isSending
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(),
                          )
                        : Text(widget.isEditing ? "Edit" : "Add item"),
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
