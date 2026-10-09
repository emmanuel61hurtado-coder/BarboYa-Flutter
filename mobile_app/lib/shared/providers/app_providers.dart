import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';
import 'package:mobile_app/shared/services/admin_service.dart';
import 'package:mobile_app/shared/services/auth_service.dart';
import 'package:mobile_app/shared/services/calificacion_service.dart';
import 'package:mobile_app/shared/services/comercio_service.dart';
import 'package:mobile_app/shared/services/cupon_service.dart';
import 'package:mobile_app/shared/services/direccion_service.dart';
import 'package:mobile_app/shared/services/entrega_service.dart';
import 'package:mobile_app/shared/services/envio_service.dart';
import 'package:mobile_app/shared/services/notificacion_service.dart';
import 'package:mobile_app/shared/services/pago_service.dart';
import 'package:mobile_app/shared/services/pedido_service.dart';
import 'package:mobile_app/shared/services/vehiculo_service.dart';
import 'package:mobile_app/shared/services/viaje_service.dart';
import 'package:mobile_app/shared/services/websocket_service.dart';

// Cliente HTTP Centralizado
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Servicios de Dominio
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(dioClientProvider));
});

final comercioServiceProvider = Provider<ComercioService>((ref) {
  return ComercioService(ref.watch(dioClientProvider));
});

final pedidoServiceProvider = Provider<PedidoService>((ref) {
  return PedidoService(ref.watch(dioClientProvider));
});

final entregaServiceProvider = Provider<EntregaService>((ref) {
  return EntregaService(ref.watch(dioClientProvider));
});

final viajeServiceProvider = Provider<ViajeService>((ref) {
  return ViajeService(ref.watch(dioClientProvider));
});

final envioServiceProvider = Provider<EnvioService>((ref) {
  return EnvioService(ref.watch(dioClientProvider));
});

final direccionServiceProvider = Provider<DireccionService>((ref) {
  return DireccionService(ref.watch(dioClientProvider));
});

final cuponServiceProvider = Provider<CuponService>((ref) {
  return CuponService(ref.watch(dioClientProvider));
});

final calificacionServiceProvider = Provider<CalificacionService>((ref) {
  return CalificacionService(ref.watch(dioClientProvider));
});

final notificacionServiceProvider = Provider<NotificacionService>((ref) {
  return NotificacionService(ref.watch(dioClientProvider));
});

final vehiculoServiceProvider = Provider<VehiculoService>((ref) {
  return VehiculoService(ref.watch(dioClientProvider));
});

final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService(ref.watch(dioClientProvider));
});

final pagoServiceProvider = Provider<PagoService>((ref) {
  return PagoService(ref.watch(dioClientProvider));
});

final websocketServiceProvider = Provider<WebSocketService>((ref) {
  return WebSocketService();
});

// Estado de Usuario Actual
final currentUserProvider = FutureProvider<UserRead>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getMe();
});
