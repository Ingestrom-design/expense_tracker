import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/expense.dart';

var kColorScheme =
ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 147, 73, 9));
var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 45, 125, 5));

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientation([
  //  DeviceOrientation.portraitUp,
  //  ]).then(fn){

  // Initialize Hive
  await Hive.initFlutter();

  // Register the adapter for Expense and Category classes
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoryAdapter());

  // Open the box (ensure it's done only once here)
  await Hive.openBox<Expense>('expenses');

  runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const Expenses(),
    ),
  );
}
