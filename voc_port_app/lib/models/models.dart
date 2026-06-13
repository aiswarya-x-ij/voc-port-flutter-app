// ============================================================
// MODELS - VOC Port Truck Movement Monitoring System
// ============================================================

class DriverModel {
  final String id;
  final String name;
  final String driverId;
  final String mobileNumber;
  final String password;

  DriverModel({
    required this.id,
    required this.name,
    required this.driverId,
    required this.mobileNumber,
    required this.password,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      driverId: map['driverId'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'driverId': driverId,
      'mobileNumber': mobileNumber,
      'password': password,
    };
  }
}

enum CargoStatus { loaded, empty }

enum CargoType { coal, oilCake, sulphuricAcid }

extension CargoTypeExtension on CargoType {
  String get displayName {
    switch (this) {
      case CargoType.coal: return 'Coal';
      case CargoType.oilCake: return 'Oil Cake';
      case CargoType.sulphuricAcid: return 'Sulphuric Acid';
    }
  }
}

enum TruckType { flatbed, tanker, containerTruck, tippingTruck, heavyHaul }

extension TruckTypeExtension on TruckType {
  String get displayName {
    switch (this) {
      case TruckType.flatbed: return 'Flatbed';
      case TruckType.tanker: return 'Tanker';
      case TruckType.containerTruck: return 'Container Truck';
      case TruckType.tippingTruck: return 'Tipping Truck';
      case TruckType.heavyHaul: return 'Heavy Haul';
    }
  }
}

enum DestinationType { berths, jettyAreas, ncbAreas, operationalAreas }

extension DestinationTypeExtension on DestinationType {
  String get displayName {
    switch (this) {
      case DestinationType.berths: return 'Berths';
      case DestinationType.jettyAreas: return 'Jetty Areas';
      case DestinationType.ncbAreas: return 'NCB Areas';
      case DestinationType.operationalAreas: return 'Operational Areas';
    }
  }

  List<String> get locations {
    switch (this) {
      case DestinationType.berths:
        return ['VOC I', 'VOC II', 'VOC III', 'VOC IV', 'Berth V', 'Berth VI', 'Berth VII', 'Berth VIII', 'Berth IX'];
      case DestinationType.jettyAreas:
        return ['Coal Jetty I', 'Coal Jetty II', 'Oil Jetty'];
      case DestinationType.ncbAreas:
        return ['NCB I', 'NCB II', 'NCB III'];
      case DestinationType.operationalAreas:
        return ['Coastal Berth', 'Shallow Berth', 'Eastern Arm', 'Container Terminal', 'Stack Yard', 'Open Storage Yard', 'Transit Shed', 'Warehouse Area'];
    }
  }
}

enum JourneyStatus { idle, inProgress, atDestination, completed }

extension JourneyStatusExtension on JourneyStatus {
  String get displayName {
    switch (this) {
      case JourneyStatus.idle: return 'Idle';
      case JourneyStatus.inProgress: return 'In Progress';
      case JourneyStatus.atDestination: return 'At Destination';
      case JourneyStatus.completed: return 'Completed';
    }
  }
}

class TripModel {
  final String truckId;
  final String driverId;
  final String driverName;
  final TruckType truckType;
  final String? containerNumber;
  final CargoStatus cargoStatus;
  final CargoType? cargoType;
  final DestinationType destinationType;
  final String destinationLocation;
  final JourneyStatus journeyStatus;
  final String currentLocation;
  final bool gpsActive;

  TripModel({
    required this.truckId,
    required this.driverId,
    required this.driverName,
    required this.truckType,
    this.containerNumber,
    required this.cargoStatus,
    this.cargoType,
    required this.destinationType,
    required this.destinationLocation,
    required this.journeyStatus,
    required this.currentLocation,
    required this.gpsActive,
  });
}

class AlertModel {
  final String id;
  final AlertType type;
  final String message;
  final String truckId;
  final DateTime timestamp;
  final bool isRead;

  AlertModel({
    required this.id,
    required this.type,
    required this.message,
    required this.truckId,
    required this.timestamp,
    this.isRead = false,
  });
}

enum AlertType { wrongRoute, destinationReached, journeyCompleted, congestion, notification }

extension AlertTypeExtension on AlertType {
  String get displayName {
    switch (this) {
      case AlertType.wrongRoute: return 'Wrong Route';
      case AlertType.destinationReached: return 'Destination Reached';
      case AlertType.journeyCompleted: return 'Journey Completed';
      case AlertType.congestion: return 'Congestion Alert';
      case AlertType.notification: return 'Notification';
    }
  }
}

class MonitoringTruck {
  final String truckId;
  final String driverName;
  final String cargoType;
  final String destination;
  final String currentLocation;
  final String status;
  final String statusColor; // 'green', 'orange', 'red', 'blue', 'purple'

  MonitoringTruck({
    required this.truckId,
    required this.driverName,
    required this.cargoType,
    required this.destination,
    required this.currentLocation,
    required this.status,
    required this.statusColor,
  });
}
