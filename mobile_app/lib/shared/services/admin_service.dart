import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class AdminService {
  final DioClient _dioClient;

  AdminService(this._dioClient);

  Future<List<UserRead>> getUsuarios() async {
    final response = await _dioClient.dio.get('/admin/usuarios');
    final list = response.data as List;
    return list.map((e) => UserRead.fromJson(e)).toList();
  }

  Future<UserRead> aprobarUsuario(String userId) async {
    final response = await _dioClient.dio.patch('/admin/usuarios/$userId/aprobar');
    return UserRead.fromJson(response.data);
  }

  Future<UserRead> bloquearUsuario(String userId) async {
    final response = await _dioClient.dio.patch('/admin/usuarios/$userId/bloquear');
    return UserRead.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getReporteVentas() async {
    final response = await _dioClient.dio.get('/reportes/ventas');
    return response.data as Map<String, dynamic>;
  }
}
