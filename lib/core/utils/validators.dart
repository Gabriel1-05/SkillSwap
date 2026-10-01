String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Format email tidak valid.';
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value ?? '').length < 8) return 'Kata sandi minimal 8 karakter.';
  return null;
}

String? validateName(String? value) {
  final name = value?.trim() ?? '';
  if (name.length < 2 || name.length > 50) {
    return 'Nama harus 2 sampai 50 karakter.';
  }
  return null;
}