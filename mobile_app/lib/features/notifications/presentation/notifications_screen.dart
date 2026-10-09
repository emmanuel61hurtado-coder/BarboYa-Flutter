import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final notificacionesListProvider = FutureProvider.autoDispose<List<NotificacionRead>>((ref) async {
  final notifService = ref.watch(notificacionServiceProvider);
  return await notifService.getNotificaciones();
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificacionesListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(notificacionesListProvider),
          ),
        ],
      ),
      body: notifsAsync.when(
        data: (notifs) {
          if (notifs.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_none_outlined,
              title: 'Bandeja limpia',
              message: 'No tienes nuevas notificaciones en este momento.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final n = notifs[index];
              return Card(
                elevation: n.leida ? 0.5 : 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: n.leida
                        ? Colors.grey.shade200
                        : AppTheme.primaryLime.withValues(alpha: 0.3),
                    child: Icon(
                      Icons.notifications,
                      color: n.leida ? Colors.grey : AppTheme.darkCharcoal,
                    ),
                  ),
                  title: Text(
                    n.titulo,
                    style: TextStyle(
                      fontWeight: n.leida ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(n.mensaje),
                      if (n.createdAt.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          n.createdAt.split('T').first,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorBanner(
          message: 'Error al cargar notificaciones: $err',
          onRetry: () => ref.invalidate(notificacionesListProvider),
        ),
      ),
    );
  }
}
