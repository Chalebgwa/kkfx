# KKFX - King of Kings Forex App

A modern Flutter application for forex education and community interaction.

## Features

- **User Authentication**: Google Sign-In integration via Firebase
- **Inbox/Chat**: Real-time messaging between users
- **Store**: Browse and purchase forex-related products
- **Course**: Video-based educational courses with integrated video player
- **Library**: Access to digital books and PDF resources
- **Payments**: Transaction history and payment management
- **Discussions**: Community forum for forex discussions

## Tech Stack

- **Framework**: Flutter (SDK >=2.17.0)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **State Management**: InheritedWidget pattern
- **Authentication**: Google Sign-In
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage

## Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK >=2.17.0
- Android Studio / Xcode (for mobile development)
- Firebase project with Auth, Firestore, and Storage enabled

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Chalebgwa/kkfx.git
cd kkfx
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Add your Android/iOS apps to the project
   - Download and place configuration files:
     - Android: `google-services.json` → `android/app/`
     - iOS: `GoogleService-Info.plist` → `ios/Runner/`

4. Run the app:
```bash
flutter run
```

## Upgrade Information

This app was recently upgraded from Dart 2.0-dev to modern Flutter with null safety. See [UPGRADE_GUIDE.md](UPGRADE_GUIDE.md) for detailed information about:
- Dependency updates
- API migration changes
- Breaking changes
- Build instructions

## Project Structure

```
lib/
├── screens/          # UI screens
│   ├── login.dart
│   ├── home.dart
│   ├── chat.dart
│   ├── course.dart
│   ├── library.dart
│   ├── store.dart
│   ├── payment.dart
│   └── discussions.dart
├── auth.dart         # Authentication logic
├── auth_provider.dart
├── main.dart         # App entry point
└── ...
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the terms included in the repository.

## Support

For help getting started with Flutter, view the online
[documentation](https://flutter.io/).
