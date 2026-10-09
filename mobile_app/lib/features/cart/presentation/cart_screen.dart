import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final direccionesListProvider = FutureProvider.autoDispose<List<DireccionRead>>((ref) async {
  final direccionService = ref.watch(direccionServiceProvider);
  return await direccionService.getDirecciones();
});

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _cuponController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  String? _selectedDireccionId;
  String _metodoPago = 'EFECTIVO'; // EFECTIVO, NEQUI, TARJETA
  double _descuentoCupon = 0.0;
  String? _cuponAplicado;
  bool _isValidatingCoupon = false;

  @override
  void dispose() {
    _cuponController.dispose();
    super.dispose();
  }

  Future<void> _validarCupon(double subtotal) async {
    final codigo = _cuponController.text.trim();
    if (codigo.isEmpty) return;

    setState(() {
      _isValidatingCoupon = true;
      _errorMessage = null;
    });

    try {
      final cupon = await ref.read(cuponServiceProvider).validarCupon(
            codigo: codigo,
            subtotal: subtotal,
          );

      double desc = 0.0;
      if (cupon.descuentoPorcentaje != null) {
        desc = subtotal * (cupon.descuentoPorcentaje! / 100.0);
      } else if (cupon.descuentoMonto != null) {
        desc = cupon.descuentoMonto!;
      }

      setState(() {
        _cuponAplicado = cupon.codigo;
        _descuentoCupon = desc;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Cupón ${cupon.codigo} aplicado! Descuento: \$${desc.toStringAsFixed(0)}'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('ApiException: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isValidatingCoupon = false;
        });
      }
    }
  }

  Future<void> _agregarDireccionRapida() async {
    final nombreCtrl = TextEditingController(text: 'Mi Casa');
    final dirCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Dirección'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Alias (ej: Casa, Oficina)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dirCtrl,
              decoration: const InputDecoration(labelText: 'Dirección completa (Barbosa)'),
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
              if (dirCtrl.text.isNotEmpty) {
                Navigator.pop(ctx);
                try {
                  final nueva = await ref.read(direccionServiceProvider).crearDireccion(
                        nombre: nombreCtrl.text.trim(),
                        direccion: dirCtrl.text.trim(),
                        lat: 6.4385,
                        lng: -75.3312,
                      );
                  ref.invalidate(direccionesListProvider);
                  setState(() {
                    _selectedDireccionId = nueva.id;
                  });
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkout() async {
    final cartState = ref.read(cartProvider);
    if (cartState.items.isEmpty || cartState.comercioId == null) return;

    if (_selectedDireccionId == null) {
      setState(() {
        _errorMessage = 'Por favor selecciona o agrega una dirección de entrega.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pedidoService = ref.read(pedidoServiceProvider);
      final detalles = cartState.items
          .map((i) => {
                'producto_id': i.producto.id,
                'cantidad': i.cantidad,
              })
          .toList();

      final pedido = await pedidoService.crearPedido(
        comercioId: cartState.comercioId!,
        direccionId: _selectedDireccionId!,
        metodoPago: _metodoPago,
        cuponCodigo: _cuponAplicado,
        detalles: detalles,
      );

      ref.read(cartProvider.notifier).clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Pedido creado exitosamente!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      context.go('/order/${pedido.id}');
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
    final cartState = ref.watch(cartProvider);
    final direccionesAsync = ref.watch(direccionesListProvider);

    final subtotal = cartState.total;
    const costoEnvio = 5000.0;
    final total = (subtotal + costoEnvio - _descuentoCupon).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Tu Carrito'),
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              onPressed: () => ref.read(cartProvider.notifier).clear(),
            ),
        ],
      ),
      body: cartState.items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Tu carrito está vacío',
              message: 'Explora nuestros comercios y añade deliciosos platos a tu orden.',
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Productos en carrito
                ...cartState.items.map((item) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.producto.nombre,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkCharcoal),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.producto.precio.toStringAsFixed(0)} COP c/u',
                                    style: const TextStyle(color: AppTheme.textMuted),
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
                                Text(
                                  '${item.cantidad}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(item.producto.id, 1),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
                                  onPressed: () =>
                                      ref.read(cartProvider.notifier).removeProducto(item.producto.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 16),

                // Dirección de entrega
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dirección de Entrega',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            TextButton.icon(
                              onPressed: _agregarDireccionRapida,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Nueva'),
                            ),
                          ],
                        ),
                        direccionesAsync.when(
                          data: (dirs) {
                            if (dirs.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextButton.icon(
                                  onPressed: _agregarDireccionRapida,
                                  icon: const Icon(Icons.location_on),
                                  label: const Text('Registrar dirección para continuar'),
                                ),
                              );
                            }
                            _selectedDireccionId ??= dirs.first.id;
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedDireccionId,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.place_outlined),
                              ),
                              items: dirs.map((d) {
                                return DropdownMenuItem(
                                  value: d.id,
                                  child: Text('${d.nombre} (${d.direccion})', overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedDireccionId = val;
                                });
                              },
                            );
                          },
                          loading: () => const LinearProgressIndicator(),
                          error: (_, _) => TextButton(
                            onPressed: _agregarDireccionRapida,
                            child: const Text('Crear dirección'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cupón de descuento
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cuponController,
                            decoration: const InputDecoration(
                              labelText: 'Código de cupón',
                              prefixIcon: Icon(Icons.confirmation_number_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isValidatingCoupon ? null : () => _validarCupon(subtotal),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(90, 48)),
                          child: _isValidatingCoupon
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Aplicar'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Método de Pago
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Método de Pago',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Efectivo'),
                                selected: _metodoPago == 'EFECTIVO',
                                selectedColor: AppTheme.primaryLime,
                                onSelected: (_) => setState(() => _metodoPago = 'EFECTIVO'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Nequi'),
                                selected: _metodoPago == 'NEQUI',
                                selectedColor: AppTheme.primaryLime,
                                onSelected: (_) => setState(() => _metodoPago = 'NEQUI'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Tarjeta'),
                                selected: _metodoPago == 'TARJETA',
                                selectedColor: AppTheme.primaryLime,
                                onSelected: (_) => setState(() => _metodoPago = 'TARJETA'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Resumen de pago
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Resumen de Pedido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('\$${subtotal.toStringAsFixed(0)} COP'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Costo de envío estándar'),
                            Text('\$5.000 COP'),
                          ],
                        ),
                        if (_descuentoCupon > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Descuento (${_cuponAplicado ?? ''})', style: const TextStyle(color: AppTheme.successGreen)),
                              Text('-\$${_descuentoCupon.toStringAsFixed(0)} COP', style: const TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total a pagar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkCharcoal)),
                            Text(
                              '\$${total.toStringAsFixed(0)} COP',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkCharcoal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Confirmar y Pedir',
                  isLoading: _isLoading,
                  onPressed: _checkout,
                ),
              ],
            ),
    );
  }
}
