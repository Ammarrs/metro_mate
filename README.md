# Metro Mate 

Metro Mate is a smart metro transportation application built using Flutter.  
The app helps users manage metro transportation easily through digital payments, subscriptions, route guidance, and ticket booking.

---

#  Features

-  Authentication  
  Register, Login, Forget Password, Change Password

-  Digital Payments  
  Secure online payments using Paymob integration

-  Buy Tickets  
  Purchase metro tickets directly from the application

-  Auto Renewal  
  Automatic subscription renewal support

-  Notifications  
  Receive subscription and payment notifications

-  Payment History  
  View previous transactions and payments

-  Smart Route Guidance  
  Select the best metro route quickly and easily

-  Localization  
  Multi-language support

-  Profile Page  
  Manage user information and account settings

---

#  Tech Stack

- Flutter
- Dart
- Firebase
- Cubit (Bloc State Management)
- Paymob Payment Gateway

---

#  Project Structure

```bash
lib/
│
├── Authentication/
├── Authentication_Cubit/
├── Bloc/
├── block/
├── Buy_Ticket/
├── ChangePassword/
├── components/
├── config/
├── core/
├── cubits/
├── generated/
├── l10n/
├── models/
├── NavigationBar_Page/
├── services/
├── Shuttle bus/
├── SubscriptionScreen3,4/
├── utils/
├── views/
│
├── firebase_options.dart
├── main.dart
├── OnboardingScreens.dart
├── RouteDetails.dart
└── VerticalStepsLine.dart
```

---

# 📌 Structure Overview

| Folder | Description |
|--------|-------------|
| `Authentication/` | Authentication screens and logic |
| `Authentication_Cubit/` | Authentication state management |
| `cubits/` | Application state management using Cubit |
| `services/` | API and Firebase services |
| `models/` | Data models |
| `components/` | Reusable widgets and UI components |
| `views/` | Main application screens |
| `core/` | Shared utilities and helpers |
| `l10n/` | Localization files |
| `config/` | App configuration files |

---

#  Getting Started

## Prerequisites

Before running the project, make sure you have installed:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Git

---

# 🔧 Installation & Run

##  Clone the repository

```bash
git clone https://github.com/your-username/metro_mate.git
```

---

##  Navigate to the project folder

```bash
cd metro_mate
```

---

##  Install dependencies

```bash
flutter pub get
```

---

##  Run the application

```bash
flutter run
```

---

#  Running on Different Devices

## Check available devices

```bash
flutter devices
```

---

## Run on Android Emulator

```bash
flutter run
```

---

## Run on Chrome

```bash
flutter run -d chrome
```

---

#  Firebase Configuration

This project uses Firebase.

Make sure to add the following files:

## Android

Place `google-services.json` inside:

```bash
android/app/
```

---

## iOS

Place `GoogleService-Info.plist` inside:

```bash
ios/Runner/
```

---

#  Localization

The project supports multiple languages using Flutter Localization (`l10n`).

---

#  Build APK

```bash
flutter build apk
```

---

#  Build App Bundle

```bash
flutter build appbundle
```

---

#  State Management

This project uses:

```bash
Cubit (Bloc)
```

for efficient and scalable state management.

---

#  Development Tools

- VS Code
- Android Studio
- GitHub

---

#  Version Control

The project was managed using GitHub for collaboration and version control.

---

#  Screenshots

Add your application screenshots here.

Example:

```md
![Home Screen](assets/readme/home.png)
```

---

#  License

This project is created for educational and learning purposes.

---

#  Authors

Metro Mate Team 