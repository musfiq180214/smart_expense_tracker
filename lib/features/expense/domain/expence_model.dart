class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String userId; // NEW

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'userId': userId,
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'],
    title: map['title'],
    amount: (map['amount'] as num).toDouble(),
    date: DateTime.parse(map['date']),
    userId: map['userId'],
  );
}
