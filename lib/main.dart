import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_expense_tracker/core/utils/enums.dart';
import 'package:smart_expense_tracker/features/expense/presentation/expence_screen.dart';
import 'package:smart_expense_tracker/features/onboarding/presentation/splash_screen.dart';
import 'package:smart_expense_tracker/firebase_options.dart';
import 'package:smart_expense_tracker/flavor_config.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> smartExpenseTracker() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlavorConfig.instantiate(
    flavor: Flavor.staging,
    baseUrl: "",
    appTitle: "Tasks (Staging)",
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}

/*
* Staging Credential
* musfiq180214@gmail.com
* 123456@mrs
* */
