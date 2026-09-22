import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/expenses_card.dart';
import 'package:expenz/widgets/income_expences_widget.dart';
import 'package:expenz/widgets/line_chart_sample.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Income> incomesList;
  final List<Expense> expensesList;
  const HomeScreen({
    super.key,
    required this.incomesList,
    required this.expensesList,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  @override
  void initState() {
    UserServices.getUserData().then((value) {
      if (value["username"] != null) {
        setState(() {
          username = value["username"]!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  screenWidth < 360 ? 18 : 22,
                  20,
                  screenWidth < 360 ? 18 : 22,
                  24,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kMainColor, kMainColorDark],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kWhite.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: kWhite.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              "assets/images/person.png",
                              fit: BoxFit.cover,
                              width: 54,
                              height: 54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Welcome back,\n$username",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth < 360 ? 18 : 20,
                              height: 1.2,
                            ),
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: kWhite.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              color: kWhite,
                              size: 24,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: IncomeExpencesWidget(
                            isIncome: true,
                            value:
                                "LKR\n${widget.incomesList.fold(0.0, (sum, item) => sum + item.amount)}",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: IncomeExpencesWidget(
                            isIncome: false,
                            value:
                                "LKR\n${widget.expensesList.fold(0.0, (sum, item) => sum + item.amount)}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Spend frequency",
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 22 : 24,
                        fontWeight: FontWeight.w800,
                        color: kBlack,
                      ),
                    ),
                    const SizedBox(height: 14),
                    LineChartSample(),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent transactions",
                          style: TextStyle(
                            fontSize: screenWidth < 360 ? 22 : 24,
                            fontWeight: FontWeight.w800,
                            color: kBlack,
                          ),
                        ),
                        Text(
                          "See all",
                          style: TextStyle(
                            color: kMainColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    widget.expensesList.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "No expenses yet. Add a few expenses to start tracking.",
                              style: TextStyle(
                                color: kGrey,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.expensesList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final expense = widget.expensesList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ExpenceCard(
                                  title: expense.title,
                                  description: expense.description,
                                  amount: expense.amount,
                                  time: expense.date,
                                  date: expense.time,
                                  category: expense.category,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
