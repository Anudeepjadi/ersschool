# Ecstasy School ERP

Ecstasy School ERP (`ersschool`) is a cross-platform Flutter application for managing and viewing school operations across **student**, **teacher**, **admin**, and **AI assistant** workflows.

The app includes role-based login screens, dashboards, attendance and timetable features, student records, fee reports, charts, PDF generation and printing, calendar tools, language switching, theme settings, and locally persisted application data.

## Features

### Role-based access

- Student, teacher, and administrator login flows
- Role-specific dashboards and navigation
- Separate screens and widgets for each user role

### School management

- Student and staff profile views
- Timetable and attendance information
- Academic, fee, and report-related screens
- Charts and summaries for data visualization
- Calendar and custom date-picker components
- PDF generation and printing support

### App experience

- Splash screen with school branding and animation
- Light and dark themes
- English and other language support through `LanguageManager`
- Persistent profile and application preferences with `shared_preferences`
- Responsive scrollable tables and mobile-friendly layouts
- Shared footer and navigation components

## Supported Platforms

The repository contains Flutter platform projects for:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

Flutter web uses a light theme regardless of the locally selected theme.

## Technology Stack

- **Framework:** Flutter and Dart
- **Minimum Dart SDK:** 3.0.0
- **State management:** `ValueListenableBuilder`, `AnimatedBuilder`, and app-level singleton managers
- **Local persistence:** `shared_preferences`
- **Charts:** `fl_chart`
- **PDF:** `pdf` and `printing`
- **Media:** `video_player` and `image_picker`
- **Files:** `file_picker`, `path_provider`, and `open_filex`
- **Navigation and external links:** `url_launcher`
- **Fonts and icons:** `google_fonts` and Cupertino icons

## Getting Started

### Prerequisites

Install the following before running the project:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK included with Flutter
- Git
- A platform-specific toolchain:
  - Android Studio and Android SDK for Android
  - Xcode for iOS or macOS
  - Visual Studio with Desktop development with C++ for Windows
  - Required Linux desktop build dependencies for Linux

Verify your setup:

```bash
flutter doctor
```

### Clone the repository

```bash
git clone https://github.com/Anudeepjadi/ersschool.git
cd ersschool
```

### Install dependencies

```bash
flutter pub get
```

## Run the App

### Android or iOS

```bash
flutter run
```

Select a connected device or emulator from the prompt, or specify a device with:

```bash
flutter devices
flutter run -d <device-id>
```

### Web

```bash
flutter run -d chrome
```

### Windows

```bash
flutter run -d windows
```

### macOS

```bash
flutter run -d macos
```

### Linux

```bash
flutter run -d linux
```

## Application Startup

When `lib/main.dart` starts, the app performs the following sequence:

1. Initializes the Flutter binding layer.
2. Initializes `ProfileManager` to restore profile, preference, and theme settings.
3. Initializes `AppDataStore` to load or prepare application data.
4. Creates `ERPApp` and starts `MaterialApp`.
5. Applies light or dark theme settings.
6. Opens `SplashScreen`.

After the splash flow finishes, the app navigates to the login interface.

## Project Structure

```text
lib/
├── main.dart                 # Application entry point and root MaterialApp
├── core/
│   ├── data/                 # Shared application data and stores
│   ├── localization/         # Language and localization management
│   ├── theme/                # Light/dark themes and app styling
│   └── utils/                # Profile and shared utility logic
├── screens/
│   ├── admin/                # Administrator screens
│   ├── ai_assistant/         # AI assistant interface
│   ├── dashboard/            # Shared dashboard flows
│   ├── login/                # Login and authentication screens
│   ├── splash/               # Startup and splash experience
│   ├── student/              # Student-specific features
│   └── teacher/              # Teacher-specific features
└── widgets/                  # Reusable UI components

assets/
├── animations/               # Animation and video resources
└── images/                   # Logos, profiles, and UI images

test/
└── widget_test.dart          # Splash-to-login widget test

android/ ios/ web/ linux/ macos/ windows/
└── Platform-specific runner projects
```

## Core Components

### `ProfileManager`

Located under `lib/core/utils/`, `ProfileManager` initializes persisted user preferences and exposes the selected theme mode as a `ValueNotifier`.

### `AppDataStore`

Located under `lib/core/data/`, `AppDataStore` acts as the shared in-memory and persistent application data store for the app.

### `LanguageManager`

Located under `lib/core/localization/`, `LanguageManager` drives localization updates. `ERPApp` rebuilds when its language state changes.

### `AppTheme`

Located under `lib/core/theme/`, `AppTheme` defines the application's light and dark themes.

### Reusable widgets

The `lib/widgets/` directory contains shared components, including:

- Application footer
- Calendar popup
- Custom date picker
- Scrollable table wrapper

## Assets

Declared Flutter assets are listed in `pubspec.yaml`, including:

- Login screen logo
- Student profile and welcome images
- School bus image
- Principal signature
- ERS animation video
- Application launcher logo

The launcher icon configuration uses `assets/images/applogo.png` for Android and iOS.

## Testing

Run all Flutter tests with:

```bash
flutter test
```

The existing widget test verifies that:

1. `ERPApp` starts successfully.
2. `SplashScreen` is shown initially.
3. The splash timer and animation complete.
4. The app navigates to `LoginScreen`.

You can add more tests under `test/` and follow the existing widget-test pattern.

## Code Analysis

Run the configured Flutter lints and static analysis with:

```bash
flutter analyze
```

Formatting can be checked or applied with:

```bash
dart format --output=none --set-exit-if-changed lib test
# Apply formatting
dart format lib test
```

## Building a Release

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Windows

```bash
flutter build windows --release
```

### macOS

```bash
flutter build macos --release
```

### Linux

```bash
flutter build linux --release
```

Build output locations are created by Flutter under each platform's standard build directory.

## Useful Flutter Commands

```bash
# Update dependencies
flutter pub get

# Upgrade packages within pubspec constraints
flutter pub upgrade

# Check connected devices
flutter devices

# Clean generated build files
flutter clean
flutter pub get

# Inspect dependency versions
flutter pub outdated

# Generate or refresh launcher icons
flutter pub run flutter_launcher_icons
```

## Repository Maintenance Files

The repository also contains several root-level Dart and Python utilities used for refactoring and maintenance tasks, including scripts for symbol updates, color replacement, scrolling inspection, chat updates, and class updates.

Archive files such as `ersschool_clean.zip` and `ersschool_all logins final.zip` are snapshots included in the repository. They are not required for normal source builds; use the checked-out source and `pubspec.yaml` instead.

## Contributing

1. Fork the repository.
2. Create a feature branch:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make focused changes and add or update widget tests.
4. Run `dart format`, `flutter analyze`, and `flutter test`.
5. Commit the changes and open a pull request.

## License

No license has currently been declared for this repository. Contributors should check with the repository owner before reusing or distributing the code.
