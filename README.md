# 🥪 Sandwich Shop – Flutter Application

A modern, multi-screen Flutter app for building custom sandwiches, managing a shopping cart, and completing orders. The app demonstrates best practices in state management, reusable UI components, navigation, persistent storage, and automated testing.

---

## ✨ Features

- **Custom Sandwich Builder:** Choose sandwich type, bread, and size; adjust quantity; see real-time price updates.
- **Shopping Cart:** Add, remove, and update items; persistent cart indicator; view cart summary.
- **Checkout:** Review your order and confirm payment.
- **Profile Management:** Enter and save user details.
- **Settings:** Adjust app font size and preferences.
- **Consistent UI:** Shared app bar and cart indicator across all screens.
- **Robust Navigation:** Seamless transitions between all app sections.
- **Automated Testing:** Comprehensive unit, widget, and integration tests.

---

## 🖥️ Screens

### 🏠 Order Screen

- Build your sandwich by selecting type, bread, size, and quantity.
- Add sandwiches to your cart.
- Navigate to Cart, Profile, or Settings.

### 🛒 Cart Screen

- View all items in your cart.
- Adjust quantities or remove items.
- Proceed to Checkout.

### 💳 Checkout Screen

- Review your order summary.
- Confirm and process payment.

### 👤 Profile Screen

- Enter and save your name and preferred location.

### ⚙️ Settings Screen

- Adjust the app’s font size for accessibility.

---

## 📁 Project Structure

```
lib/
  models/                # Data models (Cart, Sandwich, etc.)
  repositories/          # Business logic (e.g., pricing)
  views/                 # UI screens and shared widgets
    common_widgets.dart  # Shared AppBar, cart icon, styled buttons
    order_screen.dart
    cart_screen.dart
    checkout_screen.dart
    profile_screen.dart
    settings_screen.dart
    app_styles.dart      # Centralized styles and theming
  main.dart              # App entry point

test/
  models/                # Model unit tests
  repositories/          # Repository unit tests
  views/                 # Widget tests for each screen
  widget_test.dart       # General widget tests

integration_test/
  app_test.dart          # End-to-end integration tests
```

---

## 🚀 Installation & Setup

1. **Clone the repository:**

   ```sh
   git clone <your-repo-url>
   cd sandwich_shop
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Run the app on an emulator or device:**

   ```sh
   flutter run
   ```

4. **Run on Chrome (web debug):**
   ```sh
   flutter run -d chrome
   ```

---

## 🧪 Testing

- **Unit Tests:** Validate business logic and models.
- **Widget Tests:** Verify UI components and screen behavior.
- **Integration Tests:** Simulate real user flows across multiple screens.

**Run all tests:**

```sh
flutter test
```

**Run integration tests (requires emulator/device):**

```sh
flutter test integration_test/
```

---

## 📦 Release Build

**Build Android APK:**

```sh
flutter build apk --release
```

_Output:_ `build/app/outputs/flutter-apk/app-release.apk`

**Build Web Release:**

```sh
flutter build web --release
```

_Output:_ `build/web/`

### Debug vs Release Comparison

| Category     | Debug Build                            | Release Build                         |
| ------------ | -------------------------------------- | ------------------------------------- |
| Size         | 174 MB                                 | 80.7 MB                               |
| Performance  | Slower startup, more overhead          | Faster startup, optimized             |
| Debugging    | Hot reload, debug banner, extra checks | No debug banner, production optimized |
| Intended use | Development/testing                    | Distribution to users                 |

---

## 📦 Dependencies

| Package            | Purpose                  |
| ------------------ | ------------------------ |
| provider           | State management         |
| shared_preferences | Local persistent storage |
| flutter_test       | Unit and widget testing  |
| integration_test   | End-to-end UI testing    |

---

## ⚖️ Debug vs Release Comparison

| Category      | Debug Mode                        | Release Mode            |
| ------------- | --------------------------------- | ----------------------- |
| Startup Speed | Slower (hot reload, extra checks) | Faster, optimized       |
| Performance   | Lower (DevTools, assertions)      | High, smooth animations |
| Build Size    | Larger (debug symbols)            | Smaller, minified       |
| Purpose       | Development and testing           | Distribution to users   |

---
