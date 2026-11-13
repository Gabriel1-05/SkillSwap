import 'package:flutter/material.dart';

import '../core/utils/validators.dart';

/// Renders the login and account creation fields and their UI status.
/// Authentication requests remain owned by AuthScreen/AuthService.
class AuthForm extends StatelessWidget {
  const AuthForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.isRegister,
    required this.isLoading,
    required this.onSubmit,
    required this.onToggleMode,
    required this.onResetPassword,
    this.errorMessage,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isRegister;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;
  final VoidCallback onResetPassword;

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          children: [
            const Icon(
              Icons.swap_horiz_rounded,
              color: Color(0xFF1F6B57),
              size: 48,
            ),
            const SizedBox(height: 18),
            Text(
              isRegister ? 'Buat akun baru' : 'Selamat datang kembali',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isRegister
                  ? 'Mulai temukan teman belajar yang cocok.'
                  : 'Masuk untuk melanjutkan perjalanan belajar.',
            ),
            const SizedBox(height: 30),
            if (isRegister) ...[
              _buildNameField(),
              const SizedBox(height: 14),
            ],
            _buildEmailField(),
            const SizedBox(height: 14),
            _buildPasswordField(),
            if (errorMessage != null) ...[
              const SizedBox(height: 14),
              Semantics(
                liveRegion: true,
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Color(0xFFB3261E)),
                ),
              ),
            ],
            const SizedBox(height: 22),
            _buildSubmitButton(),
            const SizedBox(height: 8),
            TextButton(
              onPressed: isLoading ? null : onToggleMode,
              child: Text(
                isRegister
                    ? 'Sudah punya akun? Masuk'
                    : 'Belum punya akun? Daftar',
              ),
            ),
            if (!isRegister)
              TextButton(
                onPressed: isLoading ? null : onResetPassword,
                child: const Text('Lupa kata sandi?'),
              ),
            if (isLoading)
              Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    isRegister
                        ? 'Sedang membuat akun...'
                        : 'Sedang memproses permintaan autentikasi.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );

  Widget _buildNameField() => TextFormField(
        controller: nameController,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.name],
        decoration: const InputDecoration(
          labelText: 'Nama lengkap',
          border: OutlineInputBorder(),
        ),
        validator: validateName,
      );

  Widget _buildEmailField() => TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: validateEmail,
      );

  Widget _buildPasswordField() => TextFormField(
        controller: passwordController,
        obscureText: true,
        textInputAction: TextInputAction.done,
        autofillHints: [
          isRegister ? AutofillHints.newPassword : AutofillHints.password,
        ],
        onFieldSubmitted: isLoading ? null : (_) => onSubmit(),
        decoration: const InputDecoration(
          labelText: 'Kata sandi',
          border: OutlineInputBorder(),
        ),
        validator: validatePassword,
      );

  Widget _buildSubmitButton() => FilledButton(
        onPressed: isLoading ? null : onSubmit,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text(isRegister ? 'Mendaftarkan akun...' : 'Sedang masuk...'),
                ],
              )
            : Text(isRegister ? 'Daftar' : 'Masuk'),
      );
}
