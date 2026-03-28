// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

// class ExpenseChart extends StatelessWidget {
//   final List<Expense> expenses;

//   const ExpenseChart({super.key, required this.expenses});

//   @override
//   Widget build(BuildContext context) {
//     final monthlyTotals = List.generate(12, (index) {
//       return expenses
//           .where((e) => e.date.month == index + 1)
//           .fold(0.0, (sum, e) => sum + e.amount);
//     });

//     return BarChart(
//       BarChartData(
//         barGroups: List.generate(12, (i) {
//           return BarChartGroupData(
//             x: i,
//             barRods: [
//               BarChartRodData(
//                 toY: monthlyTotals[i],
//                 gradient: const LinearGradient(
//                   colors: [Colors.purple, Colors.blue],
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

class ExpenseChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Calculate monthly totals
    final monthlyTotals = List.generate(12, (index) {
      return expenses
          .where((e) => e.date.month == index + 1)
          .fold(0.0, (sum, e) => sum + e.amount);
    });

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Show month abbreviations
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
                  return Text(months[index]);
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              12,
              (i) => FlSpot(i.toDouble(), monthlyTotals[i]),
            ),
            isCurved: true, // This makes the line smooth/curved
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
            barWidth: 4,
            dotData: FlDotData(show: true), // shows dots on points
          ),
        ],
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
