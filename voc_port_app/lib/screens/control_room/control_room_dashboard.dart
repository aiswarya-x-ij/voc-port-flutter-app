import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../utils/app_state.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/port_map_widget.dart';

class ControlRoomDashboard extends StatefulWidget {
  const ControlRoomDashboard({super.key});

  @override
  State<ControlRoomDashboard> createState() => _ControlRoomDashboardState();
}

class _ControlRoomDashboardState extends State<ControlRoomDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (appState.alerts.isNotEmpty) {
    final latestAlert = appState.alerts.first;

    if (latestAlert.type.toString().contains('congestion')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('🚨 Congestion Alert'),
          content: Text(latestAlert.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
});

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppTheme.vocNavy,
        title: Row(
          children: [
             Image.asset('assets/images/voc_logo_full.png',
             height:70,
             fit: BoxFit.contain),
            
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.vocGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.white, size: 8),
                SizedBox(width: 4),
                Text('System Active', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {
              appState.logoutControlRoom();
              Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
            },
            icon: const Icon(Icons.logout, color: Colors.white60, size: 16),
            label: const Text('Logout', style: TextStyle(color: Colors.white60, fontSize: 12)),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats row ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '12',
                    label: 'Active Trucks',
                    change: '▲ +1',
                    icon: Icons.local_shipping_rounded,
                    iconBgColor: const Color(0xFFE3F2FD),
                    iconColor: AppTheme.vocNavy,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '47',
                    label: 'Completed Trips',
                    change: '▲ +12',
                    icon: Icons.check_circle_rounded,
                    iconBgColor: const Color(0xFFE8F5E9),
                    iconColor: AppTheme.vocGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '3',
                    label: 'Route Violations',
                    change: '▲ +0',
                    changePositive: false,
                    icon: Icons.warning_rounded,
                    iconBgColor: const Color(0xFFFFEBEE),
                    iconColor: AppTheme.vocError,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '28m',
                    label: 'Avg Transit Time',
                    change: '▼ -5m',
                    icon: Icons.access_time_rounded,
                    iconBgColor: const Color(0xFFFFF3E0),
                    iconColor: AppTheme.vocWarning,
                  ),
                ),
              ],
            ),
          ),

          // ── Tab bar ──
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.vocNavy,
              unselectedLabelColor: AppTheme.vocGrey,
              indicatorColor: AppTheme.vocNavy,
              indicatorWeight: 2,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Live Map'),
                Tab(text: 'Truck Monitoring'),
                Tab(text: 'Analytics'),
              ],
            ),
          ),

          // ── Tab content ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(appState: appState),
                _LiveMapTab(),
                _TruckMonitoringTab(trucks: appState.activeTrucks),
                _AnalyticsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OVERVIEW TAB
