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

String? validateUniversity(String? value) => _validateRequiredText(
      value,
      label: 'Nama universitas',
      minimumLength: 2,
      maximumLength: 100,
    );

String? validateMajor(String? value) => _validateRequiredText(
      value,
      label: 'Program studi',
      minimumLength: 2,
      maximumLength: 80,
    );

String? _validateRequiredText(
  String? value, {
  required String label,
  required int minimumLength,
  required int maximumLength,
}) {
  final text = value?.trim() ?? '';
  if (text.length < minimumLength || text.length > maximumLength) {
    return '$label harus $minimumLength sampai $maximumLength karakter.';
  }
  return null;
}
