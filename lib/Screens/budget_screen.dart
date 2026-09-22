import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/category_chart_card.dart';
import 'package:expenz/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final Map<ExpenseCategory, double> expensesTotal;
  final Map<IncomeCategory, double> incomesTotal;

  const BudgetScreen({
    super.key,
    required this.expensesTotal,
    required this.incomesTotal,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

int _selectedMethod = 0;

Color getColor(dynamic category) {
  if (category is ExpenseCategory) {
    return expenseCategoryColors[category]!;
  } else {
    return incomeCategoryColors[category]!;
  }
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    final data = _selectedMethod == 0
        ? widget.expensesTotal
        : widget.incomesTotal;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Financial Report",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kLightGrey,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: kMainColor.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMethod = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _selectedMethod == 0
                                ? kRed
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Expenses",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: _selectedMethod == 0 ? kWhite : kBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMethod = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _selectedMethod == 1
                                ? kGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Incomes",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: _selectedMethod == 1 ? kWhite : kBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Chart(
                isIncome: _selectedMethod == 0,
                expenseTotal: widget.expensesTotal,
                incomeTotal: widget.incomesTotal,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final category = data.keys.toList()[index];
                  final total = data.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CategoryChartCard(
                      title: category.name,
                      progressColor: getColor(category),
                      amount: total,
                      total: data.values.fold(
                        0.0,
                        (sum, element) => sum + element,
                      ),
                      isExpense: _selectedMethod == 0 ? true : false,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
