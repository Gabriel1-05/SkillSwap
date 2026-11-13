import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/models/profile_details.dart';
import 'package:skillswap/providers/profile_provider.dart';
import 'package:skillswap/services/profile_repository.dart';

class _PendingProfileRepository implements ProfileRepository {
  final completer = Completer<ProfileDetails>();

  @override
  Future<ProfileDetails> loadCurrentProfile() => completer.future;

  @override
  Future<void> saveCurrentProfile(ProfileDetails profile) async {}
}

void main() {
  test('clearing on sign-out prevents a pending read restoring old profile',
      () async {
    final repository = _PendingProfileRepository();
    final provider = ProfileProvider(repository: repository);
    const oldProfile = ProfileDetails(
      name: 'Ayu Lestari',
      university: 'Universitas Indonesia',
      major: 'Informatika',
    );

    final load = provider.loadCurrentProfile('user-a');
    expect(provider.isLoading, isTrue);

    provider.clear();
    repository.completer.complete(oldProfile);
    await load;

    expect(provider.profile, isNull);
    expect(provider.isLoading, isFalse);
    provider.dispose();
  });
}
