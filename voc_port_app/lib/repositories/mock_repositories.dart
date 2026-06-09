import '../models/models.dart';

// ============================================================
// MOCK REPOSITORIES - Frontend only, no real backend
// ============================================================

class MockDriverRepository {
  // Simulated in-memory driver store
  static final List<DriverModel> _drivers = [
    DriverModel(
      id: '1',
      name: 'Rajesh Kumar',
      driverId: 'DRV001',
      mobileNumber: '9876543210',
      password: 'pass123',
    ),
    DriverModel(
      id: '2',
      name: 'Murugan S',
      driverId: 'DRV002',
      mobileNumber: '9876543211',
      password: 'pass123',
    ),
  ];

  static Future<DriverModel?> login(String driverId, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      return _drivers.firstWhere(
        (d) => d.driverId == driverId && d.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isRegistered(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _drivers.any((d) => d.driverId == driverId);
  }

  static Future<DriverModel> register(DriverModel driver) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _drivers.add(driver);
    return driver;
  }
}

class MockControlRoomRepository {
  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Demo credentials
    return username == 'admin' && password == 'admin123';
  }
}

class MockTripRepository {
  static final List<MonitoringTruck> _trucks = [
    MonitoringTruck(truckId: 'TRK-2001', driverName: 'Driver 1', cargoType: 'Oil Cake', destination: 'Coal Jetty I', currentLocation: 'Green Gate Area', status: 'En Route', statusColor: 'green'),
    MonitoringTruck(truckId: 'TRK-2002', driverName: 'Driver 2', cargoType: 'Coal', destination: 'Coal Jetty I', currentLocation: 'Junction Point 1', status: 'Loading', statusColor: 'orange'),
    MonitoringTruck(truckId: 'TRK-2003', driverName: 'Driver 3', cargoType: 'Coal', destination: 'NCB I', currentLocation: 'Junction Point 1', status: 'Alert', statusColor: 'red'),
    MonitoringTruck(truckId: 'TRK-2004', driverName: 'Driver 4', cargoType: 'Empty', destination: 'VOC I', currentLocation: 'Terminal Zone', status: 'Returning', statusColor: 'blue'),
    MonitoringTruck(truckId: 'TRK-2005', driverName: 'Driver 5', cargoType: 'Coal', destination: 'Coal Jetty I', currentLocation: 'Stack Yard Area', status: 'Waiting', statusColor: 'purple'),
    MonitoringTruck(truckId: 'TRK-2006', driverName: 'Driver 6', cargoType: 'Oil Cake', destination: 'Coal Jetty I', currentLocation: 'Main Road - Section A', status: 'Alert', statusColor: 'red'),
    MonitoringTruck(truckId: 'TRK-2007', driverName: 'Driver 7', cargoType: 'Coal', destination: 'Berth V', currentLocation: 'Main Road - Section A', status: 'En Route', statusColor: 'green'),
    MonitoringTruck(truckId: 'TRK-2008', driverName: 'Driver 8', cargoType: 'Sulphuric Acid', destination: 'Coal Jetty I', currentLocation: 'Stack Yard Area', status: 'Loading', statusColor: 'orange'),
    MonitoringTruck(truckId: 'TRK-2009', driverName: 'Driver 9', cargoType: 'Sulphuric Acid', destination: 'Oil Jetty', currentLocation: 'Green Gate Area', status: 'En Route', statusColor: 'green'),
    MonitoringTruck(truckId: 'TRK-2010', driverName: 'Driver 10', cargoType: 'Sulphuric Acid', destination: 'NCB I', currentLocation: 'Berth Approach', status: 'Loading', statusColor: 'orange'),
    MonitoringTruck(truckId: 'TRK-2011', driverName: 'Driver 11', cargoType: 'Coal', destination: 'Container Terminal', currentLocation: 'Green Gate Area', status: 'Unloading', statusColor: 'blue'),
    MonitoringTruck(truckId: 'TRK-2012', driverName: 'Driver 12', cargoType: 'Oil Cake', destination: 'Oil Jetty', currentLocation: 'Junction Point 1', status: 'Loading', statusColor: 'orange'),
  ];

  static Future<List<MonitoringTruck>> getActiveTrucks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _trucks;
  }
}

class MockAlertRepository {
  static final List<AlertModel> _alerts = [
    AlertModel(
      id: 'A001',
      type: AlertType.congestion,
      message: 'High congestion detected near Coal Jetty I - 8 trucks in queue',
      truckId: 'TRK-2005',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    AlertModel(
      id: 'A002',
      type: AlertType.destinationReached,
      message: 'TRK-2002 reached destination VOC II',
      truckId: 'TRK-2002',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    AlertModel(
      id: 'A003',
      type: AlertType.wrongRoute,
      message: 'TRK-2007 deviated from assigned route',
      truckId: 'TRK-2007',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    AlertModel(
      id: 'A004',
      type: AlertType.journeyCompleted,
      message: 'Journey started to NCB III',
      truckId: 'TRK-2001',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  static Future<List<AlertModel>> getAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _alerts;
  }

  static Future<List<AlertModel>> getDriverAlerts(String driverId) async {
    return [
      AlertModel(
        id: 'DA001',
        type: AlertType.journeyCompleted,
        message: 'Journey started to NCB III. Follow designated route.',
        truckId: driverId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }
}
