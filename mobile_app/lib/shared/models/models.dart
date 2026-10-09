// Modelos y Contratos de Datos Oficiales para BarboYa Superapp
// Reflejados exactamente del backend FastAPI (app/models y app/schemas)

class UserRead {
  final String id;
  final String email;
  final String nombre;
  final String telefono;
  final String rol; // CLIENTE, REPARTIDOR, COMERCIO, ADMIN
  final String estado; // PENDIENTE, ACTIVO, BLOQUEADO
  final String? createdAt;
  final String? updatedAt;

  UserRead({
    required this.id,
    required this.email,
    required this.nombre,
    required this.telefono,
    required this.rol,
    required this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory UserRead.fromJson(Map<String, dynamic> json) {
    return UserRead(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      rol: json['rol']?.toString().toUpperCase() ?? 'CLIENTE',
      estado: json['estado']?.toString().toUpperCase() ?? 'ACTIVO',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nombre': nombre,
        'telefono': telefono,
        'rol': rol,
        'estado': estado,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class CategoriaRead {
  final String id;
  final String nombre;
  final String? icono;

  CategoriaRead({
    required this.id,
    required this.nombre,
    this.icono,
  });

  factory CategoriaRead.fromJson(Map<String, dynamic> json) {
    return CategoriaRead(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      icono: json['icono']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'icono': icono,
      };
}

class ProductoRead {
  final String id;
  final String comercioId;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String? imagenUrl;
  final bool disponible;
  final String? categoriaId;

  ProductoRead({
    required this.id,
    required this.comercioId,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.imagenUrl,
    required this.disponible,
    this.categoriaId,
  });

  factory ProductoRead.fromJson(Map<String, dynamic> json) {
    return ProductoRead(
      id: json['id']?.toString() ?? '',
      comercioId: json['comercio_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      imagenUrl: json['imagen_url']?.toString(),
      disponible: json['disponible'] ?? true,
      categoriaId: json['categoria_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'comercio_id': comercioId,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagen_url': imagenUrl,
        'disponible': disponible,
        'categoria_id': categoriaId,
      };
}

class ComercioRead {
  final String id;
  final String userId;
  final String nombre;
  final String? descripcion;
  final String? logoUrl;
  final String? bannerUrl;
  final String direccion;
  final double lat;
  final double lng;
  final bool abierto;
  final double calificacionPromedio;
  final List<ProductoRead> productos;

  ComercioRead({
    required this.id,
    required this.userId,
    required this.nombre,
    this.descripcion,
    this.logoUrl,
    this.bannerUrl,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.abierto,
    required this.calificacionPromedio,
    required this.productos,
  });

  factory ComercioRead.fromJson(Map<String, dynamic> json) {
    final prodsList = json['productos'] as List? ?? [];
    final prods = prodsList.map((e) => ProductoRead.fromJson(e)).toList();

    return ComercioRead(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      logoUrl: json['logo_url']?.toString(),
      bannerUrl: json['banner_url']?.toString(),
      direccion: json['direccion']?.toString() ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      abierto: json['abierto'] ?? true,
      calificacionPromedio: (json['calificacion_promedio'] as num?)?.toDouble() ?? 5.0,
      productos: prods,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'nombre': nombre,
        'descripcion': descripcion,
        'logo_url': logoUrl,
        'banner_url': bannerUrl,
        'direccion': direccion,
        'lat': lat,
        'lng': lng,
        'abierto': abierto,
        'calificacion_promedio': calificacionPromedio,
        'productos': productos.map((e) => e.toJson()).toList(),
      };
}

class DireccionRead {
  final String id;
  final String userId;
  final String nombre;
  final String direccion;
  final String? detalles;
  final double lat;
  final double lng;

  DireccionRead({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.direccion,
    this.detalles,
    required this.lat,
    required this.lng,
  });

  factory DireccionRead.fromJson(Map<String, dynamic> json) {
    return DireccionRead(
      id: json['id']?.toString() ?? '',
      userId: (json['user_id'] ?? json['cliente_id'])?.toString() ?? '',
      nombre: (json['nombre'] ?? json['alias'])?.toString() ?? 'Mi Ubicación',
      direccion: json['direccion']?.toString() ?? '',
      detalles: (json['detalles'] ?? json['referencias'])?.toString(),
      lat: (json['lat'] ?? json['latitud'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] ?? json['longitud'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'nombre': nombre,
        'direccion': direccion,
        'detalles': detalles,
        'lat': lat,
        'lng': lng,
      };
}

class DetallePedidoRead {
  final String id;
  final String pedidoId;
  final String productoId;
  final String? nombreProducto;
  final double precioUnitario;
  final int cantidad;
  final double subtotal;

  DetallePedidoRead({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    this.nombreProducto,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
  });

  factory DetallePedidoRead.fromJson(Map<String, dynamic> json) {
    return DetallePedidoRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      productoId: json['producto_id']?.toString() ?? '',
      nombreProducto: json['nombre_producto']?.toString(),
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'producto_id': productoId,
        'nombre_producto': nombreProducto,
        'precio_unitario': precioUnitario,
        'cantidad': cantidad,
        'subtotal': subtotal,
      };
}

class PedidoRead {
  final String id;
  final String clienteId;
  final String comercioId;
  final String? repartidorId;
  final String direccionId;
  final String estado; // CREADO, ACEPTADO, PREPARANDO, LISTO, EN_CAMINO, ENTREGADO, CANCELADO
  final double subtotal;
  final double costoEnvio;
  final double descuento;
  final double total;
  final String metodoPago;
  final String? cuponCodigo;
  final String createdAt;
  final String updatedAt;
  final List<DetallePedidoRead> detalles;

  PedidoRead({
    required this.id,
    required this.clienteId,
    required this.comercioId,
    this.repartidorId,
    required this.direccionId,
    required this.estado,
    required this.subtotal,
    required this.costoEnvio,
    required this.descuento,
    required this.total,
    required this.metodoPago,
    this.cuponCodigo,
    required this.createdAt,
    required this.updatedAt,
    required this.detalles,
  });

  factory PedidoRead.fromJson(Map<String, dynamic> json) {
    final detList = json['detalles'] as List? ?? [];
    final detalles = detList.map((e) => DetallePedidoRead.fromJson(e)).toList();

    return PedidoRead(
      id: json['id']?.toString() ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      comercioId: json['comercio_id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString(),
      direccionId: json['direccion_id']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'CREADO',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      costoEnvio: (json['costo_envio'] as num?)?.toDouble() ?? 0.0,
      descuento: (json['descuento'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      metodoPago: json['metodo_pago']?.toString() ?? 'EFECTIVO',
      cuponCodigo: json['cupon_codigo']?.toString(),
      createdAt: (json['created_at'] ?? json['fecha_creacion'])?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      detalles: detalles,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente_id': clienteId,
        'comercio_id': comercioId,
        'repartidor_id': repartidorId,
        'direccion_id': direccionId,
        'estado': estado,
        'subtotal': subtotal,
        'costo_envio': costoEnvio,
        'descuento': descuento,
        'total': total,
        'metodo_pago': metodoPago,
        'cupon_codigo': cuponCodigo,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'detalles': detalles.map((e) => e.toJson()).toList(),
      };
}

class EntregaRead {
  final String id;
  final String pedidoId;
  final String? repartidorId;
  final String estado; // ASIGNADA, EN_CAMINO, ENTREGADA, CANCELADA
  final double costoDomicilio;
  final double? latActual;
  final double? lngActual;
  final String createdAt;
  final String updatedAt;

  EntregaRead({
    required this.id,
    required this.pedidoId,
    this.repartidorId,
    required this.estado,
    required this.costoDomicilio,
    this.latActual,
    this.lngActual,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EntregaRead.fromJson(Map<String, dynamic> json) {
    return EntregaRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString(),
      estado: json['estado']?.toString() ?? 'EN_CAMINO',
      costoDomicilio: (json['costo_domicilio'] as num?)?.toDouble() ?? 5000.0,
      latActual: (json['lat_actual'] ?? json['latitud_actual'] as num?)?.toDouble(),
      lngActual: (json['lng_actual'] ?? json['longitud_actual'] as num?)?.toDouble(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'repartidor_id': repartidorId,
        'estado': estado,
        'costo_domicilio': costoDomicilio,
        'lat_actual': latActual,
        'lng_actual': lngActual,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class ViajeResponse {
  final String id;
  final String clienteId;
  final String? conductorId;
  final String tipoServicio; // carro, moto
  final String origenDireccion;
  final double origenLat;
  final double origenLng;
  final String destinoDireccion;
  final double destinoLat;
  final double destinoLng;
  final double precioEstimado;
  final double? precioPropuesto;
  final double? precioFinal;
  final String estado; // SOLICITADO, OFERTADO, ACEPTADO, EN_CURSO, FINALIZADO, CANCELADO
  final String codigoConfirmacion;
  final String createdAt;
  final String updatedAt;

  ViajeResponse({
    required this.id,
    required this.clienteId,
    this.conductorId,
    required this.tipoServicio,
    required this.origenDireccion,
    required this.origenLat,
    required this.origenLng,
    required this.destinoDireccion,
    required this.destinoLat,
    required this.destinoLng,
    required this.precioEstimado,
    this.precioPropuesto,
    this.precioFinal,
    required this.estado,
    required this.codigoConfirmacion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ViajeResponse.fromJson(Map<String, dynamic> json) {
    return ViajeResponse(
      id: json['id']?.toString() ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      conductorId: json['conductor_id']?.toString(),
      tipoServicio: json['tipo_servicio']?.toString() ?? 'carro',
      origenDireccion: json['origen_direccion']?.toString() ?? '',
      origenLat: (json['origen_lat'] as num?)?.toDouble() ?? 0.0,
      origenLng: (json['origen_lng'] as num?)?.toDouble() ?? 0.0,
      destinoDireccion: json['destino_direccion']?.toString() ?? '',
      destinoLat: (json['destino_lat'] as num?)?.toDouble() ?? 0.0,
      destinoLng: (json['destino_lng'] as num?)?.toDouble() ?? 0.0,
      precioEstimado: (json['precio_estimado'] as num?)?.toDouble() ?? 0.0,
      precioPropuesto: (json['precio_propuesto'] as num?)?.toDouble(),
      precioFinal: (json['precio_final'] as num?)?.toDouble(),
      estado: json['estado']?.toString() ?? 'SOLICITADO',
      codigoConfirmacion: json['codigo_confirmacion']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente_id': clienteId,
        'conductor_id': conductorId,
        'tipo_servicio': tipoServicio,
        'origen_direccion': origenDireccion,
        'origen_lat': origenLat,
        'origen_lng': origenLng,
        'destino_direccion': destinoDireccion,
        'destino_lat': destinoLat,
        'destino_lng': destinoLng,
        'precio_estimado': precioEstimado,
        'precio_propuesto': precioPropuesto,
        'precio_final': precioFinal,
        'estado': estado,
        'codigo_confirmacion': codigoConfirmacion,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class EnvioResponse {
  final String id;
  final String remitenteId;
  final String? repartidorId;
  final String tipoPaquete; // documento, pequeño, mediano, grande
  final String descripcion;
  final double? pesoKg;
  final String origenDireccion;
  final double origenLat;
  final double origenLng;
  final String destinoDireccion;
  final double destinoLat;
  final double destinoLng;
  final String nombreDestinatario;
  final String telefonoDestinatario;
  final String? instrucciones;
  final double costo;
  final String codigoEntrega;
  final String estado; // SOLICITADO, RECOGIDO, EN_CAMINO, ENTREGADO, CANCELADO
  final String createdAt;
  final String updatedAt;

  EnvioResponse({
    required this.id,
    required this.remitenteId,
    this.repartidorId,
    required this.tipoPaquete,
    required this.descripcion,
    this.pesoKg,
    required this.origenDireccion,
    required this.origenLat,
    required this.origenLng,
    required this.destinoDireccion,
    required this.destinoLat,
    required this.destinoLng,
    required this.nombreDestinatario,
    required this.telefonoDestinatario,
    this.instrucciones,
    required this.costo,
    required this.codigoEntrega,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnvioResponse.fromJson(Map<String, dynamic> json) {
    return EnvioResponse(
      id: json['id']?.toString() ?? '',
      remitenteId: json['remitente_id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString(),
      tipoPaquete: json['tipo_paquete']?.toString() ?? 'pequeno',
      descripcion: json['descripcion']?.toString() ?? '',
      pesoKg: (json['peso_kg'] as num?)?.toDouble(),
      origenDireccion: json['origen_direccion']?.toString() ?? '',
      origenLat: (json['origen_lat'] as num?)?.toDouble() ?? 0.0,
      origenLng: (json['origen_lng'] as num?)?.toDouble() ?? 0.0,
      destinoDireccion: json['destino_direccion']?.toString() ?? '',
      destinoLat: (json['destino_lat'] as num?)?.toDouble() ?? 0.0,
      destinoLng: (json['destino_lng'] as num?)?.toDouble() ?? 0.0,
      nombreDestinatario: json['nombre_destinatario']?.toString() ?? '',
      telefonoDestinatario: json['telefono_destinatario']?.toString() ?? '',
      instrucciones: json['instrucciones']?.toString(),
      costo: (json['costo'] as num?)?.toDouble() ?? 0.0,
      codigoEntrega: json['codigo_entrega']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'SOLICITADO',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'remitente_id': remitenteId,
        'repartidor_id': repartidorId,
        'tipo_paquete': tipoPaquete,
        'descripcion': descripcion,
        'peso_kg': pesoKg,
        'origen_direccion': origenDireccion,
        'origen_lat': origenLat,
        'origen_lng': origenLng,
        'destino_direccion': destinoDireccion,
        'destino_lat': destinoLat,
        'destino_lng': destinoLng,
        'nombre_destinatario': nombreDestinatario,
        'telefono_destinatario': telefonoDestinatario,
        'instrucciones': instrucciones,
        'costo': costo,
        'codigo_entrega': codigoEntrega,
        'estado': estado,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class VehiculoRead {
  final String id;
  final String repartidorId;
  final String tipo; // MOTO, BICI, CARRO
  final String? placa;
  final String? modelo;

  VehiculoRead({
    required this.id,
    required this.repartidorId,
    required this.tipo,
    this.placa,
    this.modelo,
  });

  factory VehiculoRead.fromJson(Map<String, dynamic> json) {
    return VehiculoRead(
      id: json['id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'MOTO',
      placa: json['placa']?.toString(),
      modelo: json['modelo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'repartidor_id': repartidorId,
        'tipo': tipo,
        'placa': placa,
        'modelo': modelo,
      };
}

class CuponRead {
  final String id;
  final String codigo;
  final double? descuentoPorcentaje;
  final double? descuentoMonto;
  final double montoMinimo;
  final bool activo;

  CuponRead({
    required this.id,
    required this.codigo,
    this.descuentoPorcentaje,
    this.descuentoMonto,
    required this.montoMinimo,
    required this.activo,
  });

  factory CuponRead.fromJson(Map<String, dynamic> json) {
    return CuponRead(
      id: json['id']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      descuentoPorcentaje: (json['descuento_porcentaje'] as num?)?.toDouble(),
      descuentoMonto: (json['descuento_monto'] as num?)?.toDouble(),
      montoMinimo: (json['monto_minimo'] as num?)?.toDouble() ?? 0.0,
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'descuento_porcentaje': descuentoPorcentaje,
        'descuento_monto': descuentoMonto,
        'monto_minimo': montoMinimo,
        'activo': activo,
      };
}

class CalificacionRead {
  final String id;
  final String pedidoId;
  final String clienteId;
  final String? comercioId;
  final String? repartidorId;
  final int puntuacion;
  final String? comentario;
  final String createdAt;

  CalificacionRead({
    required this.id,
    required this.pedidoId,
    required this.clienteId,
    this.comercioId,
    this.repartidorId,
    required this.puntuacion,
    this.comentario,
    required this.createdAt,
  });

  factory CalificacionRead.fromJson(Map<String, dynamic> json) {
    return CalificacionRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      comercioId: json['comercio_id']?.toString(),
      repartidorId: json['repartidor_id']?.toString(),
      puntuacion: (json['puntuacion'] as num?)?.toInt() ?? 5,
      comentario: json['comentario']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'cliente_id': clienteId,
        'comercio_id': comercioId,
        'repartidor_id': repartidorId,
        'puntuacion': puntuacion,
        'comentario': comentario,
        'created_at': createdAt,
      };
}

class NotificacionRead {
  final String id;
  final String userId;
  final String titulo;
  final String mensaje;
  final bool leida;
  final String createdAt;

  NotificacionRead({
    required this.id,
    required this.userId,
    required this.titulo,
    required this.mensaje,
    required this.leida,
    required this.createdAt,
  });

  factory NotificacionRead.fromJson(Map<String, dynamic> json) {
    return NotificacionRead(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      titulo: json['titulo']?.toString() ?? '',
      mensaje: json['mensaje']?.toString() ?? '',
      leida: json['leida'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'titulo': titulo,
        'mensaje': mensaje,
        'leida': leida,
        'created_at': createdAt,
      };
}

class PagoRead {
  final String id;
  final String pedidoId;
  final String metodo; // EFECTIVO, TARJETA, NEQUI
  final String estado; // PENDIENTE, COMPLETADO, FALLIDO
  final double monto;
  final String? transaccionId;
  final String createdAt;

  PagoRead({
    required this.id,
    required this.pedidoId,
    required this.metodo,
    required this.estado,
    required this.monto,
    this.transaccionId,
    required this.createdAt,
  });

  factory PagoRead.fromJson(Map<String, dynamic> json) {
    return PagoRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      metodo: json['metodo']?.toString() ?? 'EFECTIVO',
      estado: json['estado']?.toString() ?? 'COMPLETADO',
      monto: (json['monto'] as num?)?.toDouble() ?? 0.0,
      transaccionId: json['transaccion_id']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'metodo': metodo,
        'estado': estado,
        'monto': monto,
        'transaccion_id': transaccionId,
        'created_at': createdAt,
      };
}
