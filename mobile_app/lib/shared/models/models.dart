class UserRead {
  final String id;
  final String email;
  final String nombre;
  final String? telefono;
  final String rol;
  final bool activo;
  final bool aprobado;

  UserRead({
    required this.id,
    required this.email,
    required this.nombre,
    this.telefono,
    required this.rol,
    required this.activo,
    required this.aprobado,
  });

  factory UserRead.fromJson(Map<String, dynamic> json) {
    return UserRead(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      rol: json['rol']?.toString() ?? 'CLIENTE',
      activo: json['activo'] ?? true,
      aprobado: json['aprobado'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'nombre': nombre,
        'telefono': telefono,
        'rol': rol,
        'activo': activo,
        'aprobado': aprobado,
      };
}

class CategoriaRead {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? icono;

  CategoriaRead({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
  });

  factory CategoriaRead.fromJson(Map<String, dynamic> json) {
    return CategoriaRead(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      icono: json['icono']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'icono': icono,
      };
}

class ProductoRead {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final bool disponible;
  final String comercioId;
  final String? categoriaId;
  final String? imagenUrl;

  ProductoRead({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.disponible,
    required this.comercioId,
    this.categoriaId,
    this.imagenUrl,
  });

  factory ProductoRead.fromJson(Map<String, dynamic> json) {
    return ProductoRead(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      precio: (json['precio'] as num?)?.toDouble() ?? 0.0,
      disponible: json['disponible'] ?? true,
      comercioId: json['comercio_id']?.toString() ?? '',
      categoriaId: json['categoria_id']?.toString(),
      imagenUrl: json['imagen_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'disponible': disponible,
        'comercio_id': comercioId,
        'categoria_id': categoriaId,
        'imagen_url': imagenUrl,
      };
}

class ComercioRead {
  final String id;
  final String nombre;
  final String? descripcion;
  final String direccion;
  final String? telefono;
  final String? categoriaId;
  final bool abierto;
  final String? imagenUrl;
  final List<ProductoRead> productos;

  ComercioRead({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.direccion,
    this.telefono,
    this.categoriaId,
    required this.abierto,
    this.imagenUrl,
    required this.productos,
  });

  factory ComercioRead.fromJson(Map<String, dynamic> json) {
    var prodsList = json['productos'] as List? ?? [];
    List<ProductoRead> prods = prodsList.map((e) => ProductoRead.fromJson(e)).toList();

    return ComercioRead(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      direccion: json['direccion']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      categoriaId: json['categoria_id']?.toString(),
      abierto: json['abierto'] ?? true,
      imagenUrl: json['imagen_url']?.toString(),
      productos: prods,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'direccion': direccion,
        'telefono': telefono,
        'categoria_id': categoriaId,
        'abierto': abierto,
        'imagen_url': imagenUrl,
        'productos': productos.map((e) => e.toJson()).toList(),
      };
}

class DireccionRead {
  final String id;
  final String clienteId;
  final String alias;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final String? referencias;

  DireccionRead({
    required this.id,
    required this.clienteId,
    required this.alias,
    required this.direccion,
    this.latitud,
    this.longitud,
    this.referencias,
  });

  factory DireccionRead.fromJson(Map<String, dynamic> json) {
    return DireccionRead(
      id: json['id']?.toString() ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      alias: json['alias']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      referencias: json['referencias']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente_id': clienteId,
        'alias': alias,
        'direccion': direccion,
        'latitud': latitud,
        'longitud': longitud,
        'referencias': referencias,
      };
}

class DetallePedidoRead {
  final String id;
  final String pedidoId;
  final String productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  final ProductoRead? producto;

  DetallePedidoRead({
    required this.id,
    required this.pedidoId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
    this.producto,
  });

  factory DetallePedidoRead.fromJson(Map<String, dynamic> json) {
    return DetallePedidoRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      productoId: json['producto_id']?.toString() ?? '',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
      precioUnitario: (json['precio_unitario'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      producto: json['producto'] != null ? ProductoRead.fromJson(json['producto']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'producto_id': productoId,
        'cantidad': cantidad,
        'precio_unitario': precioUnitario,
        'subtotal': subtotal,
        'producto': producto?.toJson(),
      };
}

class PedidoRead {
  final String id;
  final String clienteId;
  final String comercioId;
  final String? repartidorId;
  final String direccionId;
  final String estado;
  final double subtotal;
  final double costoEnvio;
  final double total;
  final String metodoPago;
  final String? cuponCodigo;
  final String fechaCreacion;
  final List<DetallePedidoRead> detalles;
  final ComercioRead? comercio;
  final DireccionRead? direccion;

  PedidoRead({
    required this.id,
    required this.clienteId,
    required this.comercioId,
    this.repartidorId,
    required this.direccionId,
    required this.estado,
    required this.subtotal,
    required this.costoEnvio,
    required this.total,
    required this.metodoPago,
    this.cuponCodigo,
    required this.fechaCreacion,
    required this.detalles,
    this.comercio,
    this.direccion,
  });

  factory PedidoRead.fromJson(Map<String, dynamic> json) {
    var detList = json['detalles'] as List? ?? [];
    List<DetallePedidoRead> detalles = detList.map((e) => DetallePedidoRead.fromJson(e)).toList();

    return PedidoRead(
      id: json['id']?.toString() ?? '',
      clienteId: json['cliente_id']?.toString() ?? '',
      comercioId: json['comercio_id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString(),
      direccionId: json['direccion_id']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'CREADO',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      costoEnvio: (json['costo_envio'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      metodoPago: json['metodo_pago']?.toString() ?? 'TARJETA',
      cuponCodigo: json['cupon_codigo']?.toString(),
      fechaCreacion: json['fecha_creacion']?.toString() ?? '',
      detalles: detalles,
      comercio: json['comercio'] != null ? ComercioRead.fromJson(json['comercio']) : null,
      direccion: json['direccion'] != null ? DireccionRead.fromJson(json['direccion']) : null,
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
        'total': total,
        'metodo_pago': metodoPago,
        'cupon_codigo': cuponCodigo,
        'fecha_creacion': fechaCreacion,
        'detalles': detalles.map((e) => e.toJson()).toList(),
        'comercio': comercio?.toJson(),
        'direccion': direccion?.toJson(),
      };
}

class EntregaRead {
  final String id;
  final String pedidoId;
  final String? repartidorId;
  final String estado;
  final double? latitudActual;
  final double? longitudActual;
  final PedidoRead? pedido;

  EntregaRead({
    required this.id,
    required this.pedidoId,
    this.repartidorId,
    required this.estado,
    this.latitudActual,
    this.longitudActual,
    this.pedido,
  });

  factory EntregaRead.fromJson(Map<String, dynamic> json) {
    return EntregaRead(
      id: json['id']?.toString() ?? '',
      pedidoId: json['pedido_id']?.toString() ?? '',
      repartidorId: json['repartidor_id']?.toString(),
      estado: json['estado']?.toString() ?? 'PENDIENTE',
      latitudActual: (json['latitud_actual'] as num?)?.toDouble(),
      longitudActual: (json['longitud_actual'] as num?)?.toDouble(),
      pedido: json['pedido'] != null ? PedidoRead.fromJson(json['pedido']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pedido_id': pedidoId,
        'repartidor_id': repartidorId,
        'estado': estado,
        'latitud_actual': latitudActual,
        'longitud_actual': longitudActual,
        'pedido': pedido?.toJson(),
      };
}
