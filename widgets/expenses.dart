import 'package:wallet_guard/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:wallet_guard/add_expense.dart';
import 'package:wallet_guard/widgets/expenses_list.dart/expenses_list.dart';
import 'package:wallet_guard/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpenseState();
  }
}

class _ExpenseState extends State<Expenses> {
  final List<Expense> _registerExpanses = [
    Expense(
        title: 'SSD',
        amount: 22.50,
        datetime: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Netflix Subscription',
        amount: 11.99,
        datetime: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Burger',
        amount: 21.99,
        datetime: DateTime.now(),
        category: Category.food),
  ];

  void _addExpenseOverly() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpanses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpanses.indexOf(expense);
    setState(() {
      _registerExpanses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted Successfully'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registerExpanses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No Expenses Found.Start Adding some Expense!'),
    );
    if (_registerExpanses.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _registerExpanses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          title: const Text('Wallet Guard'),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
          actions: [
            IconButton(
              onPressed: _addExpenseOverly,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registerExpanses),
                  Expanded(child: mainContent),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registerExpanses),
                  ),
                  Expanded(child: mainContent),
                ],
              ));
  }
}
