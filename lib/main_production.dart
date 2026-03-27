import 'package:smart_expense_tracker/core/utils/enums.dart';
import 'package:smart_expense_tracker/flavor_config.dart';
import 'package:smart_expense_tracker/main.dart';

void main() async {
  FlavorConfig.instantiate(
    flavor: Flavor.production,
    baseUrl: "",
    appTitle: 'Smart Expense Tracker App',
  );
  await smartExpenseTracker();
}
