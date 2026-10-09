import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

final enviosListProvider = FutureProvider.autoDispose<List<EnvioResponse>>((ref) async {
  final envioService = ref.watch(envioServiceProvider);
  return await envioService.getEnvios();
});

class ShipmentsScreen extends ConsumerStatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  ConsumerState<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends ConsumerState<ShipmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  final _descripcionController = TextEditingController();
  final _origenController = TextEditingController(text: 'Calle 10 # 12-30');
  final _destinoController = TextEditingController(text: 'Carrera 15 # 8-45');
  final _destinatarioController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _instruccionesController = TextEditingController();

  String _tipoPaquete = 'pequeno'; // documento, pequeno, mediano, grande
  double _costoCalculado = 6000.0;
  bool _isCreating = false;
  String? _errorMessage;
  EnvioResponse? _createdEnvio;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descripcionController.dispose();
    _origenController.dispose();
    _destinoController.dispose();
    _destinatarioController.dispose();
    _telefonoController.dispose();
    _instruccionesController.dispose();
    super.dispose();
  }

  void _actualizarCosto() {
    setState(() {
      switch (_tipoPaquete) {
        case 'documento':
          _costoCalculado = 5000.0;
          break;
        case 'pequeno':
          _costoCalculado = 6000.0;
          break;
        case 'mediano':
          _costoCalculado = 8500.0;
          break;
        case 'grande':
          _costoCalculado = 12000.0;
          break;
      }
    });
  }

  Future<void> _crearEnvio() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
      _errorMessage = null;
    });

    try {
      final envioService = ref.read(envioServiceProvider);
      final envio = await envioService.crearEnvio(
        tipoPaquete: _tipoPaquete,
        descripcion: _descripcionController.text.trim(),
        origenDireccion: _origenController.text.trim(),
        origenLat: 6.4385,
        origenLng: -75.3312,
        destinoDireccion: _destinoController.text.trim(),
        destinoLat: 6.4420,
        destinoLng: -75.3280,
        nombreDestinatario: _destinatarioController.text.trim(),
        telefonoDestinatario: _telefonoController.text.trim(),
        instrucciones: _instruccionesController.text.trim().isNotEmpty
            ? _instruccionesController.text.trim()
            : null,
        costo: _costoCalculado,
      );

      setState(() {
        _createdEnvio = envio;
      });

      ref.invalidate(enviosListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Envío solicitado! Código de entrega: ${envio.codigoEntrega}'),
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
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final enviosAsync = ref.watch(enviosListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('BarboYa Envíos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.darkCharcoal,
          indicatorColor: AppTheme.primaryLime,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.local_shipping), text: 'Nuevo Envío'),
            Tab(icon: Icon(Icons.history), text: 'Mis Envíos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña 1: Crear Envío
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

                if (_createdEnvio != null) ...[
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
                                'Envío Registrado',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              StatusBadge(status: _createdEnvio!.estado),
                            ],
                          ),
                          const Divider(color: Colors.white24, height: 24),
                          Text('Destinatario: ${_createdEnvio!.nombreDestinatario}', style: const TextStyle(color: Colors.white70)),
                          Text('Destino: ${_createdEnvio!.destinoDireccion}', style: const TextStyle(color: Colors.white70)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Costo: \$${_createdEnvio!.costo.toStringAsFixed(0)} COP',
                                style: const TextStyle(color: AppTheme.primaryLime, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'CÓDIGO: ${_createdEnvio!.codigoEntrega}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                Form(
                  key: _formKey,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Tamaño del Paquete',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _tipoPaquete,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.inventory_2_outlined),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'documento', child: Text('Documentos / Sobres')),
                              DropdownMenuItem(value: 'pequeno', child: Text('Paquete Pequeño (hasta 2kg)')),
                              DropdownMenuItem(value: 'mediano', child: Text('Paquete Mediano (hasta 8kg)')),
                              DropdownMenuItem(value: 'grande', child: Text('Paquete Grande (hasta 20kg)')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                _tipoPaquete = val;
                                _actualizarCosto();
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descripcionController,
                            decoration: const InputDecoration(
                              labelText: 'Descripción del contenido',
                              prefixIcon: Icon(Icons.description_outlined),
                            ),
                            validator: (v) => v == null || v.length < 3 ? 'Describe el contenido' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _origenController,
                            decoration: const InputDecoration(
                              labelText: 'Dirección de recogida',
                              prefixIcon: Icon(Icons.my_location),
                            ),
                            validator: (v) => v == null || v.length < 3 ? 'Ingresa la recogida' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _destinoController,
                            decoration: const InputDecoration(
                              labelText: 'Dirección de entrega',
                              prefixIcon: Icon(Icons.place_outlined),
                            ),
                            validator: (v) => v == null || v.length < 3 ? 'Ingresa el destino' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _destinatarioController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre destinatario',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (v) => v == null || v.length < 2 ? 'Requerido' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _telefonoController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    labelText: 'Teléfono contacto',
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                  validator: (v) => v == null || v.length < 5 ? 'Requerido' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _instruccionesController,
                            decoration: const InputDecoration(
                              labelText: 'Instrucciones especiales (opcional)',
                              prefixIcon: Icon(Icons.info_outline),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLime.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Costo total del envío:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  '\$${_costoCalculado.toStringAsFixed(0)} COP',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Solicitar Mensajero',
                            icon: Icons.send,
                            isLoading: _isCreating,
                            onPressed: _crearEnvio,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pestaña 2: Mis Envíos
          enviosAsync.when(
            data: (envios) {
              if (envios.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.local_shipping_outlined,
                  title: 'Sin envíos registrados',
                  message: 'Aún no has solicitado ningún envío en BarboYa Envíos.',
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: envios.length,
                itemBuilder: (context, index) {
                  final e = envios[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.darkCharcoal,
                        child: const Icon(Icons.inventory_2, color: AppTheme.primaryLime, size: 20),
                      ),
                      title: Text(
                        'A: ${e.nombreDestinatario} (${e.destinoDireccion})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Paquete: ${e.descripcion} (${e.tipoPaquete})', style: const TextStyle(fontSize: 12)),
                          Text('Costo: \$${e.costo.toStringAsFixed(0)} COP • PIN: ${e.codigoEntrega}'),
                        ],
                      ),
                      trailing: StatusBadge(status: e.estado),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => ErrorBanner(
              message: 'Error al cargar envíos: $err',
              onRetry: () => ref.invalidate(enviosListProvider),
            ),
          ),
        ],
      ),
    );
  }
}
