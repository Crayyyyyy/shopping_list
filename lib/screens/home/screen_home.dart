import 'package:flutter/material.dart';
import 'package:shopping_list/objects/item.dart';
import 'package:shopping_list/screens/new_item/screen_new_item.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final List<Item> items = [
    Item(title: "Pork", quantity: 4, category: Category.meat),
    Item(title: "Chicken", quantity: 5, category: Category.meat),
    Item(title: "Beef", quantity: 8, category: Category.meat),
    Item(title: "Salmon", quantity: 13, category: Category.fish),
    Item(title: "Tuna", quantity: 10, category: Category.fish),
    Item(title: "Broccoli", quantity: 2, category: Category.vegetable),
    Item(title: "Carrot", quantity: 2, category: Category.vegetable),
    Item(title: "Potato", quantity: 1, category: Category.vegetable),
    Item(title: "Tomato", quantity: 3, category: Category.vegetable),
  ];

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

  void routeEditItem(BuildContext context, Item item) async {
    int index = items.indexOf(item);
    items.remove(item);
    Item? temp = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScreenNewItem.edit(itemForm: item);
        },
      ),
    );

    if (temp != null) {
      setState(() {
        items.insert(index, temp);
      });
    } else {
      items.insert(index, item);
    }
  }

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
            for (Item item in items)
              ItemTile(
                item: item,
                longPress: routeEditItem,
              ),
          ],
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item, required this.longPress});

  final Function(BuildContext, Item) longPress;

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
        onLongPress: () {
          longPress(context, item);
        },
        leading: Container(
          width: 20,
          height: 20,
          color: categoryColors[item.category],
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Text('${item.quantity} x'),
      ),
    );
  }
}
