# 🍽️ Restaurant Management System

A comprehensive Flutter mobile application for managing restaurant operations, including branch management, table reservations, menu management, and customer interactions.

## 📱 Features

### 🏪 Restaurant Management
- **Multi-branch Support**: Manage multiple restaurant branches from a single dashboard
- **Restaurant Admin Panel**: Complete control over restaurant operations and settings
- **Branch Management**: Add, edit, and manage restaurant branches with detailed information
- **Real-time Statistics**: View comprehensive restaurant analytics and reports

### 👨‍🍳 Staff Management
- **Chef Management**: Add, update, and manage chef profiles with job titles and descriptions
- **Role-based Access**: Different access levels for Restaurant Admin, Branch Admin, and Customers
- **Staff Profiles**: Detailed staff information with images and contact details

### 🍽️ Menu & Food Management
- **Menu Management**: Create and manage restaurant menus with categories
- **Food Items**: Add, edit, and organize food items with images and descriptions
- **Meal Schedules**: Set up breakfast, lunch, and dinner schedules
- **Food Categories**: Organize menu items by categories (Burgers, Pizza, Pasta, etc.)

### 🪑 Table & Reservation System
- **Table Management**: Manage restaurant tables with capacity and availability
- **Smart Booking**: Real-time table availability checking
- **Reservation System**: Easy table booking with date and time selection
- **Guest Management**: Handle different guest counts and special requests

### 💳 Payment & Transactions
- **Payment Processing**: Integrated payment system with multiple payment methods
- **Payment History**: Track all transactions and payment records
- **Order Management**: Complete order lifecycle management

### 🔔 Notifications & Communication
- **Push Notifications**: Real-time notifications for reservations and updates
- **Customer Communication**: Direct communication channels with customers
- **Alert System**: Quick alerts for important events and updates

### 📍 Location & Maps
- **Google Maps Integration**: Location-based services and directions
- **Branch Locations**: Find and navigate to restaurant branches
- **Address Management**: Comprehensive address and contact information

### 👤 User Management
- **User Authentication**: Secure login and registration system
- **Profile Management**: User profile customization and management
- **Role-based Dashboard**: Different interfaces for different user types
- **Favorites System**: Save favorite restaurants and menu items

## 📸 Screenshots

### Main Screens
- **Home Screen**: Restaurant discovery and browsing
- **Branch Details**: Detailed branch information and services
- **Menu Screen**: Food items and categories display
- **Reservation Screen**: Table booking interface

### Admin Panels
- **Restaurant Admin Dashboard**: Complete restaurant management
- **Branch Admin Panel**: Branch-specific operations
- **Staff Management**: Chef and employee management

### User Features
- **Profile Screen**: User account management
- **Payment Screen**: Transaction processing
- **Notifications**: Alert and notification center

*[Add your app screenshots here - recommended size: 300x600px for mobile screenshots]*

## 🚀 Installation

### Prerequisites
- Flutter SDK (version 3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/restaurant-management.git
   cd restaurant-management
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Update the API base URL in `lib/helpers/api_helper/api_helper.dart`
   - Ensure your backend server is running and accessible

4. **Run the application**
   ```bash
   flutter run
   ```

## 🏃‍♂️ How to Run

### Development Mode
```bash
# Run in debug mode
flutter run

# Run with hot reload
flutter run --hot

# Run on specific device
flutter run -d <device-id>
```

### Production Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📁 Folder Structure

```
lib/
├── helpers/                 # Helper classes and utilities
│   ├── api_helper/         # API communication
│   ├── cubit_helper/       # State management
│   └── kconst/            # Constants and configurations
├── models/                 # Data models
│   ├── branch_model/      # Branch data structure
│   ├── chefs_model/       # Chef data structure
│   ├── menu_model/        # Menu and food items
│   ├── order_model/       # Order management
│   ├── reservation_model/ # Reservation system
│   └── table_model/       # Table management
├── screens/               # UI screens
│   ├── home_screen/       # Main home interface
│   ├── admin_screens/     # Admin panels
│   ├── auth_screens/      # Login/Registration
│   ├── payment_screen/    # Payment processing
│   └── profile_screen/    # User profiles
└── main.dart             # Application entry point
```

## 🛠️ Technologies Used

### Frontend
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **Material Design**: UI/UX design system

### State Management
- **Flutter Bloc**: State management pattern
- **Cubit**: Lightweight state management

### UI/UX Libraries
- **Google Fonts**: Typography
- **Flutter SVG**: Vector graphics
- **Carousel Slider**: Image carousels
- **Salomon Bottom Bar**: Navigation
- **Animate Do**: Animations
- **Shimmer**: Loading effects

### Networking & API
- **Dio**: HTTP client for API calls
- **Cached Network Image**: Image caching

### Maps & Location
- **Google Maps Flutter**: Location services

### Storage & Preferences
- **Shared Preferences**: Local data storage

### Utilities
- **URL Launcher**: External link handling
- **Image Picker**: Image selection
- **Intl**: Internationalization
- **Quick Alert**: Alert dialogs

## 🤝 Contributing

We welcome contributions to improve the Restaurant Management System! Here's how you can contribute:

### Development Setup
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit: `git commit -m 'Add your feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Submit a pull request

### Code Guidelines
- Follow Flutter/Dart coding conventions
- Write meaningful commit messages
- Add comments for complex logic
- Ensure all tests pass
- Update documentation as needed

### Reporting Issues
- Use the GitHub issue tracker
- Provide detailed bug reports
- Include steps to reproduce
- Add screenshots if applicable

## 📞 Contact & Support

### Developer Information
- **Developer**: Kareem Ezzat
- **Email**: kareemezzat@gmail.com
- **Project**: Restaurant Management System

### Support Channels
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/restaurant-management/issues)
- **Email Support**: kareemezzat@gmail.com
- **Documentation**: [Project Wiki](https://github.com/yourusername/restaurant-management/wiki)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Restaurant Management System

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

⭐ **Star this repository if you find it helpful!**

🔄 **Stay updated with the latest features and improvements!**
