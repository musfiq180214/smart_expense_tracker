import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/auth/presentation/login_screen.dart';
import 'package:smart_expense_tracker/features/auth/provider/auth_provider.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expence_pie_chart.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expense_chart.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expense_list.dart';
import 'package:smart_expense_tracker/features/expense/widgets/expense_title_dropdown.dart';
import 'package:smart_expense_tracker/features/expense/widgets/shimmer_chart.dart';
import '../provider/expense_provider.dart';
import 'expence_list_screen.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isDropdownOpen = false;
  final FocusNode titleFocusNode = FocusNode();

  void addExpense() async {
    final title = titleController.text;
    final amount = double.tryParse(amountController.text);

    List<String> missingFields = [];
    if (title.isEmpty) missingFields.add("Title");
    if (amount == null) missingFields.add("Amount");
    if (selectedDate == null) missingFields.add("Date");

    if (missingFields.isNotEmpty) {
      // Join missing fields into a readable string
      final message = "Please fill the following: ${missingFields.join(", ")}";
      showCustomSnackbar(message);
      return;
    } else {
      await ref.read(addExpenseProvider)(title, amount ?? 0, selectedDate);

      titleController.clear();
      amountController.clear();
    }
  }

  void showCustomSnackbar(String message, {Color color = Colors.redAccent}) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        automaticallyImplyLeading: false, // removes back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepoProvider).logout();
              // Go back to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// INPUT
              Consumer(
                builder: (context, ref, _) {
                  final expensesAsync = ref.watch(expenseStreamProvider);

                  return expensesAsync.when(
                    data: (expenses) {
                      final titles = expenses
                          .map((e) => e.title)
                          .toSet()
                          .toList();

                      return TitleDropdownField(
                        options: titles,
                        controller: titleController,
                        focusNode: titleFocusNode,
                      );
                    },
                    loading: () => TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    error: (_, __) => TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                  );
                },
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
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addExpense,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Add Expense",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ExpenseListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    backgroundColor: Colors.orange,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.list, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Expense List",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// LIST
              SizedBox(
                height: 200,
                child: expensesAsync.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text(
                          "No expenses found",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return ExpenseList(expenses: data);
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(
                    child: Text(
                      "Error loading expenses",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// YEAR DROPDOWN
              Consumer(
                builder: (context, ref, _) {
                  final years = ref.watch(availableYearsProvider);
                  final selectedYear = ref.watch(selectedYearProvider);

                  if (years.isEmpty) return const SizedBox();

                  return DropdownButton<int>(
                    value: selectedYear,
                    items: years
                        .map(
                          (year) => DropdownMenuItem(
                            value: year,
                            child: Text(year.toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(selectedYearProvider.notifier).state = value;
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),

              /// BAR / LINE CHART
              SizedBox(
                height: 180,
                child: Consumer(
                  builder: (context, ref, _) {
                    final filteredExpenses = ref.watch(
                      filteredExpensesProvider,
                    );
                    final expensesAsync = ref.watch(expenseStreamProvider);

                    return expensesAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Text("No data to display"),
                          );
                        }
                        return ExpenseChart(expenses: filteredExpenses);
                      },
                      loading: () => const ShimmerChart(),
                      error: (_, __) =>
                          const Center(child: Text("Error loading chart")),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// 🥧 PIE CHART SECTION
              Consumer(
                builder: (context, ref, _) {
                  final selectedYear = ref.watch(selectedYearProvider);

                  return Text(
                    "Expense Distribution ($selectedYear)",
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 300,
                child: Consumer(
                  builder: (context, ref, _) {
                    final filteredExpenses = ref.watch(
                      filteredExpensesProvider,
                    );
                    final expensesAsync = ref.watch(expenseStreamProvider);

                    return expensesAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(
                            child: Text("No data to display"),
                          );
                        }
                        return ExpensePieChart(expenses: filteredExpenses);
                      },
                      loading: () => const ShimmerChart(),
                      error: (_, __) =>
                          const Center(child: Text("Error loading chart")),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
