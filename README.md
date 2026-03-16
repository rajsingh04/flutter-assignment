## Flutter Instagram-Inspired Home Feed

This project is a Flutter app that recreates an Instagram-inspired home feed, including:
- Top bar with common Instagram-style actions
- Stories tray as the first item in the feed
- Infinite-scrolling post feed with mock data
- Shimmer loading state and pinch-to-zoom on post images

---

## State Management

This app uses **BLoC (Business Logic Component)** via the `flutter_bloc` package for state management.

**Why BLoC?**
- **Clear separation of concerns**: UI widgets stay focused on rendering, while `PostBloc` handles fetching posts, pagination, and error handling.
- **Testability**: Business logic (events -> states) can be tested independently from widgets.
- **Scalability**: As features grow (stories, reactions, networking), BLoC scales cleanly with additional events and states instead of ad-hoc `setState` calls.

Key pieces:
- `PostBloc` — orchestrates loading the feed and pagination.
- `PostEvent` — defines user/intents such as `PostInitialRequested` and `PostMoreRequested`.
- `PostState` — exposes UI-ready state: posts list, loading flags, and error messages.

---

## How to Run the App

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and added to your PATH
- A connected device or emulator (Android, iOS, web, or desktop)

### 1. Fetch Dependencies

```bash
flutter pub get
```

### 2. Run the App in Debug Mode

```bash
flutter run
```

If you have multiple devices attached, select the target when prompted or specify it explicitly, for example:

```bash
flutter run -d chrome    # Web
flutter run -d ios       # iOS simulator
flutter run -d android   # Android device/emulator
```

---

## How to Build Release Artifacts

Use the appropriate command for your target platform:

- Android APK:

	```bash
	flutter build apk --release
	```

- Android App Bundle:

	```bash
	flutter build appbundle --release
	```

- iOS (from macOS, codesigning required):

	```bash
	flutter build ios --release
	```

Refer to the Flutter docs for additional platforms and deployment details.

---

## GitHub Repository
```text
https://github.com/rajsingh04/flutter-assignment
```

