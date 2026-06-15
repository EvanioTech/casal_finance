import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:casal_finance/services/database_service.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isExpense = true;
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  String _selectedCategory = 'Diversos';
  final List<String> _categories = [
    'Alimentação', 'Transporte', 'Lazer', 'Moradia', 'Saúde', 'Educação', 'Diversos', 'Salário', 'Investimento'
  ];

  DateTime _selectedDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFFA27F),
              onPrimary: Color(0xFF1E1E2C),
              surface: Color(0xFF1E1E2C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() async {
    if (_amountController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha o valor e a descrição.'),
          backgroundColor: Colors.redAccent,
        )
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      double amount = double.tryParse(_amountController.text.replaceAll('R\$', '').replaceAll('.', '').replaceAll(',', '.').trim()) ?? 0.0;
      User? user = AuthService().currentUser;
      if (user != null) {
        // For now, coupleId is just the user's UID. In a real app, you'd fetch their UserModel.
        TransactionModel newTx = TransactionModel(
          id: '',
          title: _descController.text.trim(),
          category: _selectedCategory,
          amount: amount,
          date: _selectedDate,
          isExpense: _isExpense,
          createdBy: user.uid,
          coupleId: user.uid,
        );
        await DatabaseService().addTransaction(newTx);
        if (!mounted) return;
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Nova Transação', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isExpense = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isExpense ? Colors.redAccent : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Despesa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isExpense = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isExpense ? Colors.greenAccent : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Receita', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Center(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _isExpense ? Colors.redAccent : Colors.greenAccent,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'R\$ 0,00',
                      hintStyle: TextStyle(
                        color: (_isExpense ? Colors.redAccent : Colors.greenAccent).withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: _buildTextField('Descrição', Icons.edit_outlined, controller: _descController),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: _buildCategoryDropdown(),
              ),
              const SizedBox(height: 16),
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today_outlined, color: Colors.white.withOpacity(0.7)),
                      title: Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 600),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA27F),
                    foregroundColor: const Color(0xFF1E1E2C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Color(0xFF1E1E2C)) 
                      : const Text('Salvar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextEditingController? controller}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          dropdownColor: const Color(0xFF2C2C3E),
          icon: Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.7)),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedCategory = newValue);
            }
          },
          items: _categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.category_outlined, color: Colors.white.withOpacity(0.7)),
                  const SizedBox(width: 16),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
