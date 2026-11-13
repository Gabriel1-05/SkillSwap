// Run with:
// firebase emulators:exec --only auth,firestore --config firebase.test.json --project demo-skillswap "node test/firestore_rules_test.mjs"

const projectId = process.env.GCLOUD_PROJECT ?? 'demo-skillswap';
const authHost = process.env.FIREBASE_AUTH_EMULATOR_HOST;
const firestoreHost = process.env.FIRESTORE_EMULATOR_HOST;

if (!authHost || !firestoreHost) {
  throw new Error('Run this file through Firebase Auth and Firestore emulators.');
}

async function createTestUser(email) {
  const url = new URL(
    `http://${authHost}/identitytoolkit.googleapis.com/v1/accounts:signUp`,
  );
  url.searchParams.set('key', 'fake-api-key');
  const response = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password: 'test-password-123', returnSecureToken: true }),
  });
  if (!response.ok) {
    throw new Error(`Auth emulator could not create a test user (${response.status}).`);
  }
  return response.json();
}

function profileFields(uid, email, { name = 'Ayu Lestari', extra = {} } = {}) {
  return {
    id: { stringValue: uid },
    email: { stringValue: email },
    name: { stringValue: name },
    university: { stringValue: 'Universitas Indonesia' },
    major: { stringValue: 'Informatika' },
    teachSkillIds: { arrayValue: { values: [] } },
    learnSkillIds: { arrayValue: { values: [] } },
    availability: { arrayValue: { values: [] } },
    learningMode: { stringValue: 'online' },
    rating: { integerValue: '0' },
    ratingCount: { integerValue: '0' },
    ...extra,
  };
}

async function firestoreRequest(path, { token, method = 'GET', body } = {}) {
  const response = await fetch(`http://${firestoreHost}/v1/${path}`, {
    method,
    headers: {
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'Content-Type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  return { status: response.status, body: await response.json().catch(() => null) };
}

function documentPath(uid) {
  return `projects/${projectId}/databases/(default)/documents/users/${encodeURIComponent(uid)}`;
}

async function expectStatus(label, result, expected) {
  if (result.status !== expected) {
    throw new Error(`${label}: expected HTTP ${expected}, got ${result.status}.`);
  }
}

const owner = await createTestUser('profile-owner@example.test');
const stranger = await createTestUser('profile-stranger@example.test');
const ownerPath = documentPath(owner.localId);

await expectStatus(
  'owner creates a valid profile',
  await firestoreRequest(
    `projects/${projectId}/databases/(default)/documents/users?documentId=${encodeURIComponent(owner.localId)}`,
    {
      token: owner.idToken,
      method: 'POST',
      body: { fields: profileFields(owner.localId, owner.email) },
    },
  ),
  200,
);

await expectStatus(
  'owner reads their profile',
  await firestoreRequest(ownerPath, { token: owner.idToken }),
  200,
);

await expectStatus(
  'another account cannot read the profile',
  await firestoreRequest(ownerPath, { token: stranger.idToken }),
  403,
);

await expectStatus(
  'another account cannot update the profile',
  await firestoreRequest(`${ownerPath}?updateMask.fieldPaths=name`, {
    token: stranger.idToken,
    method: 'PATCH',
    body: { fields: { name: { stringValue: 'Changed by stranger' } } },
  }),
  403,
);

await expectStatus(
  'owner can update an allowed profile field',
  await firestoreRequest(`${ownerPath}?updateMask.fieldPaths=name`, {
    token: owner.idToken,
    method: 'PATCH',
    body: { fields: { name: { stringValue: 'Ayu Updated' } } },
  }),
  200,
);

await expectStatus(
  'owner cannot change rating fields',
  await firestoreRequest(`${ownerPath}?updateMask.fieldPaths=rating`, {
    token: owner.idToken,
    method: 'PATCH',
    body: { fields: { rating: { integerValue: '100' } } },
  }),
  403,
);

await expectStatus(
  'owner cannot create a profile under another uid',
  await firestoreRequest(
    `projects/${projectId}/databases/(default)/documents/users?documentId=${encodeURIComponent(stranger.localId)}`,
    {
      token: owner.idToken,
      method: 'POST',
      body: { fields: profileFields(stranger.localId, owner.email) },
    },
  ),
  403,
);

await expectStatus(
  'profile create rejects unexpected fields',
  await firestoreRequest(
    `projects/${projectId}/databases/(default)/documents/users?documentId=${encodeURIComponent(stranger.localId)}`,
    {
      token: stranger.idToken,
      method: 'POST',
      body: {
        fields: profileFields(stranger.localId, stranger.email, {
          extra: { role: { stringValue: 'admin' } },
        }),
      },
    },
  ),
  403,
);

console.log('Firestore profile rules passed: owner scope, field allowlist, protected ratings.');
