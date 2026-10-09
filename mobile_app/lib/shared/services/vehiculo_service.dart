import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class VehiculoService {
  final DioClient _dioClient;

  VehiculoService(this._dioClient);

  Future<VehiculoRead?> getMiVehiculo() async {
    try {
      final response = await _dioClient.dio.get('/vehiculos/me');
      return VehiculoRead.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<VehiculoRead> registrarVehiculo({
    required String tipo, // MOTO, BICI, CARRO
    String? placa,
    String? modelo,
  }) async {
    final response = await _dioClient.dio.post(
      '/vehiculos',
      data: {
        'tipo': tipo.toUpperCase(),
        if (placa != null) 'placa': placa.trim().toUpperCase(),
        if (modelo != null) 'modelo': modelo.trim(),
      },
    );
    return VehiculoRead.fromJson(response.data);
  }
}
