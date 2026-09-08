# Architecture Overview

## Overview

Restaurant Management is organized around three main responsibilities:

1. **Presentation** — Flutter screens and reusable UI components.
2. **State & Coordination** — Cubit/BLoC classes coordinate UI state and application actions.
3. **Data Access** — A centralized Dio helper communicates with the restaurant backend while model classes map API responses into Dart objects.

## Application Flow

```text
Flutter UI
   ↓
Cubit / BLoC
   ↓
ApiHelper
   ↓
Dio
   ↓
REST API
   ↓
Dart Models
   ↓
Cubit State
   ↓
Flutter UI
```

## Main Layers

### Screens

Feature-oriented screens cover authentication, restaurant discovery, branch details, menus, reservations, payments, notifications, profiles, chefs, branch administration, and restaurant administration.

### State Management

`flutter_bloc` and `bloc` are used for reactive state management. `ApiCubit` contains shared application operations and emits loading, success, error, and payment-selection states.

### Networking

`ApiHelper` wraps Dio and provides common `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` operations. The persisted bearer token is attached before requests when available.

### Models

Dedicated model classes represent core business entities such as branches, chefs, meal schedules, menus, notifications, orders, reservations, restaurants, and tables.

## Design Direction

The current structure is intentionally practical and easy to navigate. A future refactor can move toward feature-first modules with dedicated repositories, services, Cubits, and data sources as the application grows.
