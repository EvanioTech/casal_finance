import 'package:flutter/material.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = true;
  bool _isLoading = true;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final user = AuthService().currentUser;
    if (user != null) {
      _uid = user.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (doc.exists && mounted) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _pushNotifications = data['pushEnabled'] ?? true;
          _emailNotifications = data['emailEnabled'] ?? false;
          _darkMode = data['darkMode'] ?? true;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _updatePref(String key, bool value) async {
    if (_uid == null) return;
    
    setState(() {
      if (key == 'push') _pushNotifications = value;
      if (key == 'email') _emailNotifications = value;
      if (key == 'dark') _darkMode = value;
    });

    await DatabaseService().updateUserPreferences(
      _uid!,
      pushEnabled: key == 'push' ? value : null,
      emailEnabled: key == 'email' ? value : null,
      darkMode: key == 'dark' ? value : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFA27F)))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferências',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSwitchTile(
                  title: 'Notificações Push',
                  value: _pushNotifications,
                  onChanged: (val) => _updatePref('push', val),
                ),
                _buildSwitchTile(
                  title: 'Notificações por E-mail',
                  value: _emailNotifications,
                  onChanged: (val) => _updatePref('email', val),
                ),
                _buildSwitchTile(
                  title: 'Modo Escuro',
                  value: _darkMode,
                  onChanged: (val) => _updatePref('dark', val),
                ),
                const SizedBox(height: 32),
            const Text(
              'Sobre',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Termos de Serviço', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Política de Privacidade', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 16),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFA27F),
          ),
        ],
      ),
    );
  }
}
