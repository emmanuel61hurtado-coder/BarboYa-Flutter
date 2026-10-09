import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class CalificacionService {
  final DioClient _dioClient;

  CalificacionService(this._dioClient);

  Future<CalificacionRead> calificar({
    required String pedidoId,
    String? comercioId,
    String? repartidorId,
    required int puntuacion,
    String? comentario,
  }) async {
    final response = await _dioClient.dio.post(
      '/calificaciones',
      data: {
        'pedido_id': pedidoId,
        if (comercioId != null) 'comercio_id': comercioId,
        if (repartidorId != null) 'repartidor_id': repartidorId,
        'puntuacion': puntuacion,
        if (comentario != null) 'comentario': comentario,
      },
    );
    return CalificacionRead.fromJson(response.data);
  }
}
