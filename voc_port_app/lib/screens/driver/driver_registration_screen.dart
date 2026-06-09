import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/shared_widgets.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _driverIdController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _driverIdController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final appState = context.read<AppState>();
    await appState.registerDriver(
      name: _nameController.text.trim(),
      driverId: _driverIdController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/driver-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Driver Registration', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Create your account', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
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
                            'Register as Driver',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.vocNavy),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Fill in your details to create an account',
                            style: TextStyle(fontSize: 13, color: AppTheme.vocGrey),
                          ),
                          const SizedBox(height: 28),

                          VocTextField(
                            label: 'Driver Name',
                            hint: 'Enter your full name',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Name is required';
                              if (v.length < 3) return 'Name must be at least 3 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          VocTextField(
                            label: 'Driver ID',
                            hint: 'Enter unique Driver ID',
                            controller: _driverIdController,
                            prefixIcon: Icons.badge_outlined,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Driver ID is required';
                              if (v.length < 4) return 'Driver ID must be at least 4 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          VocTextField(
                            label: 'Mobile Number',
                            hint: '10 digit mobile number',
                            controller: _mobileController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Mobile number is required';
                              if (v.length != 10) return 'Enter a valid 10-digit mobile number';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          VocTextField(
                            label: 'Password',
                            hint: 'Create a password',
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppTheme.vocGrey, size: 18,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Password is required';
                              if (v.length < 6) return 'Password must be at least 6 characters';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          VocTextField(
                            label: 'Confirm Password',
                            hint: 'Confirm your password',
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppTheme.vocGrey, size: 18,
                              ),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please confirm your password';
                              if (v != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          VocButton(
                            label: 'Register',
                            icon: Icons.person_add_outlined,
                            isLoading: _isLoading,
                            backgroundColor: AppTheme.vocGreen,
                            onPressed: _handleRegister,
                          ),

                          const SizedBox(height: 20),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(fontSize: 13, color: AppTheme.vocGrey),
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Text(
                                        'Login Here',
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
