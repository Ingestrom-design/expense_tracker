import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

part 'expense.g.dart'; // Required for Hive to generate the adapter

final formatter = DateFormat.yMd();
const uuid = Uuid();

const categoryIcons = {
  Category.food: Icons.lunch_dining_outlined,
  Category.leisure: Icons.movie_creation_outlined,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work_outline
};

@HiveType(typeId: 0) // Unique typeId for the Expense class
enum Category {
  @HiveField(0)
  food,
  @HiveField(1)
  leisure,
  @HiveField(2)
  travel,
  @HiveField(3)
  work,
}

@HiveType(typeId: 1) // Unique typeId for the Expense class
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  Expense({
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
  }) : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }

  // JSON serialization for debugging (optional)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      title: json['title'] as String,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      category: Category.values.firstWhere(
        (category) => category.toString().split('.')[1] == json['category'],
        orElse: () => Category.food, // Default to Category.food if not found
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.toString().split('.')[1],
    };
  }
}
class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}