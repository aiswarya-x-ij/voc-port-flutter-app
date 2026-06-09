import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_state.dart';
import '../../widgets/shared_widgets.dart';

class ControlRoomLoginScreen extends StatefulWidget {
  const ControlRoomLoginScreen({super.key});

  @override
  State<ControlRoomLoginScreen> createState() => _ControlRoomLoginScreenState();
}

class _ControlRoomLoginScreenState extends State<ControlRoomLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final appState = context.read<AppState>();
    final success = await appState.controlRoomLogin(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(context, '/control-room-dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Use admin / admin123'),
          backgroundColor: AppTheme.vocError,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: AppTheme.vocNavy,
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
                    Text('Control Room Portal', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('Command Center Access', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
                            'Control Room Login',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.vocNavy),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Access the command center dashboard',
                            style: TextStyle(fontSize: 13, color: AppTheme.vocGrey),
                          ),
                          const SizedBox(height: 20),

                          // Demo credentials hint
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.vocAccent.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: AppTheme.vocAccent, size: 16),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Demo Credentials:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.vocAccent)),
                                    const Text('admin / admin123', style: TextStyle(fontSize: 11, color: AppTheme.vocNavy)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          VocTextField(
                            label: 'Username',
                            hint: 'Enter your username',
                            controller: _usernameController,
                            prefixIcon: Icons.person_outline,
                            validator: (v) => v == null || v.isEmpty ? 'Username is required' : null,
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
                                color: AppTheme.vocGrey, size: 18,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Password is required' : null,
                          ),
                          const SizedBox(height: 24),

                          VocButton(
                            label: 'Login to Control Room',
                            icon: Icons.login,
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
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
