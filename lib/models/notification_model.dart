import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconName;
  final DateTime date;
  final bool isRead;
  final bool isWarning;
  final String coupleId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.date,
    this.isRead = false,
    this.isWarning = false,
    required this.coupleId,
  });

  factory NotificationModel.fromMap(String id, Map<String, dynamic> data) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      iconName: data['iconName'] ?? 'notifications',
      date: (data['date'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      isWarning: data['isWarning'] ?? false,
      coupleId: data['coupleId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'iconName': iconName,
      'date': Timestamp.fromDate(date),
      'isRead': isRead,
      'isWarning': isWarning,
      'coupleId': coupleId,
    };
  }
}
