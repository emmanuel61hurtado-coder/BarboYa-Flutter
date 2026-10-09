import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class EntregaService {
  final DioClient _dioClient;

  EntregaService(this._dioClient);

  Future<List<PedidoRead>> getEntregasDisponibles() async {
    final response = await _dioClient.dio.get('/entregas/disponibles');
    final list = response.data as List;
    return list.map((e) => PedidoRead.fromJson(e)).toList();
  }

  Future<EntregaRead> aceptarEntrega(String pedidoId) async {
    final response = await _dioClient.dio.post('/entregas/$pedidoId/aceptar');
    return EntregaRead.fromJson(response.data);
  }

  Future<EntregaRead> actualizarEstado(String id, String estado) async {
    final response = await _dioClient.dio.patch(
      '/entregas/$id/estado',
      queryParameters: {'estado': estado},
    );
    return EntregaRead.fromJson(response.data);
  }

  Future<EntregaRead> actualizarUbicacion(String id, {required double lat, required double lng}) async {
    final response = await _dioClient.dio.patch(
      '/entregas/$id/ubicacion',
      data: {'lat': lat, 'lng': lng},
    );
    return EntregaRead.fromJson(response.data);
  }
}
