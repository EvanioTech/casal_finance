import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:casal_finance/models/notification_model.dart';
import 'package:casal_finance/services/database_service.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? _coupleId;

  @override
  void initState() {
    super.initState();
    _fetchCoupleId();
  }

  void _fetchCoupleId() async {
    final user = AuthService().currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          _coupleId = doc.data()?['coupleId'] ?? user.uid;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Notificações', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: _coupleId == null
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFA27F)))
            : StreamBuilder<List<NotificationModel>>(
                stream: DatabaseService().getNotifications(_coupleId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFFFA27F)));
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma notificação por enquanto.', style: TextStyle(color: Colors.white54)),
                    );
                  }

                  final notifs = snapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(24.0),
                    itemCount: notifs.length,
                    itemBuilder: (context, index) {
                      final n = notifs[index];
                      // Simple time ago formatter
                      final diff = DateTime.now().difference(n.date);
                      String timeStr = 'Agora mesmo';
                      if (diff.inDays > 0) {
                        timeStr = 'Há ${diff.inDays} dia(s)';
                      } else if (diff.inHours > 0) {
                        timeStr = 'Há ${diff.inHours} hora(s)';
                      } else if (diff.inMinutes > 0) {
                        timeStr = 'Há ${diff.inMinutes} minuto(s)';
                      }

                      IconData iconData = Icons.notifications_outlined;
                      switch(n.iconName) {
                        case 'shopping_cart_outlined': iconData = Icons.shopping_cart_outlined; break;
                        case 'account_balance_wallet_outlined': iconData = Icons.account_balance_wallet_outlined; break;
                        case 'emoji_events_outlined': iconData = Icons.emoji_events_outlined; break;
                        case 'warning_amber_rounded': iconData = Icons.warning_amber_rounded; break;
                      }

                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * (index < 5 ? index : 5)),
                        duration: const Duration(milliseconds: 600),
                        child: _buildNotificationItem(
                          n.title,
                          n.subtitle,
                          timeStr,
                          iconData,
                          isWarning: n.isWarning,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, String time, IconData icon, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isWarning ? Colors.redAccent.withOpacity(0.1) : const Color(0xFFFFA27F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: isWarning ? Colors.redAccent : const Color(0xFFFFA27F), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
