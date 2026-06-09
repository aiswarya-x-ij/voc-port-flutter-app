import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'utils/app_state.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/driver/driver_login_screen.dart';
import 'screens/driver/driver_registration_screen.dart';
import 'screens/driver/driver_dashboard_screen.dart';
import 'screens/control_room/control_room_login_screen.dart';
import 'screens/control_room/control_room_dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const VocPortApp(),
    ),
  );
}

class VocPortApp extends StatelessWidget {
  const VocPortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOC Port - Truck Movement & Geofencing System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/driver-login': (context) => const DriverLoginScreen(),
        '/driver-register': (context) => const DriverRegistrationScreen(),
        '/driver-dashboard': (context) => const DriverDashboardScreen(),
        '/control-room-login': (context) => const ControlRoomLoginScreen(),
        '/control-room-dashboard': (context) => const ControlRoomDashboard(),
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}
