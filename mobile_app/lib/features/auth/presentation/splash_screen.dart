import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/security/secure_storage.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final token = await SecureStorage.getAccessToken();
    final role = await SecureStorage.getUserRole();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      context.go('/login');
    } else {
      if (role == 'COMERCIO') {
        context.go('/merchant');
      } else if (role == 'REPARTIDOR') {
        context.go('/delivery');
      } else if (role == 'ADMIN') {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkCharcoal,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.primaryLime,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLime.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt,
                size: 64,
                color: AppTheme.darkCharcoal,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'BarboYa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Movilidad y domicilios inteligentes',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 56),
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLime),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
