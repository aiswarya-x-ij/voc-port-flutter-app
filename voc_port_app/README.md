# VOC Port Authority - Truck Movement Monitoring System
## Flutter Frontend

---

## Project Overview

Complete Flutter frontend for the V.O.C. Port Authority Truck Movement Monitoring System.
Built with Flutter Material 3, clean architecture, and mock data layer ready for backend integration.

---

## Folder Structure

```
lib/
├── main.dart                          # App entry, routing
├── theme/
│   └── app_theme.dart                 # Brand colors, typography, theme
├── models/
│   └── models.dart                    # All data models (DriverModel, TripModel, AlertModel, etc.)
├── repositories/
│   └── mock_repositories.dart         # Mock data layer (replace with real API calls later)
├── utils/
│   └── app_state.dart                 # Global state management (Provider)
├── widgets/
│   ├── shared_widgets.dart            # Reusable UI components
│   └── port_map_widget.dart           # VOC Port layout map widget
└── screens/
    ├── splash/
    │   └── splash_screen.dart         # Animated splash with VOC logo
    ├── home/
    │   └── home_screen.dart           # Portal selection landing page
    ├── driver/
    │   ├── driver_login_screen.dart    # Driver authentication
    │   ├── driver_registration_screen.dart  # Driver self-registration
    │   └── driver_dashboard_screen.dart    # Trip management & status
    └── control_room/
        ├── control_room_login_screen.dart  # Control room authentication
        └── control_room_dashboard.dart    # Command center dashboard
```

---

## Setup Instructions

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code

### Run the App

```bash
cd voc_port_app
flutter pub get
flutter run
```

### For Web
```bash
flutter run -d chrome
```

### For Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows   # or macos / linux
```

---

## Demo Credentials

### Control Room
- **Username:** admin
- **Password:** admin123

### Driver Portal
- **Driver ID:** DRV001
- **Password:** pass123

Or register a new driver account.

---

## Key Features

### Splash Screen
- VOC Port Authority brand logo (vector-rendered)
- Animated loading bar
- Auto-navigates to Home after 3 seconds

### Home Screen (Portal Selection)
- Control Room Portal card → Control Room Login
- Driver Portal card → Driver Login
- Responsive: side-by-side on wide screens, stacked on mobile

### Driver Flow
- Login with Driver ID & Password
- Auto-detect unregistered driver → show registration dialog
- Registration form with validation
- Dashboard with:
  - Driver Information card
  - Truck & Cargo Details (Truck Type, Container No., Cargo Status/Type)
  - Cargo Type disabled when Empty; enabled & required when Loaded
  - Destination Type + Location dropdowns
  - Journey auto-starts on submission
  - Journey Status card (GPS status, current location, destination)
  - Alerts & Notifications section

### Control Room Flow
- Secure login (admin/admin123)
- Dashboard tabs:
  1. **Overview** – Stats + Live Map + Active Trucks preview + Alerts
  2. **Live Map** – Full port map based on actual VOC layout
  3. **Truck Monitoring** – Full table with all 12 active trucks + status filter
  4. **Analytics** – Cargo distribution pie, trucks-by-status bar, hourly traffic line, congestion stats

---

## Architecture Notes

### State Management
Provider pattern via `AppState` — all screens read from and write to this single source of truth.

### Mock Layer
All repository classes in `mock_repositories.dart` simulate async API calls.
To connect to a real backend: replace the body of each repository method with actual HTTP calls.

### Map Widget
`PortMapWidget` renders the VOC port layout using Flutter's `CustomPainter`:
- Based on the actual V.O.C.Chidambaranar Port Authority layout map
- All berths, jetties, NCB areas, gates, and roads positioned proportionally
- Mock truck markers showing different status colors
- Ready to be replaced with Google Maps + real GPS coordinates

---

## Backend Integration Checklist

When connecting to real backend:
- [ ] Replace `MockDriverRepository.login()` with POST /api/driver/login
- [ ] Replace `MockDriverRepository.register()` with POST /api/driver/register
- [ ] Replace `MockControlRoomRepository.login()` with POST /api/auth/control-room
- [ ] Replace `MockTripRepository.getActiveTrucks()` with GET /api/trucks/active
- [ ] Replace `MockAlertRepository.getAlerts()` with GET /api/alerts (with WebSocket for real-time)
- [ ] Connect `PortMapWidget` to Google Maps with real GPS coordinates
- [ ] Implement push notifications for alerts

---

## Design System

| Token | Value |
|-------|-------|
| Primary (Navy) | #1A237E |
| Secondary Blue | #283593 |
| Driver Green | #2E7D32 |
| Warning | #F57C00 |
| Error | #D32F2F |
| Surface | #F8F9FE |
| Border | #E3E8F7 |
| Font | Inter (Google Fonts) |
