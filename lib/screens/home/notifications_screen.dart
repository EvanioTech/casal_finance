import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              child: _buildNotificationItem(
                'Nova despesa adicionada',
                'Seu parceiro adicionou uma despesa de R\$ 450 no Supermercado.',
                'Há 2 horas',
                Icons.shopping_cart_outlined,
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              child: _buildNotificationItem(
                'Alerta de Orçamento',
                'Vocês atingiram 80% do orçamento de Lazer.',
                'Ontem',
                Icons.warning_amber_rounded,
                isWarning: true,
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: _buildNotificationItem(
                'Meta atingida!',
                'Parabéns, vocês atingiram a meta "Reserva de Emergência"!',
                '12 de Junho',
                Icons.emoji_events_outlined,
              ),
            ),
          ],
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
