import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/cart/presentation/cart_screen.dart';
import 'package:mobile_app/shared/models/models.dart';

final orderDetailProvider = FutureProvider.family<PedidoRead, String>((ref, id) async {
  return await ref.read(pedidoServiceProvider).getPedidoDetail(id);
});

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

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

    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Detalle del Pedido'),
      ),
      body: orderAsync.when(
        data: (order) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:                         MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pedido #${order.id.substring(0, 8)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.estado,
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text('Productos solicitados:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...order.detalles.map((detalle) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment:                         MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${detalle.cantidad}x ${detalle.productoId}'),
                              Text('\$${detalle.subtotal.toStringAsFixed(0)}'),
                            ],
                          ),
                        )),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment:                         MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Pagado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          '\$${order.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryOrange),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
