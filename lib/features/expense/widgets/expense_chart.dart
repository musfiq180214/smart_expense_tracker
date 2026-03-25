import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final monthlyTotals = List.generate(12, (index) {
      return expenses
          .where((e) => e.date.month == index + 1)
          .fold(0.0, (sum, e) => sum + e.amount);
    });

    return BarChart(
      BarChartData(
        barGroups: List.generate(12, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: monthlyTotals[i],
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
