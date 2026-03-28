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

    final maxY =
        (monthlyTotals.isNotEmpty
            ? monthlyTotals.reduce((a, b) => a > b ? a : b)
            : 0) *
        1.2;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: LineChart(
        LineChartData(
          maxY: maxY,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = [
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  final index = value.toInt();
                  if (index >= 0 && index < months.length) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                      ), // Add space below
                      child: Text(
                        months[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      value.toStringAsFixed(0),
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                12,
                (i) => FlSpot(i.toDouble(), monthlyTotals[i]),
              ),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              barWidth: 4,
              dotData: FlDotData(show: true),
            ),
          ],
          gridData: FlGridData(show: true),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide.none,
              bottom: BorderSide(color: Colors.black, width: 1),
              top: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
