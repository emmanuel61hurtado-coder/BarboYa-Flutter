import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final orderDetailProvider = FutureProvider.family<PedidoRead, String>((ref, id) async {
  return await ref.read(pedidoServiceProvider).getPedidoDetail(id);
});

class OrderDetailScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  String? _liveEstado;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    final ws = ref.read(websocketServiceProvider);
    ws.listenToPedido(widget.orderId).listen((data) {
      if (mounted && data.containsKey('estado')) {
        setState(() {
          _liveEstado = data['estado']?.toString();
        });
        ref.invalidate(orderDetailProvider(widget.orderId));
      }
    });
  }

  void _mostrarDialogoCalificacion(PedidoRead order) {
    int puntuacion = 5;
    final comentarioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text('Calificar tu pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Cómo estuvo tu experiencia?', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < puntuacion ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setModalState(() {
                        puntuacion = index + 1;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: comentarioCtrl,
                decoration: const InputDecoration(
                  labelText: 'Comentario (opcional)',
                  hintText: 'Excelente servicio, muy rápido...',
                ),
                maxLines: 2,
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
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await ref.read(calificacionServiceProvider).calificar(
                        pedidoId: order.id,
                        comercioId: order.comercioId,
                        repartidorId: order.repartidorId,
                        puntuacion: puntuacion,
                        comentario: comentarioCtrl.text.trim().isNotEmpty ? comentarioCtrl.text.trim() : null,
                      );
                  if (mounted) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('¡Gracias por tu calificación!'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Error al calificar: $e')),
                    );
                  }
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Detalle del Pedido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(orderDetailProvider(widget.orderId)),
          ),
        ],
      ),
      body: orderAsync.when(
        data: (order) {
          final estadoActual = _liveEstado ?? order.estado;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pedido #${order.id.substring(0, 8)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkCharcoal),
                          ),
                          StatusBadge(status: estadoActual),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Estado visual con pasos
                      _buildStateTracker(estadoActual),
                      const Divider(height: 32),
                      const Text(
                        'Productos solicitados:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.darkCharcoal),
                      ),
                      const SizedBox(height: 12),
                      ...order.detalles.map((detalle) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${detalle.cantidad}x ${detalle.nombreProducto ?? 'Producto'}'),
                                Text('\$${detalle.subtotal.toStringAsFixed(0)} COP'),
                              ],
                            ),
                          )),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text('\$${order.subtotal.toStringAsFixed(0)} COP'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Envío'),
                          Text('\$${order.costoEnvio.toStringAsFixed(0)} COP'),
                        ],
                      ),
                      if (order.descuento > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Descuento (${order.cuponCodigo ?? ''})', style: const TextStyle(color: AppTheme.successGreen)),
                            Text('-\$${order.descuento.toStringAsFixed(0)} COP', style: const TextStyle(color: AppTheme.successGreen, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total General', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkCharcoal)),
                          Text(
                            '\$${order.total.toStringAsFixed(0)} COP',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.darkCharcoal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Método de pago: ${order.metodoPago}',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (estadoActual == 'ENTREGADO') ...[
                CustomButton(
                  text: 'Calificar Pedido',
                  icon: Icons.star_rate,
                  backgroundColor: AppTheme.primaryLime,
                  onPressed: () => _mostrarDialogoCalificacion(order),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorBanner(
          message: 'Error al cargar pedido: $err',
          onRetry: () => ref.invalidate(orderDetailProvider(widget.orderId)),
        ),
      ),
    );
  }

  Widget _buildStateTracker(String currentStatus) {
    final stages = ['CREADO', 'ACEPTADO', 'PREPARANDO', 'LISTO', 'EN_CAMINO', 'ENTREGADO'];
    final currentIndex = stages.indexOf(currentStatus);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stages.asMap().entries.map((entry) {
          final idx = entry.key;
          final name = entry.value;
          final isDone = currentIndex >= idx;
          final isCurrent = currentIndex == idx;

          return Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isDone
                    ? (isCurrent ? AppTheme.darkCharcoal : AppTheme.primaryLime)
                    : Colors.grey.shade300,
                child: Icon(
                  isDone ? Icons.check : Icons.circle,
                  size: 14,
                  color: isDone ? Colors.white : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name.substring(0, 3),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isDone ? AppTheme.darkCharcoal : Colors.grey,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
