import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../providers/discover_provider.dart';
import '../providers/request_provider.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String? _candidateId;
  String? _learnSkill;
  String _teachSkill = 'ui-ux';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<RequestProvider>().loadCandidates();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RequestProvider>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 34),
      children: [
        const Text(
          'Kirim permintaan',
          style: TextStyle(
            color: Color(0xFF193A36),
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text('Mulai pertukaran skill dengan teman yang cocok.'),
        const SizedBox(height: 22),
        if (provider.state == ViewState.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(36),
              child: CircularProgressIndicator(),
            ),
          )
        else if (provider.state == ViewState.error)
          _RequestErrorState(
            message: provider.errorMessage ?? 'Data gagal dimuat.',
            onRetry: provider.loadCandidates,
          )
        else if (provider.state == ViewState.empty)
          const _RequestEmptyState()
        else
          _buildForm(context, provider),
      ],
    );
  }

  Widget _buildForm(BuildContext context, RequestProvider provider) {
    final currentUser = context.read<DiscoverProvider>().currentUser;
    if (_candidateId == null && provider.candidates.isNotEmpty) {
      _candidateId = provider.candidates.first.id;
    }
    final selectedCandidate = provider.candidates
        .where((candidate) => candidate.id == _candidateId)
        .firstOrNull;
    final learnSkills = selectedCandidate?.teachSkillIds ?? const <String>[];
    if (_learnSkill == null && learnSkills.isNotEmpty) {
      _learnSkill = learnSkills.first;
    }
    if (!currentUser.teachSkillIds.contains(_teachSkill)) {
      _teachSkill = currentUser.teachSkillIds.first;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _candidateId,
            decoration: const InputDecoration(
              labelText: 'Teman yang diajak',
              border: OutlineInputBorder(),
            ),
            items: provider.candidates
                .map((candidate) => DropdownMenuItem(
                      value: candidate.id,
                      child: Text(candidate.name),
                    ))
                .toList(),
            onChanged: provider.isSubmitting
                ? null
                : (value) => setState(() {
                      _candidateId = value;
                      final candidate = provider.candidates
                          .where((item) => item.id == value)
                          .firstOrNull;
                      _learnSkill = candidate?.teachSkillIds.firstOrNull;
                    }),
            validator: (value) => value == null ? 'Pilih teman belajar.' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            key: ValueKey('learn-${_candidateId ?? 'none'}'),
            initialValue: _learnSkill,
            decoration: const InputDecoration(
              labelText: 'Skill yang ingin dipelajari',
              border: OutlineInputBorder(),
            ),
            items: learnSkills
                .map((skill) => DropdownMenuItem(
                      value: skill,
                      child: Text(_prettySkill(skill)),
                    ))
                .toList(),
            onChanged: provider.isSubmitting
                ? null
                : (value) => setState(() => _learnSkill = value),
            validator: (value) =>
                value == null ? 'Pilih skill yang dipelajari.' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _teachSkill,
            decoration: const InputDecoration(
              labelText: 'Skill yang kamu tawarkan',
              border: OutlineInputBorder(),
            ),
            items: currentUser.teachSkillIds
                .map((skill) => DropdownMenuItem(
                      value: skill,
                      child: Text(_prettySkill(skill)),
                    ))
                .toList(),
            onChanged: provider.isSubmitting
                ? null
                : (value) => setState(() => _teachSkill = value ?? _teachSkill),
            validator: (value) =>
                value == null ? 'Pilih skill yang ditawarkan.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageController,
            enabled: !provider.isSubmitting,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: const InputDecoration(
              labelText: 'Pesan untuk temanmu',
              hintText: 'Ceritakan rencana pertukaran skill kalian.',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              final message = value?.trim() ?? '';
              if (message.isEmpty) return 'Pesan tidak boleh kosong.';
              if (message.length > 300) return 'Pesan maksimal 300 karakter.';
              return null;
            },
          ),
          if (provider.submitError != null) ...[
            const SizedBox(height: 8),
            Text(provider.submitError!,
                style: const TextStyle(color: Color(0xFFB3261E))),
          ],
          if (provider.didSubmit) ...[
            const SizedBox(height: 8),
            const Text('Permintaan terkirim.',
                style: TextStyle(
                    color: Color(0xFF1F6B57), fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: provider.isSubmitting ? null : () => _submit(provider),
            icon: provider.isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_outlined),
            label: Text(
                provider.isSubmitting ? 'Mengirim...' : 'Kirim permintaan'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(RequestProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    final candidateId = _candidateId;
    final learnSkill = _learnSkill;
    if (candidateId == null || learnSkill == null) return;
    await provider.submitRequest(
      SkillSwapRequestDraft(
        receiverId: candidateId,
        teachSkill: _teachSkill,
        learnSkill: learnSkill,
        message: _messageController.text.trim(),
      ),
    );
  }
}

class _RequestErrorState extends StatelessWidget {
  const _RequestErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 38, color: Color(0xFF9B4B42)),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba lagi'),
          ),
        ],
      );
}

class _RequestEmptyState extends StatelessWidget {
  const _RequestEmptyState();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Icon(Icons.person_search_outlined,
                size: 38, color: Color(0xFF68736E)),
            SizedBox(height: 10),
            Text('Belum ada teman yang bisa diajak bertukar skill.'),
          ],
        ),
      );
}

String _prettySkill(String skill) => skill
    .split('-')
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join('/');
