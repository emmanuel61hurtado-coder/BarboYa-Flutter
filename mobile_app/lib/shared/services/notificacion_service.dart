import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/shared/models/models.dart';

class NotificacionService {
  final DioClient _dioClient;

  NotificacionService(this._dioClient);

  Future<List<NotificacionRead>> getNotificaciones() async {
    final response = await _dioClient.dio.get('/notificaciones');
    final list = response.data as List;
    return list.map((e) => NotificacionRead.fromJson(e)).toList();
  }
}
