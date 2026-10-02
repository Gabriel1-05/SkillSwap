import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _meetingLinkController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _requestId;
  String _mode = 'online';
  String? _timeError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BookingProvider>().loadAcceptedSkillSwaps();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 34),
      children: [
        const Text(
          'Jadwalkan sesi',
          style: TextStyle(
            color: Color(0xFF193A36),
            fontSize: 27,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
            'Pilih permintaan yang sudah diterima dan atur waktu belajar.'),
        const SizedBox(height: 22),
        if (provider.state == ViewState.loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(36),
              child: CircularProgressIndicator(),
            ),
          )
        else if (provider.state == ViewState.error)
          _BookingErrorState(
            message: provider.errorMessage ?? 'Data gagal dimuat.',
            onRetry: provider.loadAcceptedSkillSwaps,
          )
        else if (provider.state == ViewState.empty)
          const _BookingEmptyState()
        else
          _buildForm(provider),
      ],
    );
  }

  Widget _buildForm(BookingProvider provider) {
    final swaps = provider.acceptedSkillSwaps;
    if (_requestId == null && swaps.isNotEmpty) _requestId = swaps.first.id;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _requestId,
            decoration: const InputDecoration(
              labelText: 'Permintaan yang diterima',
              border: OutlineInputBorder(),
            ),
            items: swaps
                .map((swap) => DropdownMenuItem(
                      value: swap.id,
                      child: Text('${swap.partnerName} · ${swap.skillName}'),
                    ))
                .toList(),
            onChanged: provider.isSubmitting
                ? null
                : (value) => setState(() => _requestId = value),
            validator: (value) => value == null ? 'Pilih permintaan.' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('booking-date'),
            controller: _dateController,
            readOnly: true,
            enabled: !provider.isSubmitting,
            decoration: const InputDecoration(
              labelText: 'Tanggal sesi',
              suffixIcon: Icon(Icons.calendar_today_outlined),
              border: OutlineInputBorder(),
            ),
            onTap: _pickDate,
            validator: (_) {
              if (_date == null) return 'Pilih tanggal sesi.';
              final today = DateUtils.dateOnly(DateTime.now());
              if (DateUtils.dateOnly(_date!).isBefore(today)) {
                return 'Tanggal sesi tidak boleh di masa lalu.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _timeField(
                      key: const ValueKey('booking-start-time'),
                      controller: _startController,
                      label: 'Mulai',
                      onTap: _pickStartTime)),
              const SizedBox(width: 12),
              Expanded(
                  child: _timeField(
                      key: const ValueKey('booking-end-time'),
                      controller: _endController,
                      label: 'Selesai',
                      onTap: _pickEndTime)),
            ],
          ),
          if (_timeError != null) ...[
            const SizedBox(height: 8),
            Text(_timeError!, style: const TextStyle(color: Color(0xFFB3261E))),
          ],
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Mode belajar',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'online', child: Text('Online')),
              DropdownMenuItem(value: 'offline', child: Text('Tatap muka')),
            ],
            onChanged: provider.isSubmitting
                ? null
                : (value) => setState(() => _mode = value ?? 'online'),
          ),
          if (_mode == 'online') ...[
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('booking-meeting-link'),
              controller: _meetingLinkController,
              enabled: !provider.isSubmitting,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Tautan meeting',
                hintText: 'https://meet.google.com/...',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (_mode != 'online') return null;
                final uri = Uri.tryParse(value?.trim() ?? '');
                if (uri == null ||
                    !uri.hasAuthority ||
                    !['http', 'https'].contains(uri.scheme)) {
                  return 'Masukkan tautan http atau https yang valid.';
                }
                return null;
              },
            ),
          ],
          if (provider.submitError != null) ...[
            const SizedBox(height: 10),
            Text(provider.submitError!,
                style: const TextStyle(color: Color(0xFFB3261E))),
          ],
          if (provider.didSubmit) ...[
            const SizedBox(height: 10),
            const Text('Sesi berhasil dijadwalkan.',
                style: TextStyle(
                    color: Color(0xFF1F6B57), fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: provider.isSubmitting ? null : () => _submit(provider),
            icon: provider.isSubmitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.event_available_outlined),
            label: Text(provider.isSubmitting
                ? 'Menyimpan jadwal...'
                : 'Buat jadwal sesi'),
          ),
        ],
      ),
    );
  }

  Widget _timeField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.schedule_outlined),
        border: const OutlineInputBorder(),
      ),
      validator: (_) => controller.text.isEmpty ? 'Pilih jam.' : null,
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateUtils.dateOnly(now),
      lastDate: DateTime(now.year + 2),
      locale: const Locale('id', 'ID'),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date = picked;
      _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    });
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _startTime = picked;
      _startController.text = picked.format(context);
      _timeError = null;
    });
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _endTime = picked;
      _endController.text = picked.format(context);
      _timeError = null;
    });
  }

  Future<void> _submit(BookingProvider provider) async {
    final valid = _formKey.currentState!.validate();
    final swap = provider.acceptedSkillSwaps
        .where((item) => item.id == _requestId)
        .firstOrNull;
    if (!valid ||
        swap == null ||
        _date == null ||
        _startTime == null ||
        _endTime == null) {
      return;
    }

    final start = _combine(_date!, _startTime!);
    final end = _combine(_date!, _endTime!);
    if (!end.isAfter(start)) {
      setState(() => _timeError = 'Waktu selesai harus setelah waktu mulai.');
      return;
    }

    setState(() => _timeError = null);
    await provider.submitBooking(
      SessionBookingDraft(
        requestId: swap.id,
        skillId: swap.skillId,
        teacherId: swap.teacherId,
        learnerId: swap.learnerId,
        date: DateUtils.dateOnly(_date!),
        startTime: start,
        endTime: end,
        mode: _mode,
        meetingLink:
            _mode == 'online' ? _meetingLinkController.text.trim() : '',
      ),
    );
  }

  DateTime _combine(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

class _BookingErrorState extends StatelessWidget {
  const _BookingErrorState({required this.message, required this.onRetry});

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

class _BookingEmptyState extends StatelessWidget {
  const _BookingEmptyState();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Icon(Icons.event_busy_outlined, size: 38, color: Color(0xFF68736E)),
            SizedBox(height: 10),
            Text('Belum ada permintaan yang diterima untuk dijadwalkan.'),
          ],
        ),
      );
}
