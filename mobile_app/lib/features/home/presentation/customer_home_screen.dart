import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final comerciosListProvider = FutureProvider.autoDispose<List<ComercioRead>>((ref) async {
  final comercioService = ref.watch(comercioServiceProvider);
  return await comercioService.getComercios();
});

final categoriasListProvider = FutureProvider.autoDispose<List<CategoriaRead>>((ref) async {
  final comercioService = ref.watch(comercioServiceProvider);
  return await comercioService.getCategorias();
});

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  String _searchQuery = '';
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comerciosAsync = ref.watch(comerciosListProvider);
    final categoriasAsync = ref.watch(categoriasListProvider);
    final cartState = ref.watch(cartProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.darkCharcoal,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.bolt, color: AppTheme.primaryLime, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'BarboYa',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(comerciosListProvider);
          ref.invalidate(categoriasListProvider);
          ref.invalidate(currentUserProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo personalizado
              userAsync.when(
                data: (user) => Text(
                  '¡Hola, ${user.nombre.split(' ').first}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.darkCharcoal,
                  ),
                ),
                loading: () => const Text('¡Hola!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                error: (_, _) => const Text('¡Bienvenido a BarboYa!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 4),
              const Text(
                '¿Qué necesitas hoy en Barbosa y alrededores?',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Banner de Ubicación
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.darkCharcoal,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLime,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on, color: AppTheme.darkCharcoal, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ubicación activa:', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          Text(
                            'Parque Principal, Barbosa',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // SECCIÓN: Los 3 Servicios Principales de la SuperApp
              const Text(
                'Nuestros Servicios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // 1. Move (Viajes)
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.directions_car,
                      title: 'Viajes',
                      subtitle: 'Carro o Moto',
                      color: AppTheme.primaryLime,
                      textColor: AppTheme.darkCharcoal,
                      onTap: () => context.push('/rides'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 2. Comida (Restaurantes)
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.restaurant,
                      title: 'Comida',
                      subtitle: 'Restaurantes',
                      color: AppTheme.darkCharcoal,
                      textColor: Colors.white,
                      iconColor: AppTheme.primaryLime,
                      onTap: () {
                        // Scroll to restaurants section
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 3. Envíos (Mensajería)
                  Expanded(
                    child: _buildServiceCard(
                      icon: Icons.local_shipping,
                      title: 'Envíos',
                      subtitle: 'Paquetería',
                      color: const Color(0xFFE8ECE4),
                      textColor: AppTheme.darkCharcoal,
                      onTap: () => context.push('/shipments'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Accesos Rápidos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(
                    icon: Icons.receipt_long,
                    label: 'Mis Pedidos',
                    onTap: () => context.push('/orders'),
                  ),
                  _buildQuickAction(
                    icon: Icons.directions_car_outlined,
                    label: 'Mis Viajes',
                    onTap: () => context.push('/rides'),
                  ),
                  _buildQuickAction(
                    icon: Icons.inventory_2_outlined,
                    label: 'Mis Envíos',
                    onTap: () => context.push('/shipments'),
                  ),
                  _buildQuickAction(
                    icon: Icons.support_agent,
                    label: 'Soporte',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Centro de Ayuda BarboYa: soporte@barboya.com')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Buscador de Restaurantes y Platos
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase().trim();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar restaurantes o platos...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.darkCharcoal),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),

              // Filtro de Categorías
              categoriasAsync.when(
                data: (categorias) {
                  if (categorias.isEmpty) return const SizedBox.shrink();
                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categorias.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          final isSelected = _selectedCategory == null;
                          return ChoiceChip(
                            label: const Text('Todos'),
                            selected: isSelected,
                            selectedColor: AppTheme.primaryLime,
                            onSelected: (_) => setState(() => _selectedCategory = null),
                          );
                        }
                        final cat = categorias[index - 1];
                        final isSelected = _selectedCategory == cat.id;
                        return ChoiceChip(
                          label: Text(cat.nombre),
                          selected: isSelected,
                          selectedColor: AppTheme.primaryLime,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = isSelected ? null : cat.id;
                            });
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),

              // Lista de Comercios
              const Text(
                'Restaurantes y Comercios',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
              ),
              const SizedBox(height: 12),
              comerciosAsync.when(
                data: (comercios) {
                  var filtered = comercios;
                  if (_searchQuery.isNotEmpty) {
                    filtered = filtered.where((c) {
                      final nameMatch = c.nombre.toLowerCase().contains(_searchQuery);
                      final descMatch = c.descripcion?.toLowerCase().contains(_searchQuery) ?? false;
                      final prodMatch = c.productos.any((p) => p.nombre.toLowerCase().contains(_searchQuery));
                      return nameMatch || descMatch || prodMatch;
                    }).toList();
                  }

                  if (filtered.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.storefront_outlined,
                      title: 'No se encontraron comercios',
                      message: 'Intenta con otro término de búsqueda.',
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final comercio = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => context.push('/commerce/${comercio.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 130,
                                width: double.infinity,
                                color: AppTheme.darkCharcoal.withValues(alpha: 0.05),
                                child: Center(
                                  child: Icon(
                                    Icons.restaurant_menu,
                                    size: 52,
                                    color: AppTheme.darkCharcoal.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
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
                                              color: AppTheme.darkCharcoal,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comercio.descripcion ?? comercio.direccion,
                                            style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                comercio.calificacionPromedio.toStringAsFixed(1),
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(Icons.delivery_dining, size: 16, color: AppTheme.textMuted),
                                              const SizedBox(width: 4),
                                              const Text('Envío \$5.000', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatusBadge(
                                      status: comercio.abierto ? 'ACTIVO' : 'CERRADO',
                                      customLabel: comercio.abierto ? 'Abierto' : 'Cerrado',
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
                error: (err, _) => ErrorBanner(
                  message: 'Error al cargar comercios: $err',
                  onRetry: () => ref.invalidate(comerciosListProvider),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: cartState.items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: ElevatedButton(
                onPressed: () => context.push('/cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkCharcoal,
                  foregroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ver Carrito (${cartState.items.length} productos)'),
                    Text(
                      '\$${cartState.total.toStringAsFixed(0)} COP',
                      style: const TextStyle(color: AppTheme.primaryLime, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: iconColor ?? textColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: textColor.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppTheme.darkCharcoal, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
