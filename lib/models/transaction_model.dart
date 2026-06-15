import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final String createdBy; // User ID
  final String coupleId; // Shared ID

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.createdBy,
    required this.coupleId,
  });

  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isExpense: data['isExpense'] ?? true,
      createdBy: data['createdBy'] ?? '',
      coupleId: data['coupleId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'isExpense': isExpense,
      'createdBy': createdBy,
      'coupleId': coupleId,
    };
  }
}
