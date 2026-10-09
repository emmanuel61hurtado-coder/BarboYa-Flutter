import 'dart:async';
import 'dart:convert';
import 'package:mobile_app/core/config/app_config.dart';
import 'package:mobile_app/core/security/secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Stream<Map<String, dynamic>> listenToPedido(String pedidoId) async* {
    final token = await SecureStorage.getAccessToken() ?? '';
    final url = '${AppConfig.wsBaseUrl}/pedidos/$pedidoId?token=$token';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await for (final message in _channel!.stream) {
        try {
          final data = jsonDecode(message.toString());
          if (data is Map<String, dynamic>) {
            yield data;
          }
        } catch (_) {}
      }
    } catch (_) {
      // Graceful fallback if WS server is unreachable
    }
  }

  Stream<Map<String, dynamic>> listenToTracking(String pedidoId) async* {
    final token = await SecureStorage.getAccessToken() ?? '';
    final url = '${AppConfig.wsBaseUrl}/tracking/$pedidoId?token=$token';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      await for (final message in _channel!.stream) {
        try {
          final data = jsonDecode(message.toString());
          if (data is Map<String, dynamic>) {
            yield data;
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  void sendTrackingLocation(double lat, double lng) {
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'lat': lat, 'lng': lng}));
      } catch (_) {}
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _channel = null;
  }
}
