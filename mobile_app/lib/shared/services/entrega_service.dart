import 'package:dio/dio.dart';
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
}
