import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class CuponService {
  final DioClient _dioClient;

  CuponService(this._dioClient);

  Future<CuponRead> validarCupon({
    required String codigo,
    required double subtotal,
  }) async {
    final response = await _dioClient.dio.post(
      '/cupones/validar',
      data: {
        'codigo': codigo.trim().toUpperCase(),
        'subtotal': subtotal,
      },
    );
    return CuponRead.fromJson(response.data);
  }

  Future<CuponRead> crearCupon({
    required String codigo,
    double? descuentoPorcentaje,
    double? descuentoMonto,
    required double montoMinimo,
    int usosMaximos = 100,
  }) async {
    final response = await _dioClient.dio.post(
      '/cupones',
      data: {
        'codigo': codigo.trim().toUpperCase(),
        'descuento_porcentaje': ?descuentoPorcentaje,
        'descuento_monto': ?descuentoMonto,
        'monto_minimo': montoMinimo,
        'usos_maximos': usosMaximos,
        'activo': true,
      },
    );
    return CuponRead.fromJson(response.data);
  }
}
