import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App bar
          Container(
            color: AppTheme.vocNavy,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
              left: 20,
              right: 20,
            ),
            child: const VocPortLogo(size: 40, darkBackground: true),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Select Your Portal',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the appropriate portal to access the system',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 100.ms, duration: 500.ms),
                    const SizedBox(height: 40),

                    // Portal cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 700) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _PortalCard(
                                  icon: Icons.monitor_heart_rounded,
                                  title: 'Control Room Portal',
                                  subtitle: 'For operators and administrators',
                                  description:
                                      'Access real-time truck monitoring, geofencing alerts, analytics, and command center dashboard',
                                  buttonLabel: 'Control Room Login',
                                  primaryColor: AppTheme.vocNavy,
                                  accentColor: AppTheme.vocAccent,
                                  delay: 200,
                                  onTap: () => Navigator.pushNamed(context, '/control-room-login'),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: _PortalCard(
                                  icon: Icons.local_shipping_rounded,
                                  title: 'Driver Portal',
                                  subtitle: 'For truck drivers and operators',
                                  description:
                                      'Log your trips, track cargo, view destination info, and receive navigation alerts',
                                  buttonLabel: 'Driver Login',
                                  primaryColor: AppTheme.vocGreen,
                                  accentColor: AppTheme.vocLightGreen,
                                  delay: 300,
                                  onTap: () => Navigator.pushNamed(context, '/driver-login'),
                                ),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            _PortalCard(
                              icon: Icons.monitor_heart_rounded,
                              title: 'Control Room Portal',
                              subtitle: 'For operators and administrators',
                              description:
                                  'Access real-time truck monitoring, geofencing alerts, analytics, and command center dashboard',
                              buttonLabel: 'Control Room Login',
                              primaryColor: AppTheme.vocNavy,
                              accentColor: AppTheme.vocAccent,
                              delay: 200,
                              onTap: () => Navigator.pushNamed(context, '/control-room-login'),
                            ),
                            const SizedBox(height: 20),
                            _PortalCard(
                              icon: Icons.local_shipping_rounded,
                              title: 'Driver Portal',
                              subtitle: 'For truck drivers and operators',
                              description:
                                  'Log your trips, track cargo, view destination info, and receive navigation alerts',
                              buttonLabel: 'Driver Login',
                              primaryColor: AppTheme.vocGreen,
                              accentColor: AppTheme.vocLightGreen,
                              delay: 300,
                              onTap: () => Navigator.pushNamed(context, '/driver-login'),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                    // Footer
                    Text(
                      '© 2024 V.O.C. Port Authority. All rights reserved.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                    ).animate().fadeIn(delay: 500.ms),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortalCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String buttonLabel;
  final Color primaryColor;
  final Color accentColor;
  final int delay;
  final VoidCallback onTap;

  const _PortalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLabel,
    required this.primaryColor,
    required this.accentColor,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_PortalCard> createState() => _PortalCardState();
}

class _PortalCardState extends State<_PortalCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? widget.primaryColor.withOpacity(0.4) : AppTheme.vocBorder,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, size: 36, color: widget.primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.vocNavy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.vocGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4A5568),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.buttonLabel,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: widget.delay), duration: 500.ms).slideY(begin: 0.2),
    );
  }
}
