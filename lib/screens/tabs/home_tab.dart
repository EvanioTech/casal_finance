import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:casal_finance/screens/home/add_transaction_screen.dart';
import 'package:casal_finance/screens/home/budget_screen.dart';
import 'package:casal_finance/screens/home/notifications_screen.dart';
import 'package:casal_finance/screens/tabs/goals_tab.dart';
import 'package:casal_finance/services/database_service.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/models/transaction_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<TransactionModel>>(
        stream: DatabaseService().getTransactions(AuthService().currentUser?.uid ?? ''),
        builder: (context, snapshot) {
          double totalBalance = 0;
          double totalIncome = 0;
          double totalExpense = 0;
          List<TransactionModel> recent = [];

          if (snapshot.hasData) {
            final txs = snapshot.data!;
            recent = txs.take(3).toList();
            for (var tx in txs) {
              if (tx.isExpense) {
                totalExpense += tx.amount;
                totalBalance -= tx.amount;
              } else {
                totalIncome += tx.amount;
                totalBalance += tx.amount;
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, Casal!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Resumo das finanças',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA27F), Color(0xFFFF7A59)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFA27F).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Conjunto',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCardStat(Icons.arrow_downward, 'Receitas', 'R\$ ${totalIncome.toStringAsFixed(2)}'),
                        _buildCardStat(Icons.arrow_upward, 'Despesas', 'R\$ ${totalExpense.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: const Text(
                'Acesso Rápido',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              duration: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    Icons.add, 
                    'Nova\nDespesa',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTransactionScreen())),
                  ),
                  _buildQuickAction(
                    Icons.pie_chart_outline, 
                    'Orçamento',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetScreen())),
                  ),
                  _buildQuickAction(
                    Icons.flag_outlined, 
                    'Metas',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Scaffold(backgroundColor: Color(0xFF1E1E2C), body: GoalsTab()))),
                  ),
                  _buildQuickAction(
                    Icons.more_horiz, 
                    'Mais',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color(0xFF1E1E2C),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(24),
                          height: 200,
                          child: const Center(
                            child: Text('Mais opções em breve...', style: TextStyle(color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              duration: const Duration(milliseconds: 600),
              child: const Text(
                'Transações Recentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 1000),
              duration: const Duration(milliseconds: 600),
              child: recent.isEmpty 
                  ? const Text('Nenhuma transação ainda.', style: TextStyle(color: Colors.white))
                  : Column(
                      children: recent.map((tx) {
                        final prefix = tx.isExpense ? '- R\$ ' : '+ R\$ ';
                        return _buildTransactionItem(
                          tx.isExpense ? Icons.shopping_cart_outlined : Icons.attach_money,
                          tx.title,
                          "${tx.date.day}/${tx.date.month}",
                          "$prefix${tx.amount.toStringAsFixed(2)}",
                          tx.isExpense,
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      );
        },
      ),
    );
  }

  Widget _buildCardStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, color: const Color(0xFFFFA27F), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String date, String amount, bool isExpense) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
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
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isExpense ? Colors.redAccent : Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }
}
