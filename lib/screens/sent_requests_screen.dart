import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/view_state.dart';
import '../providers/auth_provider.dart';
import '../providers/sent_request_provider.dart';
import 'auth_screen.dart';

class SentRequestsScreen extends StatefulWidget {
  const SentRequestsScreen({super.key});

  @override
  State<SentRequestsScreen> createState() => _SentRequestsScreenState();
}

class _SentRequestsScreenState extends State<SentRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  void _load() {
    final senderId = context.read<AuthProvider>().user?.uid;
    context.read<SentRequestProvider>().load(senderId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SentRequestProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Request dari Backend')),
      body: switch (provider.state) {
        ViewState.loading => const Center(child: CircularProgressIndicator()),
        ViewState.empty => const Center(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 48),
                  SizedBox(height: 12),
                  Text('Belum ada request terkirim ke Firestore.'),
                ],
              ),
            ),
          ),
        ViewState.error => _ErrorView(
            message: provider.errorMessage ?? 'Request gagal dimuat.',
            onRetry: _load,
            onSignIn: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
            ),
            showSignIn: context.watch<AuthProvider>().user == null,
          ),
        ViewState.idle || ViewState.loaded => RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (provider.state == ViewState.idle)
                  const Center(child: CircularProgressIndicator())
                else
                  ...provider.requests.map(
                    (request) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.swap_horiz,
                                    color: Color(0xFF1F6B57)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${_pretty(request.learnSkillId)} ↔ ${_pretty(request.teachSkillId)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Chip(label: Text(request.status)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(request.message),
                            const SizedBox(height: 8),
                            Text(
                              'Penerima: ${request.receiverId}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm', 'id_ID')
                                  .format(request.createdAt.toLocal()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      },
    );
  }

  String _pretty(String value) => value
      .split(RegExp(r'[-_]'))
      .map((part) => part.isEmpty
          ? part
          : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
    required this.onSignIn,
    required this.showSignIn,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSignIn;
  final bool showSignIn;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined,
                  size: 44, color: Color(0xFF9B4B42)),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
              if (showSignIn)
                TextButton(
                  onPressed: onSignIn,
                  child: const Text('Masuk dengan Firebase'),
                ),
            ],
          ),
        ),
      );
}
