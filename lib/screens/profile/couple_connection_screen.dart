import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/services/database_service.dart';

class CoupleConnectionScreen extends StatefulWidget {
  const CoupleConnectionScreen({super.key});

  @override
  State<CoupleConnectionScreen> createState() => _CoupleConnectionScreenState();
}

class _CoupleConnectionScreenState extends State<CoupleConnectionScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  void _copyMyCode() {
    final uid = AuthService().currentUser?.uid ?? '';
    if (uid.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: uid));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seu código foi copiado para a área de transferência!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _connect() async {
    final partnerCode = _codeController.text.trim();
    if (partnerCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira o código do parceiro.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    final myUid = AuthService().currentUser?.uid ?? '';
    
    if (myUid.isNotEmpty) {
      final error = await DatabaseService().connectToPartner(myUid, partnerCode);
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contas conectadas com sucesso! 🎉'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUid = AuthService().currentUser?.uid ?? 'Carregando...';

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Conexão de Casal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA27F), Color(0xFFFF7A59)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.favorite, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Seu Código de Convite',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    myUid,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _copyMyCode,
                    icon: const Icon(Icons.copy, size: 16, color: Color(0xFFFFA27F)),
                    label: const Text('Copiar Código', style: TextStyle(color: Color(0xFFFFA27F))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Conectar com Parceiro(a)',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Peça o código de convite do seu parceiro e insira abaixo para unificar suas contas financeiras.',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _codeController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cole o código aqui',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.link, color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _connect,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA27F),
                foregroundColor: const Color(0xFF1E1E2C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xFF1E1E2C)))
                  : const Text('Conectar Contas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
