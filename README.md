# 🍽️ Restaurant Management System

A full-featured **Flutter restaurant management platform** built to cover the complete journey from customer discovery and reservations to restaurant administration, staff management, menus, tables, orders, payments, and notifications.

Designed as a practical mobile application with a role-based experience, API integration, local session persistence, responsive interfaces, and reusable Flutter components.

![Flutter](https://img.shields.io/badge/Flutter-3.5.3%2B-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5.3%2B-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/State%20Management-BLoC%2FCubit-7A5195)
![Dio](https://img.shields.io/badge/Networking-Dio-00A98F)
![Google Maps](https://img.shields.io/badge/Maps-Google%20Maps-4285F4?logo=googlemaps&logoColor=white)

---

## ✨ What the App Offers

### 👤 Customer Experience
- 🔐 **Authentication** — Login, registration, and forgot-password flows.
- 🏠 **Restaurant Discovery** — Browse restaurants and branches from the home screen.
- 📍 **Branch Details** — View restaurant information, addresses, ratings, and available services.
- 🍕 **Menus** — Explore food items and organized menu content.
- ❤️ **Favorites** — Save preferred restaurants or food items for quick access.
- 📅 **Reservations** — Select a date, time, branch, table, and guest count.
- 💳 **Payments** — Complete payment flows and review transaction history.
- 🔔 **Notifications** — Receive booking, payment, and restaurant updates.
- 👤 **Profile** — Manage personal information and account details.
- ℹ️ **About** — Access restaurant/application information.

### 🏪 Restaurant & Branch Management
- 🏬 **Multi-Branch Management** — Create, update, and manage restaurant branches.
- 📊 **Restaurant Administration** — Centralized operational controls and statistics.
- 🧑‍💼 **Branch Administration** — Dedicated branch-level management functionality.
- 📋 **Branch Schedules** — Configure and retrieve branch operating schedules.
- 🪑 **Table Management** — Manage tables, seating capacity, and reservation availability.
- 🍽️ **Menu Management** — Organize food items, categories, and meal schedules.

### 👨‍🍳 Staff Management
- 👨‍🍳 **Chef Management** — Create and manage chef profiles.
- 🔑 **Role-Based Experience** — Support different user experiences based on account roles.
- 🧑 **Staff Profiles** — Store staff information and profile images.
- 🔄 **Branch Admin Assignment** — Assign administrative responsibilities to specific branches.

### 💰 Orders & Payments
- 🛒 **Order Lifecycle** — Support the flow from ordering through payment.
- 💳 **Payment Processing** — Integrated API-driven payment operations.
- 🧾 **Payment History** — View previously completed transactions.
- ✅ **Transaction Feedback** — Provide success and error states during important operations.

### 🔔 Communication & Engagement
- 🔔 **Notifications Center** — View application and reservation-related updates.
- 🚨 **Quick Alerts** — Surface important success and error feedback.
- 📨 **API-Driven Updates** — Keep customer and administrative data synchronized with the backend.

### 🗺️ Location & Discovery
- 🗺️ **Google Maps Integration** — Support restaurant and branch location experiences.
- 📌 **Branch Locations** — Present restaurant addresses and location details.
- 🧭 **Navigation Support** — Launch external map/location experiences when required.

---

## 📸 App Screenshots

> **Screenshots will be added here.**
>
> Replace the placeholders below with the GitHub image URLs after uploading your screenshots.

### Customer Flow

| Login | Home | Branch Details |
|---|---|---|
| `![Login](SCREENSHOT_URL)` | `![Home](SCREENSHOT_URL)` | `![Branch Details](SCREENSHOT_URL)` |

### Menu & Booking

| Menu | Tables | Reservation |
|---|---|---|
| `![Menu](SCREENSHOT_URL)` | `![Tables](SCREENSHOT_URL)` | `![Reservation](SCREENSHOT_URL)` |

### Payments & Account

| Payment | Payment History | Profile |
|---|---|---|
| `![Payment](SCREENSHOT_URL)` | `![Payment History](SCREENSHOT_URL)` | `![Profile](SCREENSHOT_URL)` |

### Administration

| Restaurant Admin | Branch Admin | Chefs |
|---|---|---|
| `![Restaurant Admin](SCREENSHOT_URL)` | `![Branch Admin](SCREENSHOT_URL)` | `![Chefs](SCREENSHOT_URL)` |

---

## 🧩 Core Application Flows

```text
Authentication
     │
     ├── Login
     ├── Register
     └── Forgot Password

Customer
     │
     ├── Home
     ├── Branch Details
     ├── Menu
     ├── Tables & Schedule
     ├── Reservation
     ├── Payment
     ├── Notifications
     └── Profile

Administration
     │
     ├── Restaurant Administration
     ├── Branch Administration
     ├── Branch Management
     ├── Chef Management
     ├── Menu Management
     └── Table Management
```

---

## 🏗️ Project Architecture

The project follows a straightforward Flutter structure that separates API communication, state management, data models, and screens.

```text
lib/
├── helpers/
│   ├── api_helper/
│   │   └── api_helper.dart
│   ├── cubit_helper/
│   │   ├── api_cubit.dart
│   │   └── api_state.dart
│   └── kconst/
│
├── models/
│   ├── branch_model/
│   ├── chefs_model/
│   ├── meal_schedules/
│   ├── menu_model/
│   ├── notification_model/
│   ├── order_model/
│   ├── Reservation_model/
│   ├── resturant_model/
│   └── table_model/
│
├── screens/
│   ├── Registration/
│   ├── about_screen/
│   ├── brancadmin_screen/
│   ├── chefs_screen/
│   ├── home_screen/
│   ├── likes_screen/
│   ├── main_screen/
│   ├── notifications_screen/
│   ├── payment_screen/
│   ├── profile_screen/
│   ├── reservation_screen/
│   └── restaurantadmin_screen/
│
└── main.dart
```

### 🔄 Data & State Flow

```text
UI / Screens
      ↓
Bloc / Cubit
      ↓
API Helper
      ↓
Dio HTTP Client
      ↓
Restaurant Backend API
      ↓
Models → UI State
```

The application uses **Cubit/BLoC** for state management and **Dio** as the HTTP client. Authentication tokens and selected account information are persisted with `SharedPreferences` and attached to subsequent API requests.

---

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| **Flutter** | Cross-platform application development |
| **Dart** | Application language |
| **flutter_bloc / bloc** | State management |
| **Dio** | REST API networking |
| **SharedPreferences** | Local session and user data persistence |
| **Google Maps Flutter** | Maps and branch locations |
| **Google Fonts** | Typography and UI styling |
| **Carousel Slider** | Promotional/content carousels |
| **Salomon Bottom Bar** | Bottom navigation |
| **Shimmer** | Loading states |
| **Cached Network Image** | Efficient remote image loading |
| **Image Picker** | Selecting images for profile/admin workflows |
| **QuickAlert** | User feedback and dialogs |
| **Animate Do** | UI animations |
| **Intl** | Date and formatting utilities |

The package manifest currently targets **Dart SDK `^3.5.3`** and includes the dependencies above. fileciteturn17file0

---

## 🔐 Authentication & Session Handling

The authentication layer supports:

- Email/password login
- New account registration
- Forgot-password requests
- JWT token persistence
- Role persistence
- Basic profile persistence
- Automatic `Authorization: Bearer <token>` headers for API requests

The API helper centralizes authenticated `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` operations through Dio. fileciteturn24file0 fileciteturn25file0

---

## 🌐 API Integration

The application communicates with a remote restaurant backend and exposes operations around accounts, branches, schedules, chefs, menus, reservations, tables, orders, notifications, and payments.

Example API operations include:

```text
POST   /api/Account/login
POST   /api/Account/register
POST   /api/Account/forgot-password
GET    /api/Account/profile

GET    /api/Branch/all
POST   /api/Branch/create
PUT    /api/Branch/update/{id}
DELETE /api/Branch/delete/{id}

GET    /api/BranchSchedule/all/{branchId}
GET    /api/BranchSchedule/schedule-day/{branchId}/{date}
```

The repository implements these backend calls through a reusable `ApiHelper` and `ApiCubit` layer. fileciteturn24file0

---

## 📱 Navigation Structure

The main application shell includes:

- 🏠 Home
- ℹ️ About
- 👤 Profile
- 📂 Drawer-based administrative and supporting screens
- ✨ Animated screen transitions
- 📌 Role-aware profile imagery and account information

The main shell also persists account information such as first name, last name, email, and role using `SharedPreferences`. fileciteturn31file0

---

## ⚙️ Getting Started

### Prerequisites

Make sure you have:

- Flutter SDK `>= 3.5.3`
- Dart SDK compatible with the Flutter version
- Android Studio or VS Code
- Android SDK
- Xcode for iOS development on macOS

### Installation

```bash
git clone https://github.com/KareemEzzat91/resturantmangment.git
cd resturantmangment
flutter pub get
flutter run
```

### Static Analysis

```bash
flutter analyze
```

The project enables the recommended Flutter lint rules through `flutter_lints`. fileciteturn30file0

---

## 🧪 Development Notes

The codebase contains dedicated model classes for reservations, branches, chefs, meal schedules, menus, notifications, orders, restaurants, and tables. fileciteturn22file0

The screen layer is organized by business area, including authentication, home/discovery, reservations, payments, notifications, profile, chefs, branch administration, and restaurant administration. fileciteturn19file0

---

## 📌 Project Highlights

- ✅ Complete restaurant/customer workflow
- ✅ Role-oriented application experience
- ✅ REST API integration with Dio
- ✅ Cubit/BLoC state management
- ✅ JWT-based authenticated requests
- ✅ Restaurant, branch, chef, menu, table, reservation, order, and payment flows
- ✅ Google Maps integration
- ✅ Persistent local session data
- ✅ Loading, success, and error feedback states
- ✅ Reusable helper and model layers

---

## 🚀 Future Improvements

Potential improvements for a production-ready version include:

- [ ] Modularize large Cubits into feature-specific Cubits
- [ ] Introduce repository and service layers
- [ ] Add automated unit and widget tests
- [ ] Add centralized API error mapping
- [ ] Add environment-based API configuration
- [ ] Add secure token storage instead of plain preferences
- [ ] Expand responsive layouts for tablets and desktop
- [ ] Add CI/CD with automated analysis and testing
- [ ] Improve localization and accessibility

---

## 👨‍💻 Author

**Kareem Ezzat**

Flutter Developer focused on building practical, scalable, and polished mobile applications.

---

## 📄 License

This project is currently presented as a portfolio/application project. Add your preferred open-source license here when publishing the project for external use.

---

⭐ **If you like the project, consider giving the repository a star!**
