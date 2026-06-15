import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final String coupleId;

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.coupleId,
  });

  factory GoalModel.fromMap(String id, Map<String, dynamic> data) {
    return GoalModel(
      id: id,
      title: data['title'] ?? '',
      targetAmount: (data['targetAmount'] ?? 0).toDouble(),
      savedAmount: (data['savedAmount'] ?? 0).toDouble(),
      coupleId: data['coupleId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'coupleId': coupleId,
    };
  }
}
