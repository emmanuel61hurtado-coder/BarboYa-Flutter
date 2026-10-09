import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class PagoService {
  final DioClient _dioClient;

  PagoService(this._dioClient);

  Future<PagoRead> procesarPago({
    required String pedidoId,
    required String metodo, // EFECTIVO, TARJETA, NEQUI
    required double monto,
    String? idempotencyKey,
  }) async {
    final response = await _dioClient.dio.post(
      '/pagos',
      data: {
        'pedido_id': pedidoId,
        'metodo': metodo.toUpperCase(),
        'monto': monto,
      },
      options: idempotencyKey != null
          ? null // Options(headers: {'Idempotency-Key': idempotencyKey})
          : null,
    );
    return PagoRead.fromJson(response.data);
  }
}
