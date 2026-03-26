import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker/features/expense/domain/expence_model.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseList({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: "৳");

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: expenses.length,
      itemBuilder: (context, i) {
        final e = expenses[i];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  child: const Icon(Icons.attach_money, color: Colors.white, size: 28),
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

                /// AMOUNT
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
              ],
            ),
          ),
        );
      },
    );
  }
}