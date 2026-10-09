# Estado Real de Funcionalidades — BarboYa Superapp

Documento de auditoría y cobertura que clasifica cada funcionalidad según los contratos reales del backend:

## 1. Módulo de Identidad y Seguridad
- **Registro y Login con JWT:** `IMPLEMENTABLE` (100% soportado).
- **Control de Acceso Basado en Roles (RBAC):** `IMPLEMENTABLE` (CLIENTE, REPARTIDOR, COMERCIO, ADMIN).
- **Recuperación de Contraseña:** `IMPLEMENTABLE` (endpoints `/forgot-password` y `/reset-password` disponibles).
- **Aprobación de Cuentas por Admin:** `IMPLEMENTABLE` (Repartidores y comercios requieren aprobación).
- **Almacenamiento Seguro de Tokens:** `IMPLEMENTABLE` (Integrado con `flutter_secure_storage`).

## 2. Módulo de Transporte de Pasajeros (BarboYa Move)
- **Solicitud de viajes en Carro y Moto:** `IMPLEMENTABLE` (Soportado en `/api/v1/viajes`).
- **Negociación y propuesta de precios (Bidding/inDrive):** `IMPLEMENTABLE` (Campos `precio_estimado`, `precio_propuesto` y `precio_final`).
- **Código de confirmación de viaje:** `IMPLEMENTABLE` (Generado por el backend con 4 dígitos para seguridad).
- **Seguimiento y cambio de estados:** `IMPLEMENTABLE` (SOLICITADO, OFERTADO, ACEPTADO, EN_CURSO, FINALIZADO, CANCELADO).

## 3. Módulo de Envíos y Mensajería (BarboYa Envíos)
- **Cotización y solicitud de paquetes:** `IMPLEMENTABLE` (Soportado en `/api/v1/envios`).
- **Tipos de paquete:** `IMPLEMENTABLE` (documento, pequeno, mediano, grande).
- **Código de entrega:** `IMPLEMENTABLE` (Código único de verificación al entregar).
- **Historial y seguimiento:** `IMPLEMENTABLE`.

## 4. Módulo de Comida y Restaurantes (Food Marketplace)
- **Directorio de comercios abiertos:** `IMPLEMENTABLE` (`/api/v1/comercios`).
- **Catálogo de productos por comercio y categorías:** `IMPLEMENTABLE` (`/api/v1/productos`, `/api/v1/categorias`).
- **Regla de comercio único por carrito:** `IMPLEMENTABLE` (Gestionado en capa de presentación y validado por backend).
- **Cupones de descuento:** `IMPLEMENTABLE` (`/api/v1/cupones/validar` con control de monto mínimo y usos máximos).
- **Cálculo de envíos e impuestos:** `IMPLEMENTABLE` (El backend calcula subtotal + costo_envio - descuento de forma estricta).

## 5. Módulo de Conductores y Repartidores
- **Dashboard de entregas listas:** `IMPLEMENTABLE` (`/api/v1/entregas/disponibles`).
- **Aceptación atómica con bloqueo:** `IMPLEMENTABLE` (`SELECT FOR UPDATE SKIP LOCKED` en `/api/v1/entregas/{pedido_id}/aceptar`).
- **Registro y consulta de vehículo:** `IMPLEMENTABLE` (`/api/v1/vehiculos`).
- **Transmisión de ubicación GPS:** `IMPLEMENTABLE` (`PATCH /entregas/{id}/ubicacion`).

## 6. Módulo para Comercios (Restaurantes)
- **Recepción de pedidos entrantes:** `IMPLEMENTABLE` (`GET /api/v1/pedidos` filtrado por `comercio_id`).
- **Transición controlada de cocina:** `IMPLEMENTABLE` (`CREADO` -> `ACEPTADO` -> `PREPARANDO` -> `LISTO`).
- **Gestión de productos y disponibilidad:** `IMPLEMENTABLE` (`GET / POST /comercios/me/productos`).

## 7. Mapas, Telemetría y Tiempo Real
- **WebSockets de estado de pedidos:** `IMPLEMENTABLE` (`/api/v1/ws/pedidos/{id}`).
- **WebSockets de telemetría GPS repartidor:** `IMPLEMENTABLE` (`/api/v1/ws/tracking/{id}`).
- **Integración de Mapas y Rutas:** `REQUIERE_CONFIGURACION` (Requiere API Key de Google Maps / Mapbox o utiliza visor OSM desacoplado).
- **Permisos GPS Geolocator:** `IMPLEMENTABLE`.

## 8. Pagos y Pasarelas
- **Registro de pagos de pedidos:** `IMPLEMENTABLE` (`POST /api/v1/pagos` para EFECTIVO, NEQUI, TARJETA).
- **Pasarela de pago bancario real (Wompi/MercadoPago):** `REQUIERE_CONFIGURACION` (El backend procesa transacciones mock; requiere llaves de producción para pasarela bancaria externa).

## 9. Historial, Calificaciones y Notificaciones
- **Historial completo de pedidos, viajes y envíos:** `IMPLEMENTABLE`.
- **Calificaciones de 1 a 5 estrellas con recálculo de promedio:** `IMPLEMENTABLE` (`POST /api/v1/calificaciones`).
- **Notificaciones en la aplicación:** `IMPLEMENTABLE` (`GET /api/v1/notificaciones`).
- **Notificaciones Push FCM:** `REQUIERE_CONFIGURACION` (Requiere `google-services.json` y credenciales Firebase).

## 10. Panel Administrativo
- **Lista y filtrado de usuarios:** `IMPLEMENTABLE` (`/api/v1/admin/usuarios`).
- **Aprobar / Bloquear cuentas:** `IMPLEMENTABLE` (`/api/v1/admin/usuarios/{id}/aprobar`, `/bloquear`).
- **Reporte consolidado de ventas:** `IMPLEMENTABLE` (`/api/v1/reportes/ventas`).
