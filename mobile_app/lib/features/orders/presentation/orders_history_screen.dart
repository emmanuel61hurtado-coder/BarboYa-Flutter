import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final ordersProvider = FutureProvider<List<PedidoRead>>((ref) async {
  return await ref.read(pedidoServiceProvider).getPedidos();
});

class OrdersHistoryScreen extends ConsumerWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: RefreshIndicator(
        color: AppTheme.darkCharcoal,
        backgroundColor: AppTheme.primaryLime,
        onRefresh: () async {
          ref.invalidate(ordersProvider);
        },
        child: ordersAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return const Center(
                child: Text('No tienes pedidos registrados.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Pedido #${order.id.substring(0, 8)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text('Total: \$${order.total.toStringAsFixed(0)}'),
                        const SizedBox(height: 4),
                        Text('Método de pago: ${order.metodoPago}'),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: order.estado == 'ENTREGADO'
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.estado,
                        style: TextStyle(
                          color: order.estado == 'ENTREGADO'
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    onTap: () => context.push('/order/${order.id}'),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
