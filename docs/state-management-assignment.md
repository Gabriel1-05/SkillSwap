# State Management Assignment

## Features

This assignment implements SkillSwap workflows using Provider (`ChangeNotifier`):

1. Send a SkillSwap request from the Discover recommendations flow.
2. Schedule a session from an accepted SkillSwap request in the Sesi tab.
3. Browse, update, and delete locally saved requests and session bookings.

The app uses `LocalSkillSwapRepository` backed by Flutter `shared_preferences`. Created requests and bookings are JSON-encoded records and persist on the device across app restarts. The in-memory repository remains available for deterministic widget tests.

## Responsibility boundaries

| Layer | Responsibility | Example files |
|---|---|---|
| Layer | Responsibility | Local Data & Persistence files |
|---|---|---|
| Widget | Display records; collect create/edit input; confirm deletion | `lib/screens/local_data_screen.dart`, `lib/screens/request_screen.dart`, `lib/screens/booking_screen.dart` |
| Provider | Load, create, update, and delete state; surface persistence errors | `lib/providers/local_data_provider.dart`, `lib/providers/request_provider.dart`, `lib/providers/booking_provider.dart` |
| Repository | CRUD boundary and mapping between models and storage | `lib/services/skill_swap_repository.dart`, `lib/services/local_skill_swap_repository.dart` |
| Storage | JSON serialization and durable key/value collections | `lib/services/local_storage_service.dart` |
| Model | Typed request and session booking records with JSON conversion | `lib/models/workflow_models.dart` |
| Bootstrap | Initialize storage and seed defaults before the first frame | `lib/main.dart` |

## Local Data demo and reviewer guide

Panduan demo lengkap, alur CRUD, posisi kode, batasan storage, dan cara verifikasi ada di [`local-data-persistence-demo.md`](local-data-persistence-demo.md).

1. Open **Temukan** → **Kirim permintaan**, complete the form, and submit. This is Create.
2. Open **Data Lokal** → **Permintaan** to read the saved request. Use the edit and delete actions for Update and Delete.
3. Open **Sesi**, create a booking, then return to **Data Lokal** → **Booking** to read, edit, or delete it.
4. Close and reopen the app (or restart the Flutter web page), open **Data Lokal**, and confirm the remaining records are still present.

The persistence test recreates the repository over the same mocked preferences to verify records survive reopening: `test/services/local_skill_swap_repository_test.dart`. Run it with:

```powershell
flutter test test/services/local_skill_swap_repository_test.dart
```

Storage is device/browser-local and is not synchronized to another device or user account.

## UI states

| State | Request | Booking |
|---|---|---|
| Initial loading | Candidate list is loading | Accepted requests are loading |
| Loaded | Candidate and request form are visible | Accepted request and booking form are visible |
| Empty | No candidates available | No accepted request is available |
| Error and retry | Candidate loading error with `Coba lagi` | Accepted-request loading error with `Coba lagi` |
| Form validation | Candidate/skills required and message 1–300 characters | Accepted request, non-past date, both times, valid order, and valid online URL |
| Submit loading | Button disabled and shows `Mengirim...` | Button disabled and shows `Menyimpan jadwal...` |

## Automated tests

Run all project checks from the repository root:

```powershell
flutter analyze
flutter test
```

Focused feature tests:

```powershell
flutter test test/screens/request_screen_test.dart
flutter test test/screens/booking_screen_test.dart
```

Tests use a controllable fake repository so loading and submit states can be held open deterministically. Test files cover loading, loaded, empty, load error/retry, form validation, and duplicate-submit protection.
The repository test separately covers local request/booking CRUD and persistence after reopening.

## Screenshot evidence

The screenshots/video must be captured from a running app; automated widget tests do not create visual evidence files. Create `docs/evidence/` and capture at least:

- `request-loaded.png`: Discover flow opened to the request form.
- `request-validation.png`: submit with an empty message and show its validation error.
- `request-submitting.png`: submit while the save operation is still pending.
- `booking-loaded.png`: booking form with an accepted request selected.
- `booking-validation.png`: submit without date/time or with an invalid meeting URL.
- `booking-submitting.png`: submit while the save operation is pending.
- `booking-empty-or-error.png`: show empty state or loading error with retry.
- `local-data-request.png`: saved request visible in the local data list.
- `local-data-booking.png`: saved booking visible in the local data list.

In VS Code, run the app on an Android emulator/device, open each state, then use **Capture Screenshot** from the emulator controls or the operating system screenshot tool. Add the resulting files under `docs/evidence/` and embed them here before submitting. Do not present placeholder images as captured evidence.

## AI use and review record

Prompt used:

> Implement two SkillSwap Flutter workflows, sending a skill exchange request and scheduling a session. Use the existing Provider state-management style and separate widget, notifier/provider, typed model, and repository responsibilities. Each workflow must expose initial loading, loaded, empty, error with retry, form validation, and submit loading that prevents double taps. Add deterministic widget tests for each state and document how to capture screenshot evidence. The app's local data workflow uses SharedPreferences for local persistence; in-memory storage remains only as a test fake.

Before submission, the student should personally inspect and be able to explain:

- Why screens call a provider and do not call the repository directly.
- How the provider changes from loading to loaded/empty/error and how retry works.
- Why `isSubmitting` blocks a second submit and disables the button.
- How the booking date/time and meeting URL validators enforce the form rules.
- That SharedPreferences keeps records on this device/browser but does not provide cross-device synchronization.
- Any changes made after reviewing generated code; record those changes here in the student's own words.

Student review notes:
