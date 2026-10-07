import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/features/home/presentation/customer_home_screen.dart';
import 'package:mobile_app/shared/models/models.dart';

final commerceDetailProvider = FutureProvider.family<ComercioRead, String>((ref, id) async {
  return await ref.read(comercioServiceProvider).getComercioDetail(id);
});

class CommerceDetailScreen extends ConsumerWidget {
  final String commerceId;

  const CommerceDetailScreen({super.key, required this.commerceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color secondaryDark = Color(0xFF1E1E24);
    const Color backgroundLight = Color(0xFFF8F9FA);

    const Color primaryOrange = Color(0xFFFF6B00);

    final commerceAsync = ref.watch(commerceDetailProvider(commerceId));
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: backgroundLight,
      body: commerceAsync.when(
        data: (comercio) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(comercio.nombre, style: const TextStyle(color: Colors.white, fontSize: 16)),
                background: Container(
                  color: secondaryDark,
                  child: const Center(
                    child: Icon(Icons.storefront, size: 80, color: primaryOrange),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comercio.nombre,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: secondaryDark),
                    ),
                    const SizedBox(height: 8),
                    Text(comercio.descripcion ?? comercio.direccion, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
                    const Text(
                      'Menú de Productos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: secondaryDark),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final producto = comercio.productos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.nombre,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  producto.descripcion ?? '',
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${producto.precio.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(80, 40),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: producto.disponible
                                ? () {
                                    ref.read(cartProvider.notifier).addProducto(producto, comercio.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${producto.nombre} agregado al carrito')),
                                    );
                                  }
                                : null,
                            child: const Text('Agregar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: comercio.productos.length,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      bottomNavigationBar: cartState.items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => context.push('/cart'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ver Carrito (${cartState.items.length} items)'),
                    Text('\$${cartState.total.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
