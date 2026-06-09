import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/shared_widgets.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _driverIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final appState = context.read<AppState>();
    final success = await appState.driverLogin(
      _driverIdController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/driver-dashboard');
    } else {
      // Show "not registered" dialog
      _showNotRegisteredDialog();
    }
  }

  void _showNotRegisteredDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.vocWarning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person_off_rounded, color: AppTheme.vocWarning, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Driver Not Found', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text(
          'Driver not registered or incorrect credentials. Would you like to register?',
          style: TextStyle(fontSize: 13, color: AppTheme.vocGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.vocGrey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/driver-register');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.vocGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Register Here'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom app bar
          Container(
            color: AppTheme.vocGreen,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Image.asset('assets/images/voc_logo_symbol.png', fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Driver Portal',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Login to your account',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.vocBorder),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Driver Login',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.vocNavy,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enter your credentials to access your dashboard',
                            style: TextStyle(fontSize: 13, color: AppTheme.vocGrey),
                          ),
                          const SizedBox(height: 28),

                          VocTextField(
                            label: 'Driver ID',
                            hint: 'Enter your Driver ID',
                            controller: _driverIdController,
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) => v == null || v.isEmpty ? 'Driver ID is required' : null,
                          ),
                          const SizedBox(height: 16),

                          VocTextField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppTheme.vocGrey,
                                size: 18,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Password is required' : null,
                          ),
                          const SizedBox(height: 24),

                          VocButton(
                            label: 'Login',
                            icon: Icons.login,
                            isLoading: _isLoading,
                            backgroundColor: AppTheme.vocGreen,
                            onPressed: _handleLogin,
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Driver not registered? ',
                                style: const TextStyle(fontSize: 13, color: AppTheme.vocGrey),
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => Navigator.pushNamed(context, '/driver-register'),
                                      child: const Text(
                                        'Register Here',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppTheme.vocGreen,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppTheme.vocGreen,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Demo hint
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.vocLightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Demo Credentials:',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.vocNavy),
                                ),
                                SizedBox(height: 4),
                                Text('Driver ID: DRV001  |  Password: pass123', style: TextStyle(fontSize: 11, color: AppTheme.vocGrey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
