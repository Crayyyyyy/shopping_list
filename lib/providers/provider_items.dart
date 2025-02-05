import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/data/data_dummy.dart';

final provideItems = Provider((ref) {
  return dummyItems;
});
