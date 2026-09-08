# Restaurant Management System 🍽️

A full-featured **Flutter restaurant platform** covering the complete journey from discovering restaurants and branches to reservations, menus, tables, orders, payments, notifications, and administration.

## ✨ Key Features

### 👤 Customer Experience
- 🔐 Login, registration, and password recovery
- 🏠 Restaurant and branch discovery
- 🍕 Menu and food browsing
- ❤️ Favorites
- 📅 Table reservations with date, time, branch, and guest selection
- 💳 Payment and transaction history
- 🔔 Notifications
- 👤 Profile management

### 🏪 Restaurant Operations
- 🏬 Multi-branch management
- 📊 Restaurant administration
- 🧑‍💼 Branch administration
- 📅 Branch schedules
- 🪑 Table and seating management
- 🍽️ Menu and meal-schedule management
- 👨‍🍳 Chef management
- 🔑 Role-based workflows

### 🗺️ Location & Discovery
- Google Maps integration
- Branch locations and addresses
- External map navigation

## 🔄 Application Flow

```text
Authentication
      ↓
Restaurant Discovery
      ↓
Branch & Menu
      ↓
Tables & Schedule
      ↓
Reservation
      ↓
Payment
      ↓
Notifications & Profile

Administration
      ↓
Branches → Tables → Menus → Chefs → Reservations
```

## 🛠️ Tech Stack

- **Flutter & Dart**
- **BLoC / Cubit** — State management
- **Dio** — REST API networking
- **SharedPreferences** — Local session persistence
- **Google Maps Flutter** — Location services
- **Cached Network Image** — Remote image caching
- **Google Fonts** — Typography
- **Carousel Slider** — Content carousels
- **Shimmer** — Loading states
- **QuickAlert** — User feedback
- **Intl** — Formatting and date utilities

## 🧩 Architecture

```text
UI / Screens
     ↓
Cubit / BLoC
     ↓
ApiHelper
     ↓
Dio HTTP Client
     ↓
Restaurant Backend API
     ↓
Models → UI State
```

The application separates screens, state management, API communication, and domain models into dedicated areas of the Flutter project.

## 📸 Screenshots

Screenshots will be added here as the application showcase is updated.

### Customer Experience

| Login | Home | Branch Details |
|---|---|---|
| `![Login](SCREENSHOT_URL)` | `![Home](SCREENSHOT_URL)` | `![Branch Details](SCREENSHOT_URL)` |

### Booking & Payments

| Menu | Reservation | Payment |
|---|---|---|
| `![Menu](SCREENSHOT_URL)` | `![Reservation](SCREENSHOT_URL)` | `![Payment](SCREENSHOT_URL)` |

### Administration

| Restaurant Admin | Branch Admin | Chefs |
|---|---|---|
| `![Restaurant Admin](SCREENSHOT_URL)` | `![Branch Admin](SCREENSHOT_URL)` | `![Chefs](SCREENSHOT_URL)` |

## 🌐 API Integration

The application integrates with a remote restaurant backend for accounts, branches, schedules, chefs, menus, reservations, tables, orders, notifications, and payments.

Authenticated requests use a persisted JWT token and are handled through a reusable Dio-based API helper.

## 🚀 Getting Started

```bash
git clone https://github.com/KareemEzzat91/resturantmangment.git
cd resturantmangment
flutter pub get
flutter run
```

Run static analysis with:

```bash
flutter analyze
```

## 📌 Project Highlights

- Complete restaurant and customer workflow
- Role-aware application experience
- REST API integration
- Cubit/BLoC state management
- JWT authentication
- Restaurant, branch, chef, menu, table, reservation, order, and payment flows
- Google Maps integration
- Persistent local session data
- Reusable Flutter components and models

## 👨‍💻 Author

**Kareem Ezzat** — Flutter Developer

## 📄 License

This project is presented as a portfolio/application project.
