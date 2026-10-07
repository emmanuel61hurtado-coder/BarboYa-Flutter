import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
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

  factory UserRead.fromJson(Map<String, dynamic> json) => _$UserReadFromJson(json);
  Map<String, dynamic> toJson() => _$UserReadToJson(this);
}

@JsonSerializable()
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

  factory CategoriaRead.fromJson(Map<String, dynamic> json) => _$CategoriaReadFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriaReadToJson(this);
}

@JsonSerializable()
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

  factory ProductoRead.fromJson(Map<String, dynamic> json) => _$ProductoReadFromJson(json);
  Map<String, dynamic> toJson() => _$ProductoReadToJson(this);
}

@JsonSerializable()
class ComercioRead {
  final String id;
  final String nombre;
  final String? descripcion;
  final String direccion;
  final String? telefono;
  final String? categoriaId;
  final bool abierto;
  final String? imagenUrl;
  @JsonKey(defaultValue: [])
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

  factory ComercioRead.fromJson(Map<String, dynamic> json) => _$ComercioReadFromJson(json);
  Map<String, dynamic> toJson() => _$ComercioReadToJson(this);
}

@JsonSerializable()
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

  factory DireccionRead.fromJson(Map<String, dynamic> json) => _$DireccionReadFromJson(json);
  Map<String, dynamic> toJson() => _$DireccionReadToJson(this);
}

@JsonSerializable()
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

  factory DetallePedidoRead.fromJson(Map<String, dynamic> json) => _$DetallePedidoReadFromJson(json);
  Map<String, dynamic> toJson() => _$DetallePedidoReadToJson(this);
}

@JsonSerializable()
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
  @JsonKey(defaultValue: [])
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

  factory PedidoRead.fromJson(Map<String, dynamic> json) => _$PedidoReadFromJson(json);
  Map<String, dynamic> toJson() => _$PedidoReadToJson(this);
}

@JsonSerializable()
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

  factory EntregaRead.fromJson(Map<String, dynamic> json) => _$EntregaReadFromJson(json);
  Map<String, dynamic> toJson() => _$EntregaReadToJson(this);
}
