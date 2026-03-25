import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expense_chart.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expense_list.dart';
import 'package:smart_expense_tracker/features/expense/widgets/shimmer_chart.dart';
import '../provider/expense_provider.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void addExpense() async {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text);

    if (title.isEmpty || amount == null) return;

    await ref.read(addExpenseProvider)(title, amount, selectedDate);

    titleController.clear();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Tracker")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// INPUT
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),

            Row(
              children: [
                Text("${selectedDate.toLocal()}".split(' ')[0]),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDate: selectedDate,
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: addExpense,
              child: const Text("Add Expense"),
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: expensesAsync.when(
                data: (data) => ExpenseList(expenses: data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text("Error"),
              ),
            ),

            /// CHART
            SizedBox(
              height: 200,
              child: expensesAsync.when(
                data: (data) => ExpenseChart(expenses: data),
                loading: () => const ShimmerChart(),
                error: (_, __) => const Text("Error"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
