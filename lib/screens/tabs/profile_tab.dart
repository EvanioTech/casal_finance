import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:casal_finance/screens/profile/edit_profile_screen.dart';
import 'package:casal_finance/screens/profile/couple_connection_screen.dart';
import 'package:casal_finance/screens/profile/security_screen.dart';
import 'package:casal_finance/screens/profile/settings_screen.dart';
import 'package:casal_finance/screens/profile/help_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return SafeArea(
      child: StreamBuilder<DocumentSnapshot>(
        stream: user != null ? FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots() : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator(color: Color(0xFFFFA27F)));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final String displayName = data?['name'] ?? user?.displayName ?? 'Usuário';
          final String email = data?['email'] ?? user?.email ?? '';
          final String? base64Str = data?['photoBase64'];
          final String photoUrl = (user?.photoURL != null && user!.photoURL!.isNotEmpty) ? user.photoURL! : 'https://i.pravatar.cc/300';

          ImageProvider imageProvider;
          if (base64Str != null && base64Str.isNotEmpty) {
            imageProvider = MemoryImage(base64Decode(base64Str));
          } else {
            imageProvider = NetworkImage(photoUrl);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: const Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 600),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFFA27F),
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFA27F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Color(0xFF1E1E2C),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 600),
              child: Column(
                children: [
                  _buildProfileOption(
                    Icons.person_outline,
                    'Editar Perfil',
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      setState(() {}); // Refresh after returning
                    },
                  ),
                  _buildProfileOption(
                    Icons.favorite_outline,
                    'Conexão de Casal',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CoupleConnectionScreen())),
                  ),
                  _buildProfileOption(
                    Icons.security_outlined,
                    'Segurança',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen())),
                  ),
                  _buildProfileOption(
                    Icons.settings_outlined,
                    'Configurações',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                  _buildProfileOption(
                    Icons.help_outline,
                    'Ajuda e Suporte',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
                  ),
                  const SizedBox(height: 24),
                  _buildProfileOption(
                    Icons.logout,
                    'Sair da Conta',
                    isDestructive: true,
                    onTap: () async {
                      await AuthService().signOut();
                    },
                  ),
                  ],
                ),
              ),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDestructive
                    ? Colors.redAccent.withOpacity(0.1)
                    : const Color(0xFFFFA27F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.redAccent : const Color(0xFFFFA27F),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? Colors.redAccent : Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
