import 'package:flutter/material.dart';
import 'package:shopping_list/objects/item.dart';
import 'package:shopping_list/screens/new_item/screen_new_item.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final List<Item> items = [];

  void routeCreateNewItem(BuildContext context) async {
    Item? temp = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScreenNewItem();
        },
      ),
    );

    if (temp != null) {
      setState(() {
        items.add(temp);
      });
    }
  }

  void routeEditItem(BuildContext context, Item item) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopify"),
        actions: [
          IconButton(
            onPressed: () {
              routeCreateNewItem(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (Item item in items) ItemTile(item: item),
          ],
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.error,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < 2; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
      key: ObjectKey(item),
      child: ListTile(
        onLongPress: () {},
        leading: Container(
          width: 20,
          height: 20,
          color: categoryColors[item.category],
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Text('${item.quantity} x'),
      ),
    );
  }
}
