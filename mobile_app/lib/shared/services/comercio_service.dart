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

  Future<ComercioRead> crearComercio({
    required String nombre,
    String? descripcion,
    required String direccion,
    required double lat,
    required double lng,
    String? logoUrl,
    String? bannerUrl,
  }) async {
    final response = await _dioClient.dio.post(
      '/comercios',
      data: {
        'nombre': nombre,
        'descripcion': descripcion,
        'direccion': direccion,
        'lat': lat,
        'lng': lng,
        'logo_url': logoUrl,
        'banner_url': bannerUrl,
        'abierto': true,
      },
    );
    return ComercioRead.fromJson(response.data);
  }

  Future<List<ProductoRead>> getMisProductos() async {
    final response = await _dioClient.dio.get('/comercios/me/productos');
    final list = response.data as List;
    return list.map((e) => ProductoRead.fromJson(e)).toList();
  }

  Future<ProductoRead> crearProducto({
    required String nombre,
    String? descripcion,
    required double precio,
    String? imagenUrl,
    String? categoriaId,
  }) async {
    final response = await _dioClient.dio.post(
      '/comercios/me/productos',
      data: {
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen_url': imagenUrl,
        'categoria_id': categoriaId,
        'disponible': true,
      },
    );
    return ProductoRead.fromJson(response.data);
  }
}
