import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/services/pedido_service.dart';

final pedidoServiceProvider = Provider<PedidoService>((ref) {
  return PedidoService(DioClient());
});

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _checkout() async {
    final cartState = ref.read(cartProvider);
    if (cartState.items.isEmpty || cartState.comercioId == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pedidoService = ref.read(pedidoServiceProvider);
      // For standard customer flow, we use a placeholder or default direction ID if not explicitly selected
      // Backend validates address and items.
      final detalles = cartState.items.map((i) => {
            'producto_id': i.producto.id,
            'cantidad': i.cantidad,
          }).toList();

      await pedidoService.crearPedido(
        comercioId: cartState.comercioId!,
        direccionId: cartState.direccionId ?? '00000000-0000-0000-0000-000000000000',
        metodoPago: cartState.metodoPago,
        detalles: detalles,
      );

      ref.read(cartProvider.notifier).clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Pedido creado exitosamente!')),
      );
      context.go('/orders');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('ApiException: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color secondaryDark = Color(0xFF1E1E24);
    const Color backgroundLight = Color(0xFFF8F9FA);

    const Color primaryOrange = Color(0xFFFF6B00);

    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('Tu Carrito'),
      ),
      body: cartState.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                    onPressed: () => context.go('/home'),
                    child: const Text('Ver comercios'),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade800)),
                  ),
                  const SizedBox(height: 16),
                ],
                ...cartState.items.map((item) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.producto.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.producto.precio.toStringAsFixed(0)} c/u',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(item.producto.id, -1),
                                ),
                                Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(item.producto.id, 1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () =>
                                      ref.read(cartProvider.notifier).removeProducto(item.producto.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Resumen de Pago', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment:                           MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('\$${cartState.total.toStringAsFixed(0)}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment:                           MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Costo de envío'),
                            Text('\$4,000'),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment:                           MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total estimado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text(
                              '\$${(cartState.total + 4000).toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: primaryOrange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _checkout,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Confirmar Pedido'),
                ),
              ],
            ),
    );
  }
}
