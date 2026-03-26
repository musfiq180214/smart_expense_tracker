import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/expence_model.dart';
import '../provider/expense_provider.dart';
import '../repo/expence_repo.dart';

class EditExpenseDialog extends ConsumerStatefulWidget {
  final Expense expense;
  const EditExpenseDialog({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends ConsumerState<EditExpenseDialog> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.title);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void saveExpense() async {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text);
    if (title.isEmpty || amount == null) return;

    final updatedExpense = Expense(
      id: widget.expense.id,
      title: title,
      amount: amount,
      date: selectedDate,
      userId: widget.expense.userId,
    );

    await ref.read(expenseRepoProvider).updateExpense(updatedExpense);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),
          Row(
            children: [
              Text("${selectedDate.toLocal()}".split(' ')[0]),
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
          )
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: saveExpense, child: const Text("Save")),
      ],
    );
  }
}