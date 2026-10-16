/// ============================================================
/// LOCAL DATA SCREEN — Halaman Riwayat Data Lokal
/// ============================================================
/// Halaman ini menampilkan semua data yang tersimpan secara
/// lokal di shared_preferences. User bisa melihat (READ),
/// mengubah (UPDATE), dan menghapus (DELETE) data request
/// serta booking yang sudah dibuat.
///
/// Fitur CRUD yang diimplementasikan:
///   - CREATE : via RequestScreen & BookingScreen (sudah ada)
///   - READ   : menampilkan list data dari local storage
///   - UPDATE : edit message/data request & booking
///   - DELETE : hapus individual request/booking
///
/// Lokasi kode:  lib/screens/local_data_screen.dart
/// ============================================================
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/workflow_models.dart';
import '../providers/local_data_provider.dart';

class LocalDataScreen extends StatefulWidget {
  const LocalDataScreen({super.key});

  @override
  State<LocalDataScreen> createState() => _LocalDataScreenState();
}

class _LocalDataScreenState extends State<LocalDataScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<LocalDataProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalDataProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---- Header ----
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Data Lokal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF193A36),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Muat ulang data lokal',
                    onPressed: provider.isLoading ? null : provider.loadAll,
                    icon: const Icon(Icons.refresh),
                  ),
                  // Badge jumlah data tersimpan
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9DE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${provider.requests.length + provider.bookings.length} tersimpan',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F6B57),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Data tersimpan secara lokal (shared_preferences) dan tetap ada setelah aplikasi di-restart.',
                style: TextStyle(fontSize: 13, color: Color(0xFF68736E)),
              ),
              const SizedBox(height: 4),
              // Persistence badge
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7E8),
                  border: Border.all(color: const Color(0xFFC8DDB8)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 16, color: Color(0xFF3D7D2A)),
                    SizedBox(width: 6),
                    Text(
                      'Persistence aktif — data bertahan setelah refresh/restart',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF3D7D2A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (provider.errorMessage != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
            child: Material(
              color: const Color(0xFFFFE9E7),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: const TextStyle(
                            color: Color(0xFF8C2B24), fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: provider.isLoading ? null : provider.loadAll,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),

        // ---- Tab Bar ----
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFECEFE5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF1F6B57),
              borderRadius: BorderRadius.circular(7),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: const Color(0xFF3D5147),
            labelStyle:
                const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text('Permintaan (${provider.requests.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.event_outlined, size: 16),
                    const SizedBox(width: 6),
                    Text('Booking (${provider.bookings.length})'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ---- Content ----
        Expanded(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _RequestListTab(
                      requests: provider.requests,
                      onDelete: provider.deleteRequest,
                      onUpdate: provider.updateRequest,
                    ),
                    _BookingListTab(
                      bookings: provider.bookings,
                      onDelete: provider.deleteBooking,
                      onUpdate: provider.updateBooking,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

// ===========================================================
//  Tab 1: List Permintaan (Request)
// ===========================================================
class _RequestListTab extends StatelessWidget {
  const _RequestListTab({
    required this.requests,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<SkillSwapRequestDraft> requests;
  final Future<void> Function(int index) onDelete;
  final Future<void> Function(int index, SkillSwapRequestDraft request)
      onUpdate;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const _EmptyDataView(
        icon: Icons.send_outlined,
        title: 'Belum ada permintaan tersimpan',
        subtitle:
            'Kirim permintaan SkillSwap dari halaman Temukan untuk melihat datanya di sini.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _RequestCard(
          index: index,
          request: request,
          onDelete: () => _confirmDelete(context, index),
          onEdit: () => _showEditDialog(context, index, request),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Permintaan'),
        content:
            const Text('Data akan dihapus permanen dari penyimpanan lokal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete(index);
            },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E)),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, int index, SkillSwapRequestDraft request) {
    showDialog<void>(
      context: context,
      builder: (_) => _RequestEditDialog(
        request: request,
        onSave: (updatedRequest) => onUpdate(index, updatedRequest),
      ),
    );
  }
}

class _RequestEditDialog extends StatefulWidget {
  const _RequestEditDialog({required this.request, required this.onSave});

  final SkillSwapRequestDraft request;
  final Future<void> Function(SkillSwapRequestDraft request) onSave;

  @override
  State<_RequestEditDialog> createState() => _RequestEditDialogState();
}

class _RequestEditDialogState extends State<_RequestEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.request.message);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Edit Permintaan'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ubah pesan permintaan yang tersimpan secara lokal.',
                style: TextStyle(fontSize: 13, color: Color(0xFF68736E)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Pesan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final message = value?.trim() ?? '';
                  if (message.isEmpty) return 'Pesan tidak boleh kosong.';
                  if (message.length > 300) {
                    return 'Pesan maksimal 300 karakter.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              final updatedRequest = SkillSwapRequestDraft(
                receiverId: widget.request.receiverId,
                teachSkill: widget.request.teachSkill,
                learnSkill: widget.request.learnSkill,
                message: _messageController.text.trim(),
              );
              Navigator.pop(context);
              widget.onSave(updatedRequest);
            },
            child: const Text('Simpan'),
          ),
        ],
      );
}

// ===========================================================
//  Tab 2: List Booking
// ===========================================================
class _BookingListTab extends StatelessWidget {
  const _BookingListTab({
    required this.bookings,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<SessionBookingDraft> bookings;
  final Future<void> Function(int index) onDelete;
  final Future<void> Function(int index, SessionBookingDraft booking) onUpdate;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const _EmptyDataView(
        icon: Icons.event_busy_outlined,
        title: 'Belum ada booking tersimpan',
        subtitle:
            'Buat jadwal sesi dari halaman Sesi untuk melihat datanya di sini.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _BookingCard(
          index: index,
          booking: booking,
          onDelete: () => _confirmDelete(context, index),
          onEdit: () => _showEditDialog(context, index, booking),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Booking'),
        content:
            const Text('Data akan dihapus permanen dari penyimpanan lokal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete(index);
            },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E)),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    int index,
    SessionBookingDraft booking,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => _BookingEditDialog(
        booking: booking,
        onSave: (updatedBooking) => onUpdate(index, updatedBooking),
      ),
    );
  }
}

