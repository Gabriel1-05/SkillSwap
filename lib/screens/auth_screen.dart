import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/validators.dart';
import '../models/view_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form.dart';

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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SizedBox.expand(
              child: AuthForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                isRegister: _isRegister,
                isLoading: isLoading,
                errorMessage: auth.errorMessage,
                onSubmit: _submit,
                onToggleMode: () => setState(() => _isRegister = !_isRegister),
                onResetPassword: _resetPassword,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (validateEmail(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Isi email yang valid terlebih dahulu.')));
      return;
    }
    final success = await context
        .read<AuthProvider>()
        .sendPasswordReset(_emailController.text);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Email reset kata sandi sudah dikirim.')));
    }
  }
}
