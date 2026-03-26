import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_tracker/features/auth/presentation/login_screen.dart';
import 'package:smart_expense_tracker/features/auth/provider/auth_provider.dart';
import 'package:smart_expense_tracker/features/expense/presentation/expence_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // Navigate to ExpenseScreen
          return const ExpenseScreen();
        } else {
          // Navigate to LoginScreen
          return const LoginScreen();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text("Error: $err"))),
    );
  }
}
