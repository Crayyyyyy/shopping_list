import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/screens/home/screen_home.dart';

void main() {
  runApp(ProviderScope(
    child: ShoppingApp(),
  ));
}

final kColorScheme = ColorScheme.fromSeed(seedColor: Color(0xFF1976D2));

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
          colorScheme: kColorScheme,
          scaffoldBackgroundColor: kColorScheme.surface,
          appBarTheme: AppBarTheme(
            backgroundColor: kColorScheme.primary,
            titleTextStyle: TextStyle(
              color: kColorScheme.onPrimary,
              fontSize: 26,
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
            iconSize: WidgetStateProperty.all(28.0),
            iconColor: WidgetStateProperty.all(kColorScheme.onPrimary),
          )),
          textTheme: TextTheme().copyWith(
            labelSmall: TextStyle(
              color: kColorScheme.primary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: kColorScheme.onSurface,
              fontSize: 18,
            ),
          )),
      title: "Shoppify",
      home: ScreenHome(),
    );
  }
}
