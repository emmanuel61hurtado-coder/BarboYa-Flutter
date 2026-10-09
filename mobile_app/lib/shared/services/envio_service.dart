import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class EnvioService {
  final DioClient _dioClient;

  EnvioService(this._dioClient);

  Future<EnvioResponse> crearEnvio({
    required String tipoPaquete, // documento, pequeño, mediano, grande
    required String descripcion,
    double? pesoKg,
    required String origenDireccion,
    required double origenLat,
    required double origenLng,
    required String destinoDireccion,
    required double destinoLat,
    required double destinoLng,
    required String nombreDestinatario,
    required String telefonoDestinatario,
    String? instrucciones,
    required double costo,
  }) async {
    final response = await _dioClient.dio.post(
      '/envios/',
      data: {
        'tipo_paquete': tipoPaquete,
        'descripcion': descripcion,
        if (pesoKg != null) 'peso_kg': pesoKg,
        'origen_direccion': origenDireccion,
        'origen_lat': origenLat,
        'origen_lng': origenLng,
        'destino_direccion': destinoDireccion,
        'destino_lat': destinoLat,
        'destino_lng': destinoLng,
        'nombre_destinatario': nombreDestinatario,
        'telefono_destinatario': telefonoDestinatario,
        if (instrucciones != null) 'instrucciones': instrucciones,
        'costo': costo,
      },
    );
    return EnvioResponse.fromJson(response.data);
  }

  Future<List<EnvioResponse>> getEnvios({int skip = 0, int limit = 50}) async {
    final response = await _dioClient.dio.get(
      '/envios/',
      queryParameters: {'skip': skip, 'limit': limit},
    );
    final list = response.data as List;
    return list.map((e) => EnvioResponse.fromJson(e)).toList();
  }

  Future<EnvioResponse> getEnvio(String id) async {
    final response = await _dioClient.dio.get('/envios/$id');
    return EnvioResponse.fromJson(response.data);
  }

  Future<EnvioResponse> actualizarEnvio(
    String id, {
    String? estado,
    String? repartidorId,
  }) async {
    final payload = <String, dynamic>{};
    if (estado != null) payload['estado'] = estado;
    if (repartidorId != null) payload['repartidor_id'] = repartidorId;

    final response = await _dioClient.dio.patch(
      '/envios/$id',
      data: payload,
    );
    return EnvioResponse.fromJson(response.data);
  }
}
