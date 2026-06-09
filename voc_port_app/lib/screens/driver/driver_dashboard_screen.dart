import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../utils/app_state.dart';
import '../../widgets/shared_widgets.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  TruckType _selectedTruckType = TruckType.flatbed;
  final _containerController = TextEditingController();
  CargoStatus _cargoStatus = CargoStatus.empty;
  CargoType? _cargoType;
  DestinationType _destinationType = DestinationType.berths;
  String? _destinationLocation;
  bool _journeyStarted = false;

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  void _handleStartJourney() {
    if (_destinationLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination location'), backgroundColor: AppTheme.vocError),
      );
      return;
    }
    if (_cargoStatus == CargoStatus.loaded && _cargoType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select cargo type for loaded cargo'), backgroundColor: AppTheme.vocError),
      );
      return;
    }

    context.read<AppState>().startTrip(
      truckType: _selectedTruckType,
      containerNumber: _containerController.text.isEmpty ? null : _containerController.text,
      cargoStatus: _cargoStatus,
      cargoType: _cargoType,
      destinationType: _destinationType,
      destinationLocation: _destinationLocation!,
    );

    setState(() => _journeyStarted = true);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final driver = appState.currentDriver;
    final trip = appState.currentTrip;

    if (driver == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.vocGreen,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset('assets/images/voc_logo_symbol.png', fit: BoxFit.contain),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Driver Dashboard', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            Text(driver.name, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70, size: 20),
            onPressed: () {
              context.read<AppState>().logoutDriver();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                const SizedBox(height: 4),

                // ─── Driver Info Card ───
                SectionCard(
                  title: 'Driver Information',
                  icon: Icons.person_rounded,
                  iconColor: AppTheme.vocGreen,
                  child: Row(
                    children: [
                      Expanded(child: _InfoChip(label: 'Driver Name', value: driver.name)),
                      const SizedBox(width: 16),
                      Expanded(child: _InfoChip(label: 'Driver ID', value: driver.driverId)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Truck & Cargo Details ───
                SectionCard(
                  title: 'Truck & Cargo Details',
                  icon: Icons.local_shipping_rounded,
                  iconColor: AppTheme.vocGreen,
                  child: Column(
                    children: [
                      VocDropdown<TruckType>(
                        label: 'Truck Type',
                        value: _selectedTruckType,
                        hint: 'Select truck type',
                        enabled: !_journeyStarted,
                        items: TruckType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))).toList(),
                        onChanged: (v) => setState(() => _selectedTruckType = v ?? TruckType.flatbed),
                      ),
                      const SizedBox(height: 12),
                      VocTextField(
                        label: 'Container Number (Optional)',
                        hint: 'Enter container number',
                        controller: _containerController,
                        enabled: !_journeyStarted,
                        prefixIcon: Icons.inventory_2_outlined,
                      ),
                      const SizedBox(height: 12),
                      VocDropdown<CargoStatus>(
                        label: 'Cargo Status',
                        value: _cargoStatus,
                        enabled: !_journeyStarted,
                        items: const [
                          DropdownMenuItem(value: CargoStatus.empty, child: Text('Empty')),
                          DropdownMenuItem(value: CargoStatus.loaded, child: Text('Loaded')),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _cargoStatus = v ?? CargoStatus.empty;
                            if (_cargoStatus == CargoStatus.empty) _cargoType = null;
                          });
                        },
                      ),
                      if (_cargoStatus == CargoStatus.loaded) ...[
                        const SizedBox(height: 12),
                        VocDropdown<CargoType>(
                          label: 'Cargo Type *',
                          value: _cargoType,
                          hint: 'Select cargo type',
                          enabled: !_journeyStarted,
                          items: CargoType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))).toList(),
                          onChanged: (v) => setState(() => _cargoType = v),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Destination ───
                SectionCard(
                  title: 'Destination',
                  icon: Icons.location_on_rounded,
                  iconColor: AppTheme.vocGreen,
                  child: Column(
                    children: [
                      VocDropdown<DestinationType>(
                        label: 'Destination Type',
                        value: _destinationType,
                        enabled: !_journeyStarted,
                        items: DestinationType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.displayName))).toList(),
                        onChanged: (v) {
                          setState(() {
                            _destinationType = v ?? DestinationType.berths;
                            _destinationLocation = null;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      VocDropdown<String>(
                        label: 'Destination Location',
                        value: _destinationLocation,
                        hint: 'Select destination',
                        enabled: !_journeyStarted,
                        items: _destinationType.locations.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                        onChanged: (v) => setState(() => _destinationLocation = v),
                      ),
                      if (!_journeyStarted) ...[
                        const SizedBox(height: 16),
                        VocButton(
                          label: 'Start Journey',
                          icon: Icons.navigation_rounded,
                          backgroundColor: AppTheme.vocGreen,
                          onPressed: _handleStartJourney,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Journey Status (shown after journey starts) ───
                if (_journeyStarted && trip != null) ...[
                  SectionCard(
                    title: 'Journey Status',
                    icon: Icons.route_rounded,
                    iconColor: AppTheme.vocGreen,
                    actions: [
                      StatusBadge(label: 'In Progress', color: AppTheme.vocGreen),
                    ],
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.vocLightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('GPS Status', style: TextStyle(fontSize: 11, color: AppTheme.vocGrey)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.vocGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('Connected', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.vocGreen)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.vocLightGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Journey Active', style: TextStyle(fontSize: 11, color: AppTheme.vocGrey)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppTheme.vocGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text('Active', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.vocGreen)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InfoRow(label: 'Current Location', value: trip.currentLocation),
                        InfoRow(label: 'Destination', value: trip.destinationLocation),
                        InfoRow(label: 'Truck ID', value: trip.truckId),
                        InfoRow(label: 'Cargo', value: trip.cargoType?.displayName ?? 'Empty'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ─── Alerts ───
                  SectionCard(
                    title: 'Alerts & Notifications',
                    icon: Icons.notifications_rounded,
                    iconColor: AppTheme.vocWarning,
                    child: Column(
                      children: appState.alerts.map((alert) {
                        AlertSeverity sev;
                        switch (alert.type) {
                          case AlertType.wrongRoute: sev = AlertSeverity.danger; break;
                          case AlertType.congestion: sev = AlertSeverity.warning; break;
                          case AlertType.destinationReached: sev = AlertSeverity.success; break;
                          default: sev = AlertSeverity.info;
                        }
                        return AlertCard(
                          title: alert.type.displayName,
                          message: alert.message,
                          severity: sev,
                          time: _formatTime(alert.timestamp),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.vocGrey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.vocNavy)),
      ],
    );
  }
}
