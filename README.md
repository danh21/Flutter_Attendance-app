# 📦 Attendance App

## 📚 Table of Contents

- [📦 Attendance App](#-attendance-app)
  - [📚 Table of Contents](#-table-of-contents)
  - [📝 About](#-about)
  - [📁 Source](#-source)
  - [🚀 Getting Started](#-getting-started)
    - [💻 Technology](#-technology)
    - [🛠️ Build / Verification](#️-build--verification)
    - [Firebase setup](#firebase-setup)
  - [🔗 Reference](#-reference)

## 📝 About

Attendance App is a Flutter application for employee attendance tracking.
It provides employee login, daily check-in/check-out, attendance records,
calendar history, profile information, and location-based attendance support.

- ✅ Employee ID and password login
- ✅ Daily attendance check-in and check-out
- ✅ Attendance calendar and records
- ✅ Employee profile view
- ✅ Firebase Firestore data storage
- ✅ Windows, Android, iOS, Web, and other Flutter targets

## 📁 Source

```
.
├── lib/              # Flutter application source
│   ├── main.dart
│   ├── homescreen.dart
│   ├── loginscreen.dart
│   ├── todayscreen.dart
│   ├── calendarscreen.dart
│   ├── profilescreen.dart
│   ├── model/        # application models
│   └── services/     # device services
├── assets/           # application assets and fonts
├── android/          # Android platform project
├── ios/              # iOS platform project
├── web/              # Web platform project
├── windows/          # Windows platform project
├── test/             # Flutter tests
├── pubspec.yaml      # dependencies and project metadata
└── README.md
```

## 🚀 Getting Started

### 💻 Technology

- Flutter and Dart
- Firebase Core
- Cloud Firestore
- Shared Preferences
- Location and Geocoding
- Font Awesome Flutter
- Flutter Keyboard Visibility
- Slide to Act
- Month Year Picker

### 🛠️ Build / Verification

Install Flutter, then run these commands from the project directory:

```bash
flutter pub get
flutter analyze
flutter test
```

Run the application on a connected device or desktop target:

```bash
flutter run -d windows
```

Build a Windows debug executable:

```bash
flutter build windows --debug
```

### Firebase setup

The application uses the Firebase project configured in
`lib/firebase_options.dart`.

- Android Firebase configuration is stored in `android/app/google-services.json`.
- Firestore must contain an `Employee` collection.
- Each employee document should provide `id` and `password` fields.
- Login searches for an employee where `id` matches the entered Employee ID.

For a new Firebase project, install the FlutterFire CLI and run:

```bash
flutterfire configure
```

Do not commit production passwords to Firestore as plain text. Use Firebase
Authentication before deploying this application to production.

## 🔗 Reference

- [Flutter documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Cloud Firestore documentation](https://firebase.google.com/docs/firestore)