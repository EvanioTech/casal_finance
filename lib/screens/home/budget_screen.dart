import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:casal_finance/services/database_service.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/models/transaction_model.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Orçamento Mensal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TransactionModel>>(
          stream: DatabaseService().getTransactions(AuthService().currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFFFA27F)));
            }

            double totalIncome = 0;
            double totalExpense = 0;
            Map<String, double> categoryExpenses = {};

            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final now = DateTime.now();
              for (var tx in snapshot.data!) {
                // Filter for current month only
                if (tx.date.month == now.month && tx.date.year == now.year) {
                  if (tx.isExpense) {
                    totalExpense += tx.amount;
                    categoryExpenses[tx.category] = (categoryExpenses[tx.category] ?? 0) + tx.amount;
                  } else {
                    totalIncome += tx.amount;
                  }
                }
              }
            }

            double balance = totalIncome - totalExpense;
            double progress = totalIncome > 0 ? totalExpense / totalIncome : 0.0;
            if (progress > 1.0) progress = 1.0;

            // Sort categories by highest expense
            var sortedCategories = categoryExpenses.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 16,
                              backgroundColor: Colors.white.withOpacity(0.05),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress > 0.9 ? Colors.redAccent : const Color(0xFFFFA27F)
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text('Saldo do Mês', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                              const SizedBox(height: 8),
                              Text('R\$ ${balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 600),
                    child: const Text('Gastos por Categoria', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: sortedCategories.isEmpty
                        ? const Center(child: Text('Nenhum gasto este mês.', style: TextStyle(color: Colors.white)))
                        : Column(
                            children: sortedCategories.map((entry) {
                              double catProgress = totalIncome > 0 ? entry.value / totalIncome : 0;
                              return _buildBudgetCategory(
                                entry.key,
                                'R\$ ${entry.value.toStringAsFixed(2)}',
                                '${(catProgress * 100).toStringAsFixed(1)}% da renda',
                                catProgress > 1.0 ? 1.0 : catProgress,
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBudgetCategory(String name, String spent, String subtitle, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
              Text(spent, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.5 ? Colors.redAccent : const Color(0xFFFFA27F),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
