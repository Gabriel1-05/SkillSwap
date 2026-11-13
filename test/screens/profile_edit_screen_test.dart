import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/models/profile_details.dart';
import 'package:skillswap/providers/profile_provider.dart';
import 'package:skillswap/screens/profile_edit_screen.dart';
import 'package:skillswap/services/profile_repository.dart';

class _FakeProfileRepository implements ProfileRepository {
  _FakeProfileRepository(this.profile);

  ProfileDetails profile;
  ProfileDetails? savedProfile;

  @override
  Future<ProfileDetails> loadCurrentProfile() async => profile;

  @override
  Future<void> saveCurrentProfile(ProfileDetails value) async {
    savedProfile = value;
    profile = value;
  }
}

const _initialProfile = ProfileDetails(
  name: 'Ayu Lestari',
  university: 'Universitas Indonesia',
  major: 'Informatika',
);

Widget _profileEditorApp(_FakeProfileRepository repository) =>
    ChangeNotifierProvider(
      create: (_) => ProfileProvider(repository: repository),
      child: const MaterialApp(
        home: ProfileEditScreen(uid: 'user-123'),
      ),
    );

void main() {
  testWidgets('loads and saves profile fields with visible status',
      (tester) async {
    final repository = _FakeProfileRepository(_initialProfile);
    await tester.pumpWidget(_profileEditorApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Rina Putri');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Universitas Gadjah Mada');
    await tester.enterText(
        find.byType(TextFormField).at(2), 'Sistem Informasi');
    await tester.tap(find.text('Simpan profil'));
    await tester.pumpAndSettle();

    expect(repository.savedProfile?.name, 'Rina Putri');
    expect(repository.savedProfile?.university, 'Universitas Gadjah Mada');
    expect(repository.savedProfile?.major, 'Sistem Informasi');
    expect(find.text('Profil berhasil disimpan.'), findsOneWidget);
  });

  testWidgets('validates profile input before requesting the repository',
      (tester) async {
    final repository = _FakeProfileRepository(_initialProfile);
    await tester.pumpWidget(_profileEditorApp(repository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'A');
    await tester.tap(find.text('Simpan profil'));
    await tester.pumpAndSettle();

    expect(find.text('Nama harus 2 sampai 50 karakter.'), findsOneWidget);
    expect(repository.savedProfile, isNull);
  });
}
