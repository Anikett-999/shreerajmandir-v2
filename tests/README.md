# Tests — guidance and stubs

This folder contains test guidance and starter stubs.

Recommended approach:
- Unit tests for service layer (mock Firestore)
- Integration tests for critical flows (KOT creation, billing)
- E2E tests using emulator or test Firebase project

Suggested commands (local):

```bash
# run Dart/Flutter unit tests
flutter test

# start Firestore emulator (if configured)
firebase emulators:start --only firestore
```

Place automated test scripts here when ready. I can scaffold example unit tests if you want.