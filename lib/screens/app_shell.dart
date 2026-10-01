import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/match_result.dart';
import '../models/view_state.dart';
import 'auth_screen.dart';
import '../providers/discover_provider.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Beranda'),
    NavigationDestination(icon: Icon(Icons.travel_explore), label: 'Temukan'),
    NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
    NavigationDestination(icon: Icon(Icons.event_outlined), label: 'Sesi'),
    NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomePage(),
      const _DiscoverPage(),
      const _ComingSoonPage(
        icon: Icons.forum_outlined,
        title: 'Percakapanmu',
        subtitle: 'Chat akan tersedia setelah permintaan SkillSwap diterima.',
      ),
      const _ComingSoonPage(
        icon: Icons.calendar_month_outlined,
        title: 'Ruang belajarmu',
        subtitle: 'Jadwalkan sesi belajar bersama teman yang cocok.',
      ),
      const _ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: _destinations,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFFFCFCF8),
        indicatorColor: const Color(0xFFDDEBE3),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscoverProvider>();
    final featured = provider.matches.isEmpty ? null : provider.matches.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 32),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('KAMIS, 1 OKTOBER',
                      style: TextStyle(
                        color: Color(0xFF6F7B72),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      )),
                  SizedBox(height: 8),
                  Text('Halo, Gabriel.',
                      style: TextStyle(
                        color: Color(0xFF193A36),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      )),
                ],
              ),
            ),
            const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFDCE9DE),
              child: Text('G', style: TextStyle(color: Color(0xFF1F6B57), fontWeight: FontWeight.w800)),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF1F6B57),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.swap_horiz_rounded, color: Color(0xFFFFD58A), size: 28),
              SizedBox(height: 22),
              Text('Belajar satu hal baru.\nBagikan yang kamu tahu.',
                  style: TextStyle(color: Colors.white, fontSize: 23, height: 1.16, fontWeight: FontWeight.w800)),
              SizedBox(height: 10),
              Text('Skill tumbuh lebih cepat saat dipelajari bersama.',
                  style: TextStyle(color: Color(0xFFD8E8DF), fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const _SectionHeading(title: 'Skill kamu', action: 'Ubah'),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _SkillTag(label: 'Bisa mengajar  ·  UI/UX', color: Color(0xFFE9E5D7)),
            _SkillTag(label: 'Bisa mengajar  ·  HTML/CSS', color: Color(0xFFE9E5D7)),
            _SkillTag(label: 'Ingin belajar  ·  Python', color: Color(0xFFDCE9DE)),
            _SkillTag(label: 'Ingin belajar  ·  Data Science', color: Color(0xFFDCE9DE)),
          ],
        ),
        const SizedBox(height: 30),
        _SectionHeading(
          title: 'Teman yang cocok',
          action: 'Lihat semua',
          onTap: () => context.findAncestorStateOfType<_AppShellState>()?._goToDiscover(),
        ),
        const SizedBox(height: 12),
        if (featured != null) _MatchCard(match: featured),
      ],
    );
  }
}

