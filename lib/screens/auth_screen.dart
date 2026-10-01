import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/validators.dart';
import '../models/view_state.dart';
import '../providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = _isRegister
        ? await auth.register(_emailController.text, _passwordController.text)
        : await auth.login(_emailController.text, _passwordController.text);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.state == ViewState.loading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
            children: [
              const Icon(Icons.swap_horiz_rounded, color: Color(0xFF1F6B57), size: 48),
              const SizedBox(height: 18),
              Text(_isRegister ? 'Buat akun baru' : 'Selamat datang kembali', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(_isRegister ? 'Mulai temukan teman belajar yang cocok.' : 'Masuk untuk melanjutkan perjalanan belajar.'),
              const SizedBox(height: 30),
              if (_isRegister) ...[
                TextFormField(controller: _nameController, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Nama lengkap', border: OutlineInputBorder()), validator: validateName),
                const SizedBox(height: 14),
              ],
              TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()), validator: validateEmail),
              const SizedBox(height: 14),
              TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Kata sandi', border: OutlineInputBorder()), validator: validatePassword),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 14),
                Text(auth.errorMessage!, style: const TextStyle(color: Color(0xFFB3261E))),
              ],
              const SizedBox(height: 22),
              FilledButton(onPressed: isLoading ? null : _submit, child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(_isRegister ? 'Daftar' : 'Masuk')),
              const SizedBox(height: 8),
              TextButton(onPressed: isLoading ? null : () => setState(() => _isRegister = !_isRegister), child: Text(_isRegister ? 'Sudah punya akun? Masuk' : 'Belum punya akun? Daftar')),
              if (!_isRegister)
                TextButton(onPressed: isLoading ? null : _resetPassword, child: const Text('Lupa kata sandi?')),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (validateEmail(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi email yang valid terlebih dahulu.')));
      return;
    }
    final success = await context.read<AuthProvider>().sendPasswordReset(_emailController.text);
    if (!mounted) return;
    if (success) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email reset kata sandi sudah dikirim.')));
  }
}