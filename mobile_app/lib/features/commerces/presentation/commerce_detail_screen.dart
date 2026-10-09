import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final commerceDetailProvider = FutureProvider.family<ComercioRead, String>((ref, id) async {
  return await ref.read(comercioServiceProvider).getComercioDetail(id);
});

class CommerceDetailScreen extends ConsumerWidget {
  final String commerceId;

  const CommerceDetailScreen({super.key, required this.commerceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commerceAsync = ref.watch(commerceDetailProvider(commerceId));
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: commerceAsync.when(
        data: (comercio) => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppTheme.darkCharcoal,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(comercio.nombre, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                background: Container(
                  color: AppTheme.darkCharcoal,
                  child: Center(
                    child: Icon(Icons.storefront, size: 80, color: AppTheme.primaryLime.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comercio.nombre,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.darkCharcoal),
                    ),
                    const SizedBox(height: 6),
                    Text(comercio.descripcion ?? comercio.direccion, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 24),
                    const Text(
                      'Menú de Productos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
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
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
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
                                    color: AppTheme.darkCharcoal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(80, 42),
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
