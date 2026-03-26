import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../domain/expence_model.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpensePieChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(child: Text("No data for chart"));
    }

    final Map<String, double> categoryTotals = {};
    for (var e in expenses) {
      categoryTotals[e.title] = (categoryTotals[e.title] ?? 0) + e.amount;
    }

    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final colors = [
      Colors.deepPurple,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.teal,
    ];

    final entries = categoryTotals.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 LEGEND
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 120, // max height for legend
          ),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: List.generate(entries.length, (index) {
                final entry = entries[index];
                final color = colors[index % colors.length];
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${entry.key} (${entry.value.toStringAsFixed(0)})",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// 🥧 PIE CHART - expand to remaining space
        Expanded(
          child: PieChart(
            PieChartData(
              sections: List.generate(entries.length, (index) {
                final entry = entries[index];
                final percentage = (entry.value / total) * 100;
                return PieChartSectionData(
                  color: colors[index % colors.length],
                  value: entry.value,
                  title: "${percentage.toStringAsFixed(1)}%",
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
      ],
    );
  }
}