class _BookingEditDialog extends StatefulWidget {
  const _BookingEditDialog({required this.booking, required this.onSave});

  final SessionBookingDraft booking;
  final Future<void> Function(SessionBookingDraft booking) onSave;

  @override
  State<_BookingEditDialog> createState() => _BookingEditDialogState();
}

class _BookingEditDialogState extends State<_BookingEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  late final TextEditingController _meetingLinkController;
  late String _mode;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.booking.date),
    );
    _startController = TextEditingController(
      text: DateFormat('HH:mm').format(widget.booking.startTime),
    );
    _endController = TextEditingController(
      text: DateFormat('HH:mm').format(widget.booking.endTime),
    );
    _meetingLinkController =
        TextEditingController(text: widget.booking.meetingLink);
    _mode = widget.booking.mode;
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
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Edit Booking'),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => DateTime.tryParse(value ?? '') == null
                    ? 'Masukkan tanggal yang valid.'
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startController,
                      decoration: const InputDecoration(
                        labelText: 'Mulai (HH:mm)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateTime,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _endController,
                      decoration: const InputDecoration(
                        labelText: 'Selesai (HH:mm)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                onChanged: (value) {
                  if (value != null) setState(() => _mode = value);
                },
              ),
              if (_mode == 'online') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _meetingLinkController,
                  decoration: const InputDecoration(
                    labelText: 'Tautan meeting',
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Simpan'),
          ),
        ],
      );

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final date = DateTime.parse(_dateController.text);
    final start = _parseDateTime(date, _startController.text);
    final end = _parseDateTime(date, _endController.text);
    if (!end.isAfter(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Waktu selesai harus setelah waktu mulai.')),
      );
      return;
    }
    final updatedBooking = SessionBookingDraft(
      requestId: widget.booking.requestId,
      skillId: widget.booking.skillId,
      teacherId: widget.booking.teacherId,
      learnerId: widget.booking.learnerId,
      date: date,
      startTime: start,
      endTime: end,
      mode: _mode,
      meetingLink: _mode == 'online' ? _meetingLinkController.text.trim() : '',
    );
    Navigator.pop(context);
    widget.onSave(updatedBooking);
  }

  String? _validateTime(String? value) {
    if (value == null ||
        !RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$').hasMatch(value)) {
      return 'Gunakan format HH:mm.';
    }
    return null;
  }

  DateTime _parseDateTime(DateTime date, String time) {
    final parts = time.split(':').map(int.parse).toList();
    return DateTime(date.year, date.month, date.day, parts[0], parts[1]);
  }
}

