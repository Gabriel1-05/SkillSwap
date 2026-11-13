import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../widgets/loading_status.dart';
import '../widgets/profile_form.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({required this.uid, super.key});

  final String uid;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(context.read<ProfileProvider>().loadCurrentProfile(widget.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Profil akun')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: provider.isLoading && provider.profile == null
                ? const LoadingStatus(message: 'Memuat profil akun...')
                : provider.profile == null
                    ? _ProfileLoadError(
                        message:
                            provider.errorMessage ?? 'Profil gagal dimuat.',
                        onRetry: () => unawaited(
                          provider.loadCurrentProfile(widget.uid, force: true),
                        ),
                      )
                    : ProfileForm(
                        key: ValueKey(widget.uid),
                        initialProfile: provider.profile!,
                        isSaving: provider.isSaving,
                        errorMessage: provider.errorMessage,
                        statusMessage: provider.statusMessage,
                        onSave: (profile) => provider.saveCurrentProfile(
                          widget.uid,
                          profile,
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}

class _ProfileLoadError extends StatelessWidget {
  const _ProfileLoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(liveRegion: true, child: Text(message)),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
}
