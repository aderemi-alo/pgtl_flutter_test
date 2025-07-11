# PGTL Flutter Test

The three taks required for the PGTL test can be found in this repo

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── constants.dart
│   ├── navigator/
│   │   └── app_router.dart
│   └── core.dart
├── features/
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── loading_overlay.dart
│   │   │   ├── error_dialog.dart
│   │   │   └── widgets.dart
│   │   ├── constants/
│   │   │   └── constants.dart
│   │   └── shared.dart
│   └── auth/
│       ├── data/
│       │   ├── auth_repository_impl.dart
│       │   └── data.dart
│       ├── domain/
│       │   ├── models/
│       │   │   └── auth_models.dart
│       │   ├── repo/
│       │   │   └── auth_repository.dart
│       │   └── domain.dart
│       ├── presentation/
│       │   ├── views/
│       │   │   └── login_screen.dart
│       │   ├── providers/
│       │   │   ├── auth_provider.dart
│       │   │   └── providers.dart
│       │   ├── widgets/
│       │   │   ├── password_field.dart
│       │   │   └── widgets.dart
│       │   └── presentation.dart
│       └── auth.dart
└── main.dart
```

## Task 3 Files

The following files are included for **Task 3** purposes:

- `lib/core/services/secure_auth_service.dart`
- `lib/core/services/auth_usage_example.dart`

These files demonstrate secure authentication service implementation and usage examples.

## Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK (3.7.0 or higher)

### Installation
1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Demo Credentials
- **Email**: `test@example.com`
- **Password**: `Password123!`

### UI Testing
The URL for viewing the UI implementations is https://appetize.io/app/b_chz3hjttgi2g6vt4fjoyjg6sam
