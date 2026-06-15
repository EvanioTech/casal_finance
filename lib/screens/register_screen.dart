import 'package:animate_do/animate_do.dart';
import 'package:casal_finance/screens/main_screen.dart';
import 'package:casal_finance/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  void _loginWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      await AuthService().signInWithGoogle();
      if (!mounted) return;
      Navigator.pop(context); // AuthWrapper cuidará do resto
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  void _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas não coincidem.', style: TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await AuthService().signUpWithEmail(_emailController.text.trim(), _passwordController.text.trim(), _nameController.text.trim());
      if (!mounted) return;
      Navigator.pop(context); // Voltar para onde o AuthWrapper vai cuidar (Login -> Main)
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(), style: const TextStyle(color: Colors.white)), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    'Junte-se ao Casal Finance e organize suas metas.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(
                    controller: _nameController,
                    hintText: 'Nome completo',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(
                    controller: _emailController,
                    hintText: 'E-mail',
                    icon: Icons.email_outlined,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(
                    controller: _passwordController,
                    hintText: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isConfirm: false,
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 800),
                  child: _buildTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirmar Senha',
                    icon: Icons.lock_reset_outlined,
                    isPassword: true,
                    isConfirm: true,
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  duration: const Duration(milliseconds: 800),
                  child: ElevatedButton(
                    onPressed: _isLoading || _isGoogleLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA27F),
                      foregroundColor: const Color(0xFF1E1E2C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Color(0xFF1E1E2C), strokeWidth: 2),
                          )
                        : const Text(
                            'Cadastrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 1300),
                  duration: const Duration(milliseconds: 800),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Ou', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                      ),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 1400),
                  duration: const Duration(milliseconds: 800),
                  child: OutlinedButton(
                    onPressed: _isGoogleLoading || _isLoading ? null : _loginWithGoogle,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isGoogleLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata, color: Colors.white, size: 32),
                              const SizedBox(width: 8),
                              const Text(
                                'Entrar com o Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isConfirm = false,
  }) {
    bool obscure = isConfirm ? _obscureConfirmPassword : _obscurePassword;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      if (isConfirm) {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      } else {
                        _obscurePassword = !_obscurePassword;
                      }
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