// ===========================================================
//  Request Card Widget
// ===========================================================
class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.index,
    required this.request,
    required this.onDelete,
    required this.onEdit,
  });

  final int index;
  final SkillSwapRequestDraft request;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: const Color(0xFFE5E8DF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7D9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF6B5D3E),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.send_outlined,
                  size: 16, color: Color(0xFF1F6B57)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Permintaan SkillSwap',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF193A36),
                  ),
                ),
              ),
              // Action buttons
              _ActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF1F6B57),
                  onTap: onEdit),
              const SizedBox(width: 4),
              _ActionButton(
                  icon: Icons.delete_outline,
                  color: const Color(0xFFB3261E),
                  onTap: onDelete),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFECEFE5)),
          // Data fields
          _DataRow(label: 'Penerima ID', value: request.receiverId),
          _DataRow(label: 'Skill Mengajar', value: request.teachSkill),
          _DataRow(label: 'Skill Dipelajari', value: request.learnSkill),
          _DataRow(label: 'Pesan', value: request.message),
          const SizedBox(height: 6),
          // Storage info
          const _StorageBadge(),
        ],
      ),
    );
  }
}

// ===========================================================
//  Booking Card Widget
// ===========================================================
class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.index,
    required this.booking,
    required this.onDelete,
    required this.onEdit,
  });

  final int index;
  final SessionBookingDraft booking;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: const Color(0xFFE5E8DF)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9E8ED),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3E5F6B),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.event_outlined,
                  size: 16, color: Color(0xFF1F6B57)),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Jadwal Sesi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF193A36),
                  ),
                ),
              ),
              _ActionButton(
                  icon: Icons.edit_outlined,
                  color: const Color(0xFF1F6B57),
                  onTap: onEdit),
              const SizedBox(width: 4),
              _ActionButton(
                  icon: Icons.delete_outline,
                  color: const Color(0xFFB3261E),
                  onTap: onDelete),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFECEFE5)),
          // Data fields
          _DataRow(label: 'Skill ID', value: booking.skillId),
          _DataRow(label: 'Tanggal', value: dateFormat.format(booking.date)),
          _DataRow(
              label: 'Waktu',
              value:
                  '${timeFormat.format(booking.startTime)} — ${timeFormat.format(booking.endTime)}'),
          _DataRow(
              label: 'Mode',
              value: booking.mode == 'online' ? 'Online' : 'Tatap muka'),
          if (booking.mode == 'online' && booking.meetingLink.isNotEmpty)
            _DataRow(label: 'Meeting Link', value: booking.meetingLink),
          const SizedBox(height: 6),
          const _StorageBadge(),
        ],
      ),
    );
  }
}

// ===========================================================
//  Shared Widgets
// ===========================================================
class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF68736E),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF193A36),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: color.withAlpha(50)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

class _StorageBadge extends StatelessWidget {
  const _StorageBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.storage_outlined, size: 12, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          'shared_preferences',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyDataView extends StatelessWidget {
  const _EmptyDataView({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF9CB9A8)),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF193A36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF68736E)),
            ),
          ],
        ),
      ),
    );
  }
}
