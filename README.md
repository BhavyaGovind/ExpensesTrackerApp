# 📱 ExpensesTracker - Swift iOS App

**ExpensesTracker** is a personal finance app built using Swift that helps users log and manage their daily expenses. It uses Firebase Authentication for login, Realm for data persistence, and follows a modular MVVM-C architecture. UI is built using UIKit with SnapKit for layout, and Combine powers reactive updates.

---

## ✨ Features

- 🔐 Sign in with Google via Firebase
- 💸 Add, edit, and delete expenses
- 🗂 View all logged expenses in a list
- 🧠 Uses MVVM-C architecture
- 💾 Realm-based local storage
- 📲 SnapKit for responsive auto layout
- 🧪 UI test-friendly setup
- ⚙️ Combine for reactive updates

---

## 🏗️ Architecture

The project is structured using the **MVVM-C** (Model-View-ViewModel-Coordinator) pattern:
- **Model**: Defines data structures like `Expense`, persisted using Realm.
- **ViewModel**: Handles business logic and state using Combine.
- **Coordinator**: Manages navigation between screens.
- **View**: UIKit-based views with SnapKit constraints.

---

## 🔐 Authentication

- Google Sign-In integrated via **Firebase**
- OAuth handled through `GIDSignIn`
- Firebase Authentication persists the session
- Seamless login/logout transition using Coordinators

---

## 💾 Data Persistence

- **Realm** is used to store expenses locally
- `ExpenseManager` manages CRUD operations
- Data persists offline

---

## 🔁 Reactive Programming

- Utilizes **Combine** for:
  - Handling user interaction
  - Observing data changes in ViewModels
  - Triggering UI updates

---

## 🧪 UI Testing Support

- The app detects UI testing mode via `ProcessInfo.processInfo.environment["UITest"]`
- Automatically skips login for smoother test runs
- Buttons and key UI elements use `accessibilityIdentifier` for targeting in UI automation

---

## 📦 Tech Stack

| Component        | Library / Tool            |
|------------------|---------------------------|
| Language         | Swift                     |
| Architecture     | MVVM-C                    |
| UI Layout        | SnapKit                   |
| Reactive Layer   | Combine                   |
| Auth             | Firebase + Google Sign-In |
| Storage          | Realm                     |
| Dependency Mgmt  | Swift Package Manager     |

---

## 🚀 Getting Started

1. Clone the repo  
2. Open `ExpensesTracker.xcodeproj` or `.xcworkspace` in Xcode  
3. Go to **File > Add Packages** and install:
   - `Firebase` (FirebaseAuth, FirebaseCore)
   - `RealmSwift`
   - `SnapKit`
4. Download `GoogleService-Info.plist` from Firebase Console and add it to your app target
5. Run the app on simulator or device

---

## 🔧 Firebase Setup

1. Visit [Firebase Console](https://console.firebase.google.com) and create a new project
2. Enable **Authentication > Google Sign-In**
3. Download `GoogleService-Info.plist` and add to Xcode
4. Add the reversed client ID from the plist to your app’s `Info.plist` under `URL Types`

---

## 📂 Folder Structure
ExpensesTrackerApp/ │ ├── Coordinators/ │ ├── AppCoordinator.swift │ ├── SignInCoordinator.swift │ └── ExpensesCoordinator.swift │ ├── ViewModels/ │ ├── ExpensesViewModel.swift │ └── AddExpenseViewModel.swift │ ├── Views/ │ ├── SignInViewController.swift │ ├── ExpensesViewController.swift │ └── AddExpenseViewController.swift │ ├── Models/ │ ├── Expense.swift │ └── User.swift │ ├── Services/ │ ├── AuthService.swift │ └── ExpenseManager.swift
