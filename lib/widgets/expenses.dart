import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/charts/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  late Box<Expense> _expenseBox;

  @override
  void initState() {
    super.initState();
    _expenseBox = Hive.box<Expense>('expenses');
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expenseBox.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _expenseBox.values.toList().indexOf(expense);
    setState(() {
      _expenseBox.deleteAt(expenseIndex);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _expenseBox.add(expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> registeredExpenses = _expenseBox.values.toList();

    Widget mainContent = const Center(
      child: Text(
          'No expenses found, you can start by clicking the plus button.😊'),
    );
    if (registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expense: registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingestrom Expense Tracker'),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(children: [
        Chart(expenses: registeredExpenses),
        Expanded(
          child: mainContent,
        ),
      ]),
    );
  }
}
