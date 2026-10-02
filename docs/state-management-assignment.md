# State Management Assignment

## Features

This assignment implements two SkillSwap workflows using Provider (`ChangeNotifier`):

1. Send a SkillSwap request from the Discover recommendations flow.
2. Schedule a session from an accepted SkillSwap request in the Sesi tab.

The application currently uses `InMemorySkillSwapRepository`. Data and created records live only in memory and reset when the app restarts. This keeps the feature runnable without Firebase project credentials while preserving a repository boundary that can later be implemented with Firestore.

## Responsibility boundaries

| Layer | Responsibility | Example files |
|---|---|---|
| Widget | Render state, collect input, validate fields, forward user actions | `lib/screens/request_screen.dart`, `lib/screens/booking_screen.dart` |
| Provider | Load/submit operations, hold view state, prevent duplicate submits, expose errors | `lib/providers/request_provider.dart`, `lib/providers/booking_provider.dart` |
| Repository | Supply available data and create request/booking records | `lib/services/skill_swap_repository.dart` |
| Model | Typed inputs and data exchanged between layers | `lib/models/workflow_models.dart` |

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

## Screenshot evidence

The screenshots/video must be captured from a running app; automated widget tests do not create visual evidence files. Create `docs/evidence/` and capture at least:

- `request-loaded.png`: Discover flow opened to the request form.
- `request-validation.png`: submit with an empty message and show its validation error.
- `request-submitting.png`: submit while the save operation is still pending.
- `booking-loaded.png`: booking form with an accepted request selected.
- `booking-validation.png`: submit without date/time or with an invalid meeting URL.
- `booking-submitting.png`: submit while the save operation is pending.
- `booking-empty-or-error.png`: show empty state or loading error with retry.

In VS Code, run the app on an Android emulator/device, open each state, then use **Capture Screenshot** from the emulator controls or the operating system screenshot tool. Add the resulting files under `docs/evidence/` and embed them here before submitting. Do not present placeholder images as captured evidence.

## AI use and review record

Prompt used:

> Implement two SkillSwap Flutter workflows, sending a skill exchange request and scheduling a session. Use the existing Provider state-management style and separate widget, notifier/provider, typed model, and repository responsibilities. Each workflow must expose initial loading, loaded, empty, error with retry, form validation, and submit loading that prevents double taps. Add deterministic widget tests for each state and document how to capture screenshot evidence. Use an in-memory repository because Firebase project configuration is not available, and clearly document that it is not persistent.

Before submission, the student should personally inspect and be able to explain:

- Why screens call a provider and do not call the repository directly.
- How the provider changes from loading to loaded/empty/error and how retry works.
- Why `isSubmitting` blocks a second submit and disables the button.
- How the booking date/time and meeting URL validators enforce the form rules.
- That the current in-memory repository is a demo boundary and must be replaced by Firestore for persistent multi-device data.
- Any changes made after reviewing generated code; record those changes here in the student's own words.

Student review notes:

