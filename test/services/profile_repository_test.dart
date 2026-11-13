import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/models/profile_details.dart';
import 'package:skillswap/services/profile_repository.dart';

class _FakeProfileIdentity implements ProfileIdentity {
  _FakeProfileIdentity({this.uid = 'user-123'});

  @override
  final String? uid;

  @override
  String? get email => 'learner@example.com';

  @override
  String? get displayName => 'Learner';
}

class _FakeProfileDataSource implements ProfileDataSource {
  Map<String, dynamic>? document;
  String? readUid;
  String? writeUid;
  Map<String, dynamic>? createdProfile;
  Map<String, dynamic>? updatedFields;

  @override
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    readUid = uid;
    return document;
  }

  @override
  Future<void> createProfile(String uid, Map<String, dynamic> profile) async {
    writeUid = uid;
    createdProfile = profile;
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> fields) async {
    writeUid = uid;
    updatedFields = fields;
  }
}

const _validProfile = ProfileDetails(
  name: 'Ayu Lestari',
  university: 'Universitas Indonesia',
  major: 'Informatika',
);

void main() {
  group('FirestoreProfileRepository', () {
    test('reads only the authenticated user document', () async {
      final source = _FakeProfileDataSource()
        ..document = {
          'id': 'user-123',
          'name': 'Ayu Lestari',
          'university': 'Universitas Indonesia',
          'major': 'Informatika',
        };
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(),
      );

      final profile = await repository.loadCurrentProfile();

      expect(source.readUid, 'user-123');
      expect(profile.name, 'Ayu Lestari');
    });

    test(
        'creates a new profile with the authenticated identity and safe defaults',
        () async {
      final source = _FakeProfileDataSource();
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(),
      );

      await repository.saveCurrentProfile(_validProfile);

      expect(source.readUid, 'user-123');
      expect(source.writeUid, 'user-123');
      expect(source.createdProfile?['email'], 'learner@example.com');
      expect(source.createdProfile?['teachSkillIds'], isEmpty);
      expect(source.createdProfile?['rating'], 0);
      expect(source.createdProfile?['ratingCount'], 0);
      expect(source.updatedFields, isNull);
    });

    test('updates editable fields only and leaves server fields untouched',
        () async {
      final source = _FakeProfileDataSource()
        ..document = {
          'id': 'user-123',
          'name': 'Ayu Lestari',
          'university': 'Universitas Indonesia',
          'major': 'Informatika',
          'rating': 5.0,
          'ratingCount': 2,
        };
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(),
      );

      await repository.saveCurrentProfile(_validProfile);

      expect(source.writeUid, 'user-123');
      expect(
        source.updatedFields,
        {
          'name': 'Ayu Lestari',
          'university': 'Universitas Indonesia',
          'major': 'Informatika',
        },
      );
      expect(source.createdProfile, isNull);
    });

    test('refuses access without a signed-in user', () async {
      final source = _FakeProfileDataSource();
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(uid: null),
      );

      await expectLater(
        repository.loadCurrentProfile(),
        throwsA(isA<ProfileRepositoryException>()),
      );
      expect(source.readUid, isNull);
    });

    test('rejects invalid fields before making a backend request', () async {
      final source = _FakeProfileDataSource();
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(),
      );

      await expectLater(
        repository.saveCurrentProfile(
          const ProfileDetails(name: 'A', university: '', major: 'Informatika'),
        ),
        throwsA(isA<ProfileRepositoryException>()),
      );
      expect(source.readUid, isNull);
      expect(source.createdProfile, isNull);
    });

    test('rejects a stored profile whose document id does not match the user',
        () async {
      final source = _FakeProfileDataSource()
        ..document = {
          'id': 'someone-else',
          'name': 'Ayu Lestari',
          'university': 'Universitas Indonesia',
          'major': 'Informatika',
        };
      final repository = FirestoreProfileRepository(
        dataSource: source,
        identity: _FakeProfileIdentity(),
      );

      await expectLater(
        repository.loadCurrentProfile(),
        throwsA(isA<ProfileRepositoryException>()),
      );
    });
  });
}
