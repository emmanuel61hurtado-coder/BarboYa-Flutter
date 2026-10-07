import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/core/security/secure_storage.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/services/auth_service.dart';

final userProfileProvider = FutureProvider<UserRead>((ref) async {
  final service = AuthService(DioClient());
  return await service.getMe();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color secondaryDark = Color(0xFF1E1E24);
    const Color backgroundLight = Color(0xFFF8F9FA);

    const Color primaryOrange = Color(0xFFFF6B00);

    const Color surfaceLight = Colors.white;

    const Color errorRed = Color(0xFFD32F2F);

    const Color successGreen = Color(0xFF388E3C);

    const Color warningAmber = Color(0xFFF57C00);

    const Color infoBlue = Color(0xFF1976D2);

    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: userAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryOrange,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.nombre,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Teléfono'),
                      subtitle: Text(user.telefono ?? 'No registrado'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Rol'),
                      subtitle: Text(user.rol),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade800,
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              onPressed: () async {
                await SecureStorage.clearSession();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
