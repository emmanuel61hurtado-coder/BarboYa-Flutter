import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/services/comercio_service.dart';

final comercioServiceProvider = Provider<ComercioService>((ref) {
  return ComercioService(DioClient());
});

final comerciosProvider = FutureProvider<List<ComercioRead>>((ref) async {
  return await ref.read(comercioServiceProvider).getComercios();
});

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color secondaryDark = Color(0xFF1E1E24);
    const Color primaryOrange = Color(0xFFFF6B00);
    const Color backgroundLight = Color(0xFFF8F9FA);

    final comerciosAsync = ref.watch(comerciosProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: AppBar(
        title: const Text('BarboYa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.push('/orders'),
            tooltip: 'Mis Pedidos',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
            tooltip: 'Mi Perfil',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(comerciosProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Delivery Address Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: primaryOrange, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entrega en:',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          'Calle Principal #45-20',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Cambiar', style: TextStyle(color: primaryOrange)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar restaurantes o platos...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Comercios Disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryDark,
              ),
            ),
            const SizedBox(height: 16),
            comerciosAsync.when(
              data: (comercios) {
                if (comercios.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No hay comercios activos en este momento.'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comercios.length,
                  itemBuilder: (context, index) {
                    final comercio = comercios[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.push('/commerce/${comercio.id}'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 140,
                              width: double.infinity,
                              color: Colors.orange.shade100,
                              child: const Icon(Icons.store, size: 64, color: AppTheme.primaryOrange),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:                                 MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comercio.nombre,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comercio.descripcion ?? comercio.direccion,
                                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: comercio.abierto ? Colors.green.shade50 : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      comercio.abierto ? 'Abierto' : 'Cerrado',
                                      style: TextStyle(
                                        color: comercio.abierto ? Colors.green.shade800 : Colors.red.shade800,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Center(
                child: Text('Error al cargar comercios: $err'),
              ),
            ),
          ],
        ),
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
