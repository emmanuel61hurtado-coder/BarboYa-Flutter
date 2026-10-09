import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class DireccionService {
  final DioClient _dioClient;

  DireccionService(this._dioClient);

  Future<List<DireccionRead>> getDirecciones() async {
    final response = await _dioClient.dio.get('/direcciones');
    final list = response.data as List;
    return list.map((e) => DireccionRead.fromJson(e)).toList();
  }

  Future<DireccionRead> crearDireccion({
    required String nombre,
    required String direccion,
    String? detalles,
    required double lat,
    required double lng,
  }) async {
    final response = await _dioClient.dio.post(
      '/direcciones',
      data: {
        'nombre': nombre,
        'direccion': direccion,
        if (detalles != null) 'detalles': detalles,
        'lat': lat,
        'lng': lng,
      },
    );
    return DireccionRead.fromJson(response.data);
  }
}
