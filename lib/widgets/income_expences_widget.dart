import 'package:expenz/utilities/colors.dart';
import 'package:flutter/material.dart';

class IncomeExpencesWidget extends StatefulWidget {
  final bool isIncome;
  final String value;
  const IncomeExpencesWidget({
    super.key,

    required this.isIncome,
    required this.value,
  });

  @override
  State<IncomeExpencesWidget> createState() => _IncomeExpencesWidgetState();
}

class _IncomeExpencesWidgetState extends State<IncomeExpencesWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 110),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 360 ? 14 : 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: widget.isIncome ? kGreen : kRed,
          boxShadow: [
            BoxShadow(
              color: (widget.isIncome ? kGreen : kRed).withValues(alpha: 0.22),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kWhite.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Image.asset(
                  widget.isIncome
                      ? "assets/images/income.png"
                      : "assets/images/expense.png",
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.isIncome ? "Income" : "Expense",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: kWhite.withValues(alpha: 0.88),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
