# SLU Attendance App 📱✨

A modern, streamlined, and user-friendly Attendance Management System built with **Flutter** and **Material 3**. Designed specifically for educational institutes to manage roles, track student and teacher attendance, and optimize daily educational operations.

---

## 🚀 Key Features

* **Role-Based Access Control:** Distinct workflows and interfaces for Students, Teachers, and Administrators starting directly from a dedicated Role Selection screen.
* **Modern Material 3 UI:** Clean, intuitive layout featuring vibrant component design, custom spacing, and fluid transitions.
* **Adaptive Screen Layouts:** Fully optimized for different mobile screen aspect ratios.
* **Highly Modular Structure:** Separated screens, widgets, and business logic ensuring long-term code maintainability.

---

## 📂 Architecture & Project Structure

The project follows a clean feature-by-screen architecture layout to abstract core logic away from user interfaces:

```text
lib/
├── main.dart                      # App entry point & theme initialization
├── screens/
│   ├── role_selection_screen.dart # Initial router screen for defining roles
│   ├── teacher_dashboard.dart     # Attendance tracking & class analytics 
│   └── student_dashboard.dart     # Personal attendance registry & status views
└── widgets/
    └── custom_button.dart         # Reusable global styling widgets
```

---

## 🛠️ Tech Stack & Requirements

* **Framework:** Flutter (Channel stable)
* **Language:** Dart
* **UI Design:** Material 3 Guidelines
* **Minimum SDK Support:**
  * Android: SDK 21 (Android 5.0) or higher
  * iOS: iOS 12.0 or higher

---

## ⚙️ Getting Started

Follow these steps to clone, configure, and execute the Flutter application locally:

### 1. Prerequisites
Ensure you have the Flutter SDK installed and configured on your machine. You can verify your environment status by running:
```bash
flutter doctor
```

### 2. Clone the Repository
```bash
git clone https://github.com/your-username/slu-attendance-app.git
cd slu-attendance-app
```

### 3. Install Project Dependencies
Fetch all the package properties listed in your `pubspec.yaml`:
```bash
flutter pub get
```

### 4. Run the Application
Connect a target physical device or boot an emulator, then execute:
```bash
flutter run
```

---

## 🖥️ Code Snippet: Entry Point (`main.dart`)

The core initialization pipeline sets up Material 3 theming and routes the entry widget directly to the `RoleSelectionScreen`:

```dart
import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const SLUAttendanceApp());
}

class SLUAttendanceApp extends StatelessWidget {
  const SLUAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SLU Attendance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}
```

---

## 🤝 Contribution Guidelines

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`).
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the Branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
