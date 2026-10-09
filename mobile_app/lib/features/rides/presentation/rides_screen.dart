import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final viajesListProvider = FutureProvider.autoDispose<List<ViajeResponse>>((ref) async {
  final viajeService = ref.watch(viajeServiceProvider);
  return await viajeService.getViajes();
});

class RidesScreen extends ConsumerStatefulWidget {
  const RidesScreen({super.key});

  @override
  ConsumerState<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends ConsumerState<RidesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _origenController = TextEditingController(text: 'Parque Principal Barbosa');
  final _destinoController = TextEditingController(text: 'Terminal de Transportes');
  final _precioPropuestoController = TextEditingController(text: '12000');
  
  String _tipoServicio = 'carro'; // carro, moto
  double _precioEstimado = 10000.0;
  bool _isRequesting = false;
  String? _errorMessage;
  ViajeResponse? _activeViaje;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _origenController.dispose();
    _destinoController.dispose();
    _precioPropuestoController.dispose();
    super.dispose();
  }

  void _recalcularEstimado() {
    setState(() {
      _precioEstimado = _tipoServicio == 'carro' ? 12000.0 : 7000.0;
      _precioPropuestoController.text = _precioEstimado.toInt().toString();
    });
  }

  Future<void> _solicitarViaje() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isRequesting = true;
      _errorMessage = null;
    });

    try {
      final viajeService = ref.read(viajeServiceProvider);
      final propuesto = double.tryParse(_precioPropuestoController.text.trim());

      final viaje = await viajeService.solicitarViaje(
        tipoServicio: _tipoServicio,
        origenDireccion: _origenController.text.trim(),
        origenLat: 6.4385,
        origenLng: -75.3312,
        destinoDireccion: _destinoController.text.trim(),
        destinoLat: 6.4420,
        destinoLng: -75.3280,
        precioEstimado: _precioEstimado,
        precioPropuesto: propuesto,
      );

      setState(() {
        _activeViaje = viaje;
      });

      ref.invalidate(viajesListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Viaje solicitado! Código de seguridad: ${viaje.codigoConfirmacion}'),
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
          _isRequesting = false;
        });
      }
    }
  }

  Future<void> _cancelarViaje(String viajeId) async {
    try {
      final viajeService = ref.read(viajeServiceProvider);
      final viaje = await viajeService.actualizarViaje(viajeId, estado: 'CANCELADO');
      setState(() {
        if (_activeViaje?.id == viajeId) {
          _activeViaje = viaje;
        }
      });
      ref.invalidate(viajesListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cancelar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viajesAsync = ref.watch(viajesListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('BarboYa Move'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.darkCharcoal,
          indicatorColor: AppTheme.primaryLime,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.directions_car), text: 'Solicitar Viaje'),
            Tab(icon: Icon(Icons.history), text: 'Mis Viajes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña 1: Solicitar Viaje
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_errorMessage!, style: const TextStyle(color: AppTheme.errorRed)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Si hay viaje activo
                if (_activeViaje != null && _activeViaje!.estado != 'FINALIZADO' && _activeViaje!.estado != 'CANCELADO') ...[
                  Card(
                    color: AppTheme.darkCharcoal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Viaje en Progreso',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              StatusBadge(status: _activeViaje!.estado),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Text('Origen: ${_activeViaje!.origenDireccion}', style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Text('Destino: ${_activeViaje!.destinoDireccion}', style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tarifa: \$${(_activeViaje!.precioFinal ?? _activeViaje!.precioPropuesto ?? _activeViaje!.precioEstimado).toStringAsFixed(0)} COP',
                                style: const TextStyle(color: AppTheme.primaryLime, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'PIN: ${_activeViaje!.codigoConfirmacion}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Cancelar Solicitud',
                            backgroundColor: AppTheme.errorRed,
                            textColor: Colors.white,
                            onPressed: () => _cancelarViaje(_activeViaje!.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Formulario de Solicitud
                Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Elige tu tipo de servicio',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ChoiceChip(
                                  label: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.directions_car, size: 18),
                                      SizedBox(width: 8),
                                      Text('Automóvil'),
                                    ],
                                  ),
                                  selected: _tipoServicio == 'carro',
                                  selectedColor: AppTheme.primaryLime,
                                  onSelected: (val) {
                                    if (val) {
                                      _tipoServicio = 'carro';
                                      _recalcularEstimado();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ChoiceChip(
                                  label: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.two_wheeler, size: 18),
                                      SizedBox(width: 8),
                                      Text('Motocicleta'),
                                    ],
                                  ),
                                  selected: _tipoServicio == 'moto',
                                  selectedColor: AppTheme.primaryLime,
                                  onSelected: (val) {
                                    if (val) {
                                      _tipoServicio = 'moto';
                                      _recalcularEstimado();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _origenController,
                            decoration: const InputDecoration(
                              labelText: 'Punto de recogida (Origen)',
                              prefixIcon: Icon(Icons.trip_origin, color: AppTheme.darkCharcoal),
                            ),
                            validator: (v) => v == null || v.length < 3 ? 'Ingresa el origen' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _destinoController,
                            decoration: const InputDecoration(
                              labelText: 'Destino final',
                              prefixIcon: Icon(Icons.location_on, color: AppTheme.errorRed),
                            ),
                            validator: (v) => v == null || v.length < 3 ? 'Ingresa el destino' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tarifa sugerida:', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                                      Text(
                                        '\$${_precioEstimado.toInt()} COP',
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _precioPropuestoController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Tu oferta (COP)',
                                    prefixText: '\$ ',
                                  ),
                                  validator: (v) {
                                    final val = double.tryParse(v ?? '');
                                    if (val == null || val <= 0) return 'Monto válido';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Buscar Conductor',
                            icon: Icons.search,
                            isLoading: _isRequesting,
                            onPressed: _solicitarViaje,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pestaña 2: Mis Viajes
          viajesAsync.when(
            data: (viajes) {
              if (viajes.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.directions_car_outlined,
                  title: 'Sin viajes registrados',
                  message: 'Aún no has solicitado ningún viaje en BarboYa Move.',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: viajes.length,
                itemBuilder: (context, index) {
                  final v = viajes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryLime.withValues(alpha: 0.2),
                        child: Icon(
                          v.tipoServicio == 'moto' ? Icons.two_wheeler : Icons.directions_car,
                          color: AppTheme.darkCharcoal,
                        ),
                      ),
                      title: Text(
                        v.destinoDireccion,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('De: ${v.origenDireccion}', style: const TextStyle(fontSize: 12)),
                          Text(
                            'Tarifa: \$${(v.precioFinal ?? v.precioPropuesto ?? v.precioEstimado).toStringAsFixed(0)} COP',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.darkCharcoal),
                          ),
                        ],
                      ),
                      trailing: StatusBadge(status: v.estado),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorBanner(
              message: 'Error al cargar viajes: $err',
              onRetry: () => ref.invalidate(viajesListProvider),
            ),
          ),
        ],
      ),
    );
  }
}
