import 'package:dio/dio.dart';
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class ComercioService {
  final DioClient _dioClient;

  ComercioService(this._dioClient);

  Future<List<ComercioRead>> getComercios() async {
    final response = await _dioClient.dio.get('/comercios');
    final list = response.data as List;
    return list.map((e) => ComercioRead.fromJson(e)).toList();
  }

  Future<ComercioRead> getComercioDetail(String id) async {
    final response = await _dioClient.dio.get('/comercios/$id');
    return ComercioRead.fromJson(response.data);
  }

  Future<List<CategoriaRead>> getCategorias() async {
    final response = await _dioClient.dio.get('/categorias');
    final list = response.data as List;
    return list.map((e) => CategoriaRead.fromJson(e)).toList();
  }
}