// ─────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final AppState appState;
  const _OverviewTab({required this.appState});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * 0.60 - 24,
                      child: Column(
                        children: [
                          SectionCard(
                            title: 'Live Port Map',
                            icon: Icons.map_rounded,
                            iconColor: AppTheme.vocNavy,
                            child: const PortMapWidget(),
                          ),
                          const SizedBox(height: 16),
                          _ActiveTrucksCard(trucks: appState.activeTrucks.take(6).toList()),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SectionCard(
                        title: 'Active Alerts',
                        icon: Icons.notifications_active_rounded,
                        iconColor: AppTheme.vocWarning,
                        child: Column(
                          children: [
                            AlertCard(title: 'Congestion Alert', message: 'High congestion detected near Coal Jetty I - 8 trucks in queue', severity: AlertSeverity.warning, time: '2m ago'),
                            AlertCard(title: 'Destination Reached', message: 'TRK-2002 reached destination VOC II', severity: AlertSeverity.success, time: '5m ago'),
                            AlertCard(title: 'Wrong Route Alert', message: 'TRK-2007 deviated from assigned route', severity: AlertSeverity.danger, time: '8m ago'),
                            AlertCard(title: 'Journey Completed', message: 'TRK-2011 completed delivery to Container Terminal', severity: AlertSeverity.info, time: '12m ago'),
                            AlertCard(title: 'Congestion Alert', message: 'Queue forming at Yellow Gate - 5 trucks waiting', severity: AlertSeverity.warning, time: '15m ago'),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    SectionCard(
                      title: 'Live Port Map',
                      icon: Icons.map_rounded,
                      iconColor: AppTheme.vocNavy,
                      child: const PortMapWidget(),
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: 'Active Alerts',
                      icon: Icons.notifications_active_rounded,
                      iconColor: AppTheme.vocWarning,
                      child: Column(
                        children: [
                          AlertCard(title: 'Congestion Alert', message: 'High congestion detected near Coal Jetty I - 8 trucks in queue', severity: AlertSeverity.warning, time: '2m ago'),
                          AlertCard(title: 'Destination Reached', message: 'TRK-2002 reached destination VOC II', severity: AlertSeverity.success, time: '5m ago'),
                          AlertCard(title: 'Wrong Route Alert', message: 'TRK-2007 deviated from assigned route', severity: AlertSeverity.danger, time: '8m ago'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ActiveTrucksCard(trucks: appState.activeTrucks.take(6).toList()),
                  ],
                ),
        );
      },
    );
  }

}

class _ActiveTrucksCard extends StatelessWidget {
  final List<MonitoringTruck> trucks;
  const _ActiveTrucksCard({required this.trucks});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Active Trucks',
      icon: Icons.table_chart_rounded,
      iconColor: AppTheme.vocNavy,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.vocBorder)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: _TableHeader('Truck ID')),
                Expanded(flex: 2, child: _TableHeader('Driver')),
                Expanded(flex: 2, child: _TableHeader('Cargo')),
                Expanded(flex: 2, child: _TableHeader('Destination')),
                Expanded(flex: 2, child: _TableHeader('Status')),
                Expanded(flex: 3, child: _TableHeader('Location')),
              ],
            ),
          ),
          // Rows
          ...trucks.map((t) => _TruckRow(truck: t)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.vocGrey),
    );
  }
}

class _TruckRow extends StatelessWidget {
  final MonitoringTruck truck;
  const _TruckRow({required this.truck});

