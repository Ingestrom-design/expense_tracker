import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expense,
    required this.onRemoveExpense,
  });

  final List<Expense> expense;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    if (expense.isEmpty) {
      return Center(
        child: Text(
          'No expenses found, you can start by clicking the plus button.😊',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    // Sort expenses by date (newest first)
    List<Expense> sortedExpenses = List.from(expense)
      ..sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: sortedExpenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.5),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 32,
          ),
        ),
        key: ValueKey(sortedExpenses[index].id),
        onDismissed: (direction) {
          onRemoveExpense(sortedExpenses[index]);
        },
        child: ExpenseItem(sortedExpenses[index]),
      ),
    );
  }
}
