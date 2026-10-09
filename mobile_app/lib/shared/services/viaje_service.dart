import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class ViajeService {
  final DioClient _dioClient;

  ViajeService(this._dioClient);

  Future<ViajeResponse> solicitarViaje({
    required String tipoServicio, // carro, moto
    required String origenDireccion,
    required double origenLat,
    required double origenLng,
    required String destinoDireccion,
    required double destinoLat,
    required double destinoLng,
    required double precioEstimado,
    double? precioPropuesto,
  }) async {
    final response = await _dioClient.dio.post(
      '/viajes/',
      data: {
        'tipo_servicio': tipoServicio,
        'origen_direccion': origenDireccion,
        'origen_lat': origenLat,
        'origen_lng': origenLng,
        'destino_direccion': destinoDireccion,
        'destino_lat': destinoLat,
        'destino_lng': destinoLng,
        'precio_estimado': precioEstimado,
        'precio_propuesto': ?precioPropuesto,
      },
    );
    return ViajeResponse.fromJson(response.data);
  }

  Future<List<ViajeResponse>> getViajes({int skip = 0, int limit = 50}) async {
    final response = await _dioClient.dio.get(
      '/viajes/',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final list = response.data as List;
    return list.map((e) => ViajeResponse.fromJson(e)).toList();
  }

  Future<ViajeResponse> getViaje(String id) async {
    final response = await _dioClient.dio.get('/viajes/$id');
    return ViajeResponse.fromJson(response.data);
  }

  Future<ViajeResponse> actualizarViaje(
    String id, {
    String? estado,
    String? conductorId,
    double? precioPropuesto,
    double? precioFinal,
  }) async {
    final payload = <String, dynamic>{};
    if (estado != null) payload['estado'] = estado;
    if (conductorId != null) payload['conductor_id'] = conductorId;
    if (precioPropuesto != null) payload['precio_propuesto'] = precioPropuesto;
    if (precioFinal != null) payload['precio_final'] = precioFinal;

    final response = await _dioClient.dio.patch(
      '/viajes/$id',
      data: payload,
    );
    return ViajeResponse.fromJson(response.data);
  }
}
