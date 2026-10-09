import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/security/secure_storage.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final availableDeliveriesProvider = FutureProvider.autoDispose<List<PedidoRead>>((ref) async {
  final service = ref.watch(entregaServiceProvider);
  return await service.getEntregasDisponibles();
});

final miVehiculoProvider = FutureProvider.autoDispose<VehiculoRead?>((ref) async {
  final service = ref.watch(vehiculoServiceProvider);
  return await service.getMiVehiculo();
});

class DeliveryDashboardScreen extends ConsumerWidget {
  const DeliveryDashboardScreen({super.key});

  void _mostrarRegistroVehiculo(BuildContext context, WidgetRef ref) {
    String tipo = 'MOTO';
    final placaCtrl = TextEditingController();
    final modeloCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Registrar Vehículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: tipo,
                decoration: const InputDecoration(labelText: 'Tipo de Vehículo'),
                items: const [
                  DropdownMenuItem(value: 'MOTO', child: Text('Motocicleta')),
                  DropdownMenuItem(value: 'BICI', child: Text('Bicicleta')),
                  DropdownMenuItem(value: 'CARRO', child: Text('Automóvil')),
                ],
                onChanged: (val) {
                  if (val != null) setModalState(() => tipo = val);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: placaCtrl,
                decoration: const InputDecoration(labelText: 'Placa (ej: ABC12D)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: modeloCtrl,
                decoration: const InputDecoration(labelText: 'Modelo / Marca'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                try {
                  await ref.read(vehiculoServiceProvider).registrarVehiculo(
                        tipo: tipo,
                        placa: placaCtrl.text.trim().isNotEmpty ? placaCtrl.text.trim() : null,
                        modelo: modeloCtrl.text.trim().isNotEmpty ? modeloCtrl.text.trim() : null,
                      );
                  ref.invalidate(miVehiculoProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Vehículo registrado con éxito!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(availableDeliveriesProvider);
    final vehiculoAsync = ref.watch(miVehiculoProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Panel de Repartidor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.two_wheeler),
            onPressed: () => _mostrarRegistroVehiculo(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SecureStorage.clearSession();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.darkCharcoal,
        backgroundColor: AppTheme.primaryLime,
        onRefresh: () async {
          ref.invalidate(availableDeliveriesProvider);
          ref.invalidate(miVehiculoProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.darkCharcoal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining, color: AppTheme.primaryLime, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entregas Disponibles',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        vehiculoAsync.when(
                          data: (vehiculo) => Text(
                            vehiculo != null
                                ? 'Vehículo activo: ${vehiculo.tipo} (${vehiculo.placa ?? 'Sin placa'})'
                                : 'Registra tu vehículo tocando el ícono superior',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          loading: () => const Text('Cargando vehículo...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          error: (_, __) => const Text('Acepta pedidos listos para repartir', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            deliveriesAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.check_circle_outline,
                    title: 'Sin entregas pendientes',
                    message: 'No hay pedidos en estado LISTO esperando repartidor en este momento.',
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pedido #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('\$${order.total.toStringAsFixed(0)} COP', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal)),
                              ],
                            ),
                            const Divider(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pago: ${order.metodoPago}', style: const TextStyle(color: AppTheme.textMuted)),
                                const StatusBadge(status: 'LISTO', customLabel: 'Listo para entrega'),
                              ],
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: 'Aceptar Entrega (Tomar Pedido)',
                              icon: Icons.check,
                              onPressed: () async {
                                try {
                                  final service = ref.read(entregaServiceProvider);
                                  await service.aceptarEntrega(order.id);
                                  ref.invalidate(availableDeliveriesProvider);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('¡Entrega aceptada con éxito! Dirígete al comercio.'),
                                        backgroundColor: AppTheme.successGreen,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al aceptar: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => ErrorBanner(
                message: 'Error al cargar entregas: $err',
                onRetry: () => ref.invalidate(availableDeliveriesProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
