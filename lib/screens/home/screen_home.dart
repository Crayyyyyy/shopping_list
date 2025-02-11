import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/objects/item.dart';
import 'package:shopping_list/screens/new_item/screen_form_item.dart';
import 'package:http/http.dart' as http;

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<Item> items = [];
  bool isLoading = true;
  String? _error;
  String urlFirebase =
      'shopify-5803a-default-rtdb.europe-west1.firebasedatabase.app';

  @override
  void initState() {
    super.initState();
    fetchShoppingList();
  }

  Future<void> fetchShoppingList() async {
    isLoading = true;
    Uri url = Uri.https(urlFirebase, "shopping-list.json");
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      setState(() {
        _error = "Error occured while fetching data";
      });
    }
    if (response.body == "null") {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final Map<String, dynamic> extractedData = json.decode(response.body);
    List<Item> temp = [];

    for (var item in extractedData.entries) {
      Item itemTemp = Item(
        id: item.key,
        title: item.value["title"],
        quantity: item.value["quantity"],
        category:
            getEnumFromString(item.value?["category"]) ?? Category.vegetable,
      );
      temp.add(itemTemp);
    }
    setState(() {
      isLoading = false;
      items = temp;
    });
  }

  void routeCreateNewItem(BuildContext context) async {
    Item temp = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScreenFormItem();
        },
      ),
    );
    setState(() {
      items.add(temp);
    });
  }

  void routeEditItem(BuildContext context, Item item) async {
    int index = items.indexOf(item);
    items.remove(item);
    Item? temp = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScreenFormItem.edit(itemForm: item);
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

  void removeItem(Item item) async {
    int index = items.indexOf(item);
    setState(() {
      items.remove(item);
    });

    Uri url = Uri.https(urlFirebase, 'shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        items.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loading = Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(),
      ),
    );

    Widget shoppingList = SingleChildScrollView(
      child: Column(
        children: [
          for (Item item in items)
            ItemTile(
              item: item,
              longPress: routeEditItem,
              dismissed: removeItem,
            ),
        ],
      ),
    );

    Widget errorMessage = Center(
      child: Text(_error ?? "Some other error occured."),
    );

    Widget emptyList = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_neutral_rounded,
            size: 96,
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer
                .withValues(alpha: 0.5),
          ),
          Text(
            "No items in shopping list",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.4),
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Tap on '+' in top right to add an item.",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer
                      .withOpacity(0.4),
                ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );

    Widget floatingActionButton = IconButton(
      onPressed: () {
        routeCreateNewItem(context);
      },
      icon: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Icon(
          Icons.add,
          size: 48,
        ),
      ),
    );

    Widget content = _error == null
        ? isLoading
            ? loading
            : items.isEmpty
                ? emptyList
                : shoppingList
        : errorMessage;

    return Scaffold(
      floatingActionButton: floatingActionButton,
      appBar: AppBar(
        title: Text("Shopify"),
      ),
      body: content,
    );
  }
}

class ItemTile extends StatelessWidget {
  const ItemTile(
      {super.key,
      required this.item,
      required this.longPress,
      required this.dismissed});

  final Function(BuildContext, Item) longPress;
  final Function(Item item) dismissed;

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        dismissed(item);
      },
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
        onTap: () {
          print(item.id);
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
        trailing: Text('${item.quantity}x'),
      ),
    );
  }
}
