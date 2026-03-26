import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';
import '../provider/expense_provider.dart';
import '../widgets/edit_expence.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseStreamProvider);
    final currencyFormat = NumberFormat.currency(symbol: "৳");

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(
              child: Text(
                "No expenses found",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final e = expenses[index];

              return Card(
                elevation: 3,
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      /// ICON / AVATAR
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B5FFF), Color(0xFF4B8CF5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.attach_money,
                            color: Colors.white, size: 28),
                      ),

                      const SizedBox(width: 16),

                      /// TITLE + DATE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat("EEE, MMM dd, yyyy").format(e.date),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// AMOUNT + ACTIONS
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              currencyFormat.format(e.amount),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (_) =>
                                        EditExpenseDialog(expense: e),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Delete Expense"),
                                      content: const Text(
                                          "Are you sure you want to delete this expense?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text("Delete")),
                                      ],
                                    ),
                                  );
                                  if (confirmed == true) {
                                    await ref
                                        .read(expenseRepoProvider)
                                        .deleteExpense(e.id);
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
        const Center(child: CircularProgressIndicator(strokeWidth: 3)),
        error: (_, __) => const Center(
          child: Text(
            "Error loading expenses",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}