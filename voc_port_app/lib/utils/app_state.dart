import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../repositories/mock_repositories.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  DriverModel? _currentDriver;
  bool _isControlRoomLoggedIn = false;
  TripModel? _currentTrip;
  List<AlertModel> _alerts = [];
  List<MonitoringTruck> _activeTrucks = [];
  bool _isLoading = false;
  String? _errorMessage;

  DriverModel? get currentDriver => _currentDriver;
  bool get isControlRoomLoggedIn => _isControlRoomLoggedIn;
  TripModel? get currentTrip => _currentTrip;
  List<AlertModel> get alerts => _alerts;
  List<MonitoringTruck> get activeTrucks => _activeTrucks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) { _isLoading = v; notifyListeners(); }
  void _setError(String? e) { _errorMessage = e; notifyListeners(); }

  Future<bool> driverLogin(String driverId, String password) async {
    _setLoading(true);
    _setError(null);
    final driver = await MockDriverRepository.login(driverId, password);
    _setLoading(false);
    if (driver != null) {
      _currentDriver = driver;
      await _loadDriverAlerts(driverId);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> isDriverRegistered(String driverId) async {
    return await MockDriverRepository.isRegistered(driverId);
  }

  Future<bool> registerDriver({
    required String name,
    required String driverId,
    required String mobileNumber,
    required String password,
  }) async {
    _setLoading(true);
    final driver = DriverModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      driverId: driverId,
      mobileNumber: mobileNumber,
      password: password,
    );
    final registered = driver;
    _currentDriver = registered;
    await _loadDriverAlerts(driverId);
    _setLoading(false);
    return true;
  }

  Future<void> _loadDriverAlerts(String driverId) async {
    _alerts = await MockAlertRepository.getDriverAlerts(driverId);
    notifyListeners();
  }

  void startTrip({
    required TruckType truckType,
    String? containerNumber,
    required CargoStatus cargoStatus,
    CargoType? cargoType,
    required DestinationType destinationType,
    required String destinationLocation,
  }) {
    if (_currentDriver == null) return;
    _currentTrip = TripModel(
      truckId: 'TRK-${DateTime.now().millisecondsSinceEpoch % 9000 + 1000}',
      driverId: _currentDriver!.driverId,
      driverName: _currentDriver!.name,
      truckType: truckType,
      containerNumber: containerNumber,
      cargoStatus: cargoStatus,
      cargoType: cargoType,
      destinationType: destinationType,
      destinationLocation: destinationLocation,
      journeyStatus: JourneyStatus.inProgress,
      currentLocation: 'Main Road - Section A',
      gpsActive: true,
    );
    _alerts = [
      AlertModel(
        id: 'TRIP001',
        type: AlertType.journeyCompleted,
        message: 'Journey started to $destinationLocation. Follow designated route.',
        truckId: _currentDriver!.driverId,
        timestamp: DateTime.now(),
      ),
      ..._alerts,
    ];
    notifyListeners();
  }

  Future<bool> controlRoomLogin(String username, String password) async {
    _setLoading(true);
    _setError(null);
    final success = await MockControlRoomRepository.login(username, password);
    if (success) {
      _isControlRoomLoggedIn = true;
      await _loadControlRoomData();
    } else {
      _setError('Invalid credentials. Use admin / admin123');
    }
    _setLoading(false);
    return success;
  }

  Future<void> _loadControlRoomData() async {
    _activeTrucks = await MockTripRepository.getActiveTrucks();
    _alerts = await MockAlertRepository.getAlerts();
    notifyListeners();
  }

  void logoutDriver() {
    _currentDriver = null;
    _currentTrip = null;
    _alerts = [];
    notifyListeners();
  }

  void logoutControlRoom() {
    _isControlRoomLoggedIn = false;
    _alerts = [];
    _activeTrucks = [];
    notifyListeners();
  }
  void generateCongestionAlert({
  required String location,
  required int truckCount,
}) {
  final alert = AlertModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    type: AlertType.congestion,
    message:
        'High congestion detected near $location - $truckCount trucks in queue',
    truckId: 'SYSTEM',
    timestamp: DateTime.now(),
  );

  _alerts.insert(0, alert);
  notifyListeners();
}

void testCongestion() {
  generateCongestionAlert(
    location: 'Coal Jetty I',
    truckCount: 8,
  );
}
}
