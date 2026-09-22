import 'package:expenz/Screens/addnew_screen.dart';
import 'package:expenz/Screens/budget_screen.dart';
import 'package:expenz/Screens/home_screen.dart';
import 'package:expenz/Screens/profile_screen.dart';
import 'package:expenz/Screens/transition_screen.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_services.dart';
import 'package:expenz/utilities/colors.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curruntIndex = 0;

  List<Expense> expenseList = [];

  void fetchAllExpenses() async {
    List<Expense> loadedExpenses = await ExpenseService().loadExpense();
    setState(() {
      expenseList = loadedExpenses;
    });
  }

  List<Income> incomeList = [];

  void fetchAllIncomes() async {
    List<Income> loadIncomes = await IncomeServices().loadIncome();
    setState(() {
      incomeList = loadIncomes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fetchAllExpenses();
    });
    setState(() {
      fetchAllIncomes();
    });
  }

  //add new expense
  void addNewExpenses(Expense newExpense) {
    ExpenseService().saveExpenses(newExpense, context);

    //update the list of expenses
    setState(() {
      expenseList.add(newExpense);
    });
  }

  //add new income
  void addNewIncomes(Income newIncome) {
    IncomeServices().saveIncomes(newIncome, context);

    //update the list of incomes
    setState(() {
      incomeList.add(newIncome);
    });
  }

  void removeExpense(Expense expense) {
    ExpenseService().deleteExpenses(expense.id, context);
    setState(() {
      expenseList.remove(expense);
    });
  }

  void deleteIncome(Income income) {
    IncomeServices().removeIncome(income.id, context);
    setState(() {
      incomeList.remove(income);
    });
  }

  Map<ExpenseCategory, double> calculateExpenseTotal() {
    Map<ExpenseCategory, double> expenseCategoryTot = {
      ExpenseCategory.food: 0,
      ExpenseCategory.transport: 0,
      ExpenseCategory.health: 0,
      ExpenseCategory.shopping: 0,
      ExpenseCategory.subscription: 0,
      ExpenseCategory.other: 0,
    };
    for (Expense expense in expenseList) {
      expenseCategoryTot[expense.category] =
          (expenseCategoryTot[expense.category] ?? 0) + expense.amount;
    }
    return expenseCategoryTot;
  }

  Map<IncomeCategory, double> calculateIncomesTotal() {
    Map<IncomeCategory, double> incomeCategoryTot = {
      IncomeCategory.freelance: 0,
      IncomeCategory.passive: 0,
      IncomeCategory.sales: 0,
      IncomeCategory.salary: 0,
      IncomeCategory.Other: 0,
    };
    for (Income income in incomeList) {
      incomeCategoryTot[income.category] =
          (incomeCategoryTot[income.category] ?? 0) + income.amount;
    }
    return incomeCategoryTot;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenList = [
      HomeScreen(incomesList: incomeList, expensesList: expenseList),
      TransitionScreen(
        addDissmissIncome: deleteIncome,
        incomesList: incomeList,
        addDissmissExpense: removeExpense,
        expensesList: expenseList,
      ),
      AddnewScreen(addIncome: addNewIncomes, addExpense: addNewExpenses),
      BudgetScreen(
        expensesTotal: calculateExpenseTotal(),
        incomesTotal: calculateIncomesTotal(),
      ),
      ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: kMainColor.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: kMainColor,
              unselectedItemColor: kGrey,
              elevation: 0,
              currentIndex: _curruntIndex,
              selectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (index) {
                setState(() {
                  _curruntIndex = index;
                });
              },
              items: [
                const BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Icons.home_rounded),
                ),
                const BottomNavigationBarItem(
                  label: "Flow",
                  icon: Icon(Icons.swap_horiz_rounded),
                ),
                BottomNavigationBarItem(
                  label: "Add",
                  icon: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: kMainColor.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add_rounded, color: kWhite),
                  ),
                ),
                const BottomNavigationBarItem(
                  label: "Budget",
                  icon: Icon(Icons.pie_chart_rounded),
                ),
                const BottomNavigationBarItem(
                  label: "Profile",
                  icon: Icon(Icons.person_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
      body: screenList[_curruntIndex],
    );
  }
}
