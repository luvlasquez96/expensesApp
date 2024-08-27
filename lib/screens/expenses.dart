import 'package:expenseapp/models/expense.dart';
import 'package:expenseapp/screens/expenses_list.dart';
import 'package:expenseapp/widgets/chart/char.dart';
import 'package:expenseapp/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List <Expense> _registeredExpenses = [];

  void _openAddExpensesOverlay(){
  showModalBottomSheet(context: context,
  isScrollControlled: true, 
  builder: (ctx) =>
  NewExpense(onAddExpense: _addExpense)
  );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense( Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(duration: Duration(seconds: 3),
    content: Text('Expense deleted'),
    action: SnackBarAction(label: 'Undo',
     onPressed: (){
      setState(() {
        _registeredExpenses.insert(expenseIndex, expense);
      });
     }),));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(child: Text('No expenses found. Start adding some!'),);

    if (_registeredExpenses.isNotEmpty){
      mainContent = Expanded(child: ExpensesList(expenses: _registeredExpenses,
           onRemoveExpense: _removeExpense,));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Traker'),
        actions: [
          IconButton(onPressed: _openAddExpensesOverlay,
          icon: Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          mainContent
        ],
      ),
    );
  }
}