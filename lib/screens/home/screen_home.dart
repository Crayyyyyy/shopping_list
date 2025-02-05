import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/objects/item.dart';
import 'package:shopping_list/providers/provider_items.dart';

class ScreenHome extends ConsumerWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(provideItems);

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopify"),
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
    return ListTile(
      leading: Container(
          width: 20, height: 20, color: categoryColors[item.category]),
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text('${item.price} €'),
    );
  }
}
