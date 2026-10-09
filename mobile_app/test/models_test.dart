import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/shared/models/models.dart';

void main() {
  group('Modelos y Serialización JSON', () {
    test('UserRead fromJson y toJson', () {
      final json = {
        'id': 'usr-123',
        'email': 'usuario@barboya.com',
        'nombre': 'Carlos Barbosa',
        'telefono': '3001234567',
        'rol': 'CLIENTE',
        'estado': 'ACTIVO',
        'created_at': '2026-10-09T12:00:00Z',
        'updated_at': '2026-10-09T12:00:00Z',
      };

      final user = UserRead.fromJson(json);

      expect(user.id, 'usr-123');
      expect(user.email, 'usuario@barboya.com');
      expect(user.nombre, 'Carlos Barbosa');
      expect(user.telefono, '3001234567');
      expect(user.rol, 'CLIENTE');
      expect(user.estado, 'ACTIVO');

      final serialized = user.toJson();
      expect(serialized['id'], 'usr-123');
      expect(serialized['email'], 'usuario@barboya.com');
      expect(serialized['rol'], 'CLIENTE');
    });

    test('ViajeResponse fromJson cálculo de negociación', () {
      final json = {
        'id': 'v-999',
        'cliente_id': 'c-1',
        'tipo_servicio': 'moto',
        'estado': 'SOLICITADO',
        'origen_direccion': 'Parque Principal',
        'origen_lat': 5.932,
        'origen_lng': -73.616,
        'destino_direccion': 'Vereda El Centro',
        'destino_lat': 5.940,
        'destino_lng': -73.620,
        'precio_estimado': 8000.0,
        'precio_propuesto': 7500.0,
        'codigo_confirmacion': '4912',
      };

      final viaje = ViajeResponse.fromJson(json);

      expect(viaje.id, 'v-999');
      expect(viaje.tipoServicio, 'moto');
      expect(viaje.estado, 'SOLICITADO');
      expect(viaje.precioEstimado, 8000.0);
      expect(viaje.precioPropuesto, 7500.0);
      expect(viaje.codigoConfirmacion, '4912');
    });

    test('EnvioResponse fromJson tipos de paquete', () {
      final json = {
        'id': 'env-555',
        'cliente_id': 'c-2',
        'tipo_paquete': 'documento',
        'descripcion': 'Contrato firmado',
        'peso_kg': 0.5,
        'origen_direccion': 'Calle 10 # 5-20',
        'origen_lat': 5.93,
        'origen_lng': -73.61,
        'destino_direccion': 'Carrera 8 # 12-40',
        'destino_lat': 5.95,
        'destino_lng': -73.63,
        'nombre_destinatario': 'María Gómez',
        'telefono_destinatario': '3109876543',
        'estado': 'CREADO',
        'costo': 5000.0,
        'codigo_entrega': '7788',
      };

      final envio = EnvioResponse.fromJson(json);

      expect(envio.id, 'env-555');
      expect(envio.tipoPaquete, 'documento');
      expect(envio.nombreDestinatario, 'María Gómez');
      expect(envio.costo, 5000.0);
      expect(envio.codigoEntrega, '7788');
    });

    test('ComercioRead y ProductoRead', () {
      final json = {
        'id': 'com-1',
        'user_id': 'u-rest',
        'nombre': 'Arepas y Parrilla',
        'descripcion': 'Comida típica colombiana',
        'direccion': 'Calle 5 # 3-10',
        'telefono': '3112223344',
        'lat': 5.935,
        'lng': -73.618,
        'abierto': true,
        'calificacion_promedio': 4.8,
        'productos': [
          {
            'id': 'prod-1',
            'comercio_id': 'com-1',
            'categoria_id': 'cat-1',
            'nombre': 'Arepa de Chócolo',
            'descripcion': 'Con queso campesino',
            'precio': 9500.0,
            'disponible': true,
          }
        ],
      };

      final comercio = ComercioRead.fromJson(json);

      expect(comercio.id, 'com-1');
      expect(comercio.nombre, 'Arepas y Parrilla');
      expect(comercio.calificacionPromedio, 4.8);
      expect(comercio.productos.length, 1);
      expect(comercio.productos.first.nombre, 'Arepa de Chócolo');
      expect(comercio.productos.first.precio, 9500.0);
    });

    test('CuponRead validación de porcentajes y montos', () {
      final json = {
        'id': 'cup-1',
        'codigo': 'BARBOYA50',
        'descuento_porcentaje': 20.0,
        'descuento_monto': null,
        'monto_minimo': 20000.0,
        'usos_maximos': 50,
        'usos_actuales': 12,
        'activo': true,
      };

      final cupon = CuponRead.fromJson(json);

      expect(cupon.codigo, 'BARBOYA50');
      expect(cupon.descuentoPorcentaje, 20.0);
      expect(cupon.montoMinimo, 20000.0);
      expect(cupon.activo, true);
    });
  });
}