  Color get _statusColor {
    switch (truck.statusColor) {
      case 'green': return AppTheme.vocGreen;
      case 'orange': return AppTheme.vocWarning;
      case 'red': return AppTheme.vocError;
      case 'blue': return Colors.blue;
      case 'purple': return Colors.purple;
      default: return AppTheme.vocGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F2F8))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(truck.truckId, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.vocNavy)),
          ),
          Expanded(
            flex: 2,
            child: Text(truck.driverName, style: const TextStyle(fontSize: 11, color: AppTheme.vocNavy)),
          ),
          Expanded(
            flex: 2,
            child: _CargoChip(cargo: truck.cargoType),
          ),
          Expanded(
            flex: 2,
            child: Text(truck.destination, style: const TextStyle(fontSize: 11, color: AppTheme.vocNavy)),
          ),
          Expanded(
            flex: 2,
            child: StatusBadge(label: truck.status, color: _statusColor),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                const Icon(Icons.location_on, size: 10, color: AppTheme.vocGrey),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(truck.currentLocation, style: const TextStyle(fontSize: 10, color: AppTheme.vocGrey), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CargoChip extends StatelessWidget {
  final String cargo;
  const _CargoChip({required this.cargo});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (cargo.toLowerCase()) {
      case 'oil cake': color = Colors.orange; break;
      case 'coal': color = Colors.blueGrey; break;
      case 'sulphuric acid': color = Colors.red.shade700; break;
      default: color = AppTheme.vocGrey; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(cargo, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

// ─────────────────────────────────────────────
// LIVE MAP TAB
// ─────────────────────────────────────────────
class _LiveMapTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SectionCard(
        title: 'Real-Time Port Map',
        icon: Icons.satellite_alt_rounded,
        iconColor: AppTheme.vocNavy,
        child: const PortMapWidget(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TRUCK MONITORING TAB
// ─────────────────────────────────────────────
class _TruckMonitoringTab extends StatefulWidget {
  final List<MonitoringTruck> trucks;
  const _TruckMonitoringTab({required this.trucks});

  @override
  State<_TruckMonitoringTab> createState() => _TruckMonitoringTabState();
}

class _TruckMonitoringTabState extends State<_TruckMonitoringTab> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    List<MonitoringTruck> filtered = widget.trucks;
    if (_filter != 'All') {
      filtered = widget.trucks.where((t) => t.status == _filter).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SectionCard(
        title: 'Truck Monitoring Panel',
        icon: Icons.gps_fixed_rounded,
        iconColor: AppTheme.vocNavy,
        actions: [
          Text('${filtered.length} Active', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.vocGreen)),
          const SizedBox(width: 12),
          // Filter dropdown
          SizedBox(
            height: 30,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filter,
                isDense: true,
                style: const TextStyle(fontSize: 12, color: AppTheme.vocNavy),
                items: ['All', 'En Route', 'Loading', 'Alert', 'Returning', 'Waiting', 'Unloading']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _filter = v ?? 'All'),
              ),
            ),
          ),
        ],
        child: Column(
          children: [
            // Full header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.vocBorder)),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 2, child: _TableHeader('Truck ID')),
                  Expanded(flex: 2, child: _TableHeader('Driver Name')),
                  Expanded(flex: 2, child: _TableHeader('Cargo Type')),
                  Expanded(flex: 2, child: _TableHeader('Destination')),
                  Expanded(flex: 2, child: _TableHeader('Status')),
                  Expanded(flex: 3, child: _TableHeader('Current Location')),
                ],
              ),
            ),
            ...filtered.map((t) => _TruckRow(truck: t)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ANALYTICS TAB
// ─────────────────────────────────────────────
class _AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Charts row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cargo distribution pie chart
              Expanded(
                child: SectionCard(
                  title: 'Cargo Distribution',
                  icon: Icons.pie_chart_rounded,
                  iconColor: AppTheme.vocNavy,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: 35, title: 'Coal\n35%', color: Colors.blueGrey, radius: 70, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          PieChartSectionData(value: 28, title: 'Oil Cake\n28%', color: Colors.orange, radius: 70, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          PieChartSectionData(value: 22, title: 'Sulphuric\nAcid 22%', color: Colors.red.shade400, radius: 70, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          PieChartSectionData(value: 15, title: 'Empty\n15%', color: Colors.grey.shade300, radius: 70, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54)),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Trucks by status bar chart
              Expanded(
                child: SectionCard(
                  title: 'Trucks by Status',
                  icon: Icons.bar_chart_rounded,
                  iconColor: AppTheme.vocNavy,
                  child: SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: [
                          _barGroup(0, 5, AppTheme.vocGreen),
                          _barGroup(1, 3, AppTheme.vocWarning),
                          _barGroup(2, 2, AppTheme.vocError),
                          _barGroup(3, 1, Colors.blue),
                          _barGroup(4, 1, Colors.purple),
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24, getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)))),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (v, _) {
                                const labels = ['En Route', 'Loading', 'Alert', 'Return', 'Waiting'];
                                return Text(labels[v.toInt()], style: const TextStyle(fontSize: 8));
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Hourly traffic line chart
          SectionCard(
            title: 'Hourly Traffic Pattern',
            icon: Icons.show_chart_rounded,
            iconColor: AppTheme.vocNavy,
            child: SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(6, 3), FlSpot(7, 5), FlSpot(8, 8), FlSpot(9, 12), FlSpot(10, 10),
                        FlSpot(11, 14), FlSpot(12, 9), FlSpot(13, 11), FlSpot(14, 13), FlSpot(15, 12),
                        FlSpot(16, 10), FlSpot(17, 7), FlSpot(18, 4),
                      ],
                      isCurved: true,
                      color: AppTheme.vocNavy,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.vocNavy.withOpacity(0.1),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24, getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)))),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}:00', style: const TextStyle(fontSize: 9)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (_) => const FlLine(color: AppTheme.vocBorder, strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Congestion & violation stats
          SectionCard(
            title: 'Congestion & Route Violation Summary',
            icon: Icons.analytics_rounded,
            iconColor: AppTheme.vocWarning,
            child: Row(
              children: [
                Expanded(
                  child: _SummaryStatBox(
                    value: '3',
                    label: 'Route Violations Today',
                    color: AppTheme.vocError,
                    bgColor: const Color(0xFFFFEBEE),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryStatBox(
                    value: '2',
                    label: 'Congestion Hotspots',
                    color: AppTheme.vocWarning,
                    bgColor: const Color(0xFFFFF8E1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryStatBox(
                    value: '95%',
                    label: 'Route Adherence Rate',
                    color: AppTheme.vocGreen,
                    bgColor: const Color(0xFFE8F5E9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: color, width: 20, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
      ],
    );
  }
}

class _SummaryStatBox extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bgColor;

  const _SummaryStatBox({
    required this.value,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
