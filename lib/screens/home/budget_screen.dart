import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

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
        child: SingleChildScrollView(
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
                          value: 0.65,
                          strokeWidth: 16,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA27F)),
                        ),
                      ),
                      Column(
                        children: [
                          Text('Disponível', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
                          const SizedBox(height: 8),
                          const Text('R\$ 1.450,00', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
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
                child: const Text('Categorias', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    _buildBudgetCategory('Alimentação', 'R\$ 1.200', 'R\$ 1.500', 0.8),
                    _buildBudgetCategory('Moradia', 'R\$ 2.000', 'R\$ 2.000', 1.0),
                    _buildBudgetCategory('Lazer', 'R\$ 300', 'R\$ 500', 0.6),
                    _buildBudgetCategory('Transporte', 'R\$ 400', 'R\$ 600', 0.66),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetCategory(String name, String spent, String total, double progress) {
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
              Text('$spent / $total', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.9 ? Colors.redAccent : const Color(0xFFFFA27F),
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
