import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class PedidoService {
  final DioClient _dioClient;

  PedidoService(this._dioClient);

  Future<PedidoRead> crearPedido({
    required String comercioId,
    required String direccionId,
    required String metodoPago,
    String? cuponCodigo,
    required List<Map<String, dynamic>> detalles,
  }) async {
    final response = await _dioClient.dio.post(
      '/pedidos',
      data: {
        'comercio_id': comercioId,
        'direccion_id': direccionId,
        'metodo_pago': metodoPago,
        'cupon_codigo': cuponCodigo,
        'detalles': detalles,
      },
    );
    return PedidoRead.fromJson(response.data);
  }

  Future<List<PedidoRead>> getPedidos() async {
    final response = await _dioClient.dio.get('/pedidos');
    final list = response.data as List;
    return list.map((e) => PedidoRead.fromJson(e)).toList();
  }

  Future<PedidoRead> getPedidoDetail(String id) async {
    final response = await _dioClient.dio.get('/pedidos/$id');
    return PedidoRead.fromJson(response.data);
  }

  Future<PedidoRead> actualizarEstadoPedido(String id, String nuevoEstado) async {
    final response = await _dioClient.dio.patch(
      '/pedidos/$id/estado',
      data: {'estado': nuevoEstado},
    );
    return PedidoRead.fromJson(response.data);
  }
}