class _DiscoverPage extends StatelessWidget {
  const _DiscoverPage();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiscoverProvider>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 32),
      children: [
        const Text('Temukan teman belajar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF193A36))),
        const SizedBox(height: 8),
        const Text('Rekomendasi berdasarkan skill dan waktu luangmu.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFECEFE5), borderRadius: BorderRadius.circular(8)),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome_outlined, color: Color(0xFF1F6B57)),
              SizedBox(width: 12),
              Expanded(child: Text('Rekomendasi untuk belajar Python', style: TextStyle(color: Color(0xFF193A36), fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        const SizedBox(height: 18),
        if (provider.state == ViewState.loading)
          const Center(child: Padding(padding: EdgeInsets.all(28), child: CircularProgressIndicator()))
        else if (provider.state == ViewState.empty)
          const _EmptyRecommendations()
        else
          ...provider.matches.map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MatchCard(match: match),
              )),
      ],
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});

  final MatchResult match;

  @override
  Widget build(BuildContext context) {
    final user = match.user;
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        border: Border.all(color: const Color(0xFFE5E8DF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 23,
                backgroundColor: const Color(0xFFFFE7C1),
                child: Text(user.name.substring(0, 1), style: const TextStyle(color: Color(0xFF754C1E), fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF193A36))),
                  const SizedBox(height: 3),
                  Text(user.major, style: const TextStyle(fontSize: 12, color: Color(0xFF68736E))),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('${match.displayPercent}%', style: const TextStyle(color: Color(0xFF1F6B57), fontSize: 20, fontWeight: FontWeight.w800)),
                const Text('KECOCOKAN', style: TextStyle(color: Color(0xFF68736E), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Icon(Icons.star_rounded, color: Color(0xFFE9A64A), size: 18),
            const SizedBox(width: 4),
            Text(user.ratingCount == 0 ? 'Belum ada ulasan' : user.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
            const Text('·'),
            const SizedBox(width: 8),
            Text(user.learningMode == 'online' ? 'Online' : user.learningMode == 'offline' ? 'Tatap muka' : 'Fleksibel', style: const TextStyle(fontSize: 12, color: Color(0xFF68736E))),
          ]),
          const SizedBox(height: 14),
          Wrap(spacing: 7, runSpacing: 7, children: user.teachSkillIds.map((skill) => _SkillTag(label: 'Mengajar  ·  ${_prettySkill(skill)}', color: const Color(0xFFE9E5D7))).toList()),
          if (match.isTwoWay) ...[
            const SizedBox(height: 13),
            const Row(children: [Icon(Icons.swap_horiz, size: 17, color: Color(0xFF1F6B57)), SizedBox(width: 5), Text('Pertukaran dua arah', style: TextStyle(color: Color(0xFF1F6B57), fontWeight: FontWeight.w700, fontSize: 12))]),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1, size: 17),
              label: const Text('Lihat profil'),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1F6B57), side: const BorderSide(color: Color(0xFF9CB9A8)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<DiscoverProvider>().currentUser;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 30, 22, 32),
      children: [
        const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF193A36))),
        const SizedBox(height: 26),
        CircleAvatar(radius: 38, backgroundColor: const Color(0xFFDCE9DE), child: Text(user.name.substring(0, 1), style: const TextStyle(fontSize: 28, color: Color(0xFF1F6B57), fontWeight: FontWeight.w800))),
        const SizedBox(height: 14),
        Center(child: Text(user.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF193A36)))),
        const SizedBox(height: 5),
        Center(child: Text('${user.major} · ${user.university}', textAlign: TextAlign.center)),
        const SizedBox(height: 30),
        const _SectionHeading(title: 'Bisa mengajar'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: user.teachSkillIds.map((skill) => _SkillTag(label: _prettySkill(skill), color: const Color(0xFFE9E5D7))).toList()),
        const SizedBox(height: 24),
        const _SectionHeading(title: 'Ingin belajar'),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: user.learnSkillIds.map((skill) => _SkillTag(label: _prettySkill(skill), color: const Color(0xFFDCE9DE))).toList()),
        const SizedBox(height: 24),
        const ListTile(leading: Icon(Icons.schedule_outlined), title: Text('Ketersediaan'), subtitle: Text('Rabu malam, Sabtu, Minggu')),
        const ListTile(leading: Icon(Icons.laptop_mac_outlined), title: Text('Mode belajar'), subtitle: Text('Online')),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const AuthScreen()),
          ),
          icon: const Icon(Icons.login),
          label: const Text('Masuk atau daftar dengan Firebase'),
        ),
      ],
    );
  }
}

class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(34),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 42, color: const Color(0xFF1F6B57)),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF193A36))),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
          ]),
        ),
      );
}

class _EmptyRecommendations extends StatelessWidget {
  const _EmptyRecommendations();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(children: [Icon(Icons.search_off, size: 38, color: Color(0xFF839087)), SizedBox(height: 12), Text('Belum ada teman yang cocok')]),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.action, this.onTap});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Color(0xFF193A36)))),
        if (action != null) TextButton(onPressed: onTap, child: Text(action!, style: const TextStyle(fontSize: 12))),
      ]);
}

class _SkillTag extends StatelessWidget {
  const _SkillTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
        child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF3D5147), fontWeight: FontWeight.w600)),
      );
}

String _prettySkill(String skill) => skill.split('-').map((part) => '${part[0].toUpperCase()}${part.substring(1)}').join('/');

extension on _AppShellState {
  void _goToDiscover() => setState(() => _selectedIndex = 1);
}