import 'package:flutter/material.dart';

import '../core/utils/validators.dart';
import '../models/profile_details.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.initialProfile,
    required this.isSaving,
    required this.onSave,
    this.errorMessage,
    this.statusMessage,
    super.key,
  });

  final ProfileDetails initialProfile;
  final bool isSaving;
  final String? errorMessage;
  final String? statusMessage;
  final Future<bool> Function(ProfileDetails) onSave;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _universityController;
  late final TextEditingController _majorController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.name);
    _universityController =
        TextEditingController(text: widget.initialProfile.university);
    _majorController = TextEditingController(text: widget.initialProfile.major);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await widget.onSave(
      ProfileDetails(
        name: _nameController.text,
        university: _universityController.text,
        major: _majorController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
          children: [
            const Text(
              'Edit profil',
              style: TextStyle(
                color: Color(0xFF193A36),
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Perbarui informasi profil akun Firebase kamu.'),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              enabled: !widget.isSaving,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.name],
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                border: OutlineInputBorder(),
              ),
              validator: validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _universityController,
              enabled: !widget.isSaving,
              textInputAction: TextInputAction.next,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Universitas',
                border: OutlineInputBorder(),
              ),
              validator: validateUniversity,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _majorController,
              enabled: !widget.isSaving,
              textInputAction: TextInputAction.done,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Program studi',
                border: OutlineInputBorder(),
              ),
              validator: validateMajor,
            ),
            if (widget.errorMessage != null) ...[
              const SizedBox(height: 4),
              Semantics(
                liveRegion: true,
                child: Text(
                  widget.errorMessage!,
                  style: const TextStyle(color: Color(0xFFB3261E)),
                ),
              ),
            ],
            if (widget.statusMessage != null) ...[
              const SizedBox(height: 4),
              Semantics(
                liveRegion: true,
                child: Text(
                  widget.statusMessage!,
                  style: const TextStyle(
                    color: Color(0xFF1F6B57),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: widget.isSaving ? null : _submit,
              icon: widget.isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                widget.isSaving ? 'Menyimpan profil...' : 'Simpan profil',
              ),
            ),
          ],
        ),
      );
}
