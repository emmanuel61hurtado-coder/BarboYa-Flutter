import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/cart/presentation/cart_screen.dart';
import 'package:mobile_app/shared/models/models.dart';

final ordersProvider = FutureProvider<List<PedidoRead>>((ref) async {
  return await ref.read(pedidoServiceProvider).getPedidos();
});

class OrdersHistoryScreen extends ConsumerWidget {
  const OrdersHistoryScreen({super.key});

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

    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(ordersProvider),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                        borderRadius: BorderRadius.circular(8),
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
