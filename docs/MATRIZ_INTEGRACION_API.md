# Matriz de Integración de API — BarboYa Superapp

Esta matriz detalla los contratos verificados contra el backend FastAPI (`C:\BarboYa\backend`), especificando el método, la ruta, los parámetros, el cuerpo, la respuesta y la clasificación de integración.

| Funcionalidad | Endpoint Real | Método HTTP | Parámetros / Headers | Cuerpo (Request) | Respuesta Esperada | Rol Autorizado | Pantalla Flutter | Clasificación |
|---|---|---|---|---|---|---|---|---|
| **Registro de Usuarios** | `/api/v1/auth/register` | `POST` | Ninguno | `{"email", "password", "nombre", "telefono", "rol"}` | `UserRead` (201) | Público (`CLIENTE`, `REPARTIDOR`, `COMERCIO`) | `RegisterScreen` | `IMPLEMENTABLE` |
| **Inicio de Sesión** | `/api/v1/auth/login` | `POST` | Ninguno | `{"email", "password"}` | `{"access_token", "token_type"}` | Público | `LoginScreen` | `IMPLEMENTABLE` |
| **Cierre de Sesión** | `/api/v1/auth/logout` | `POST` | Bearer Token | Ninguno | `{"message": "Sesión cerrada..."}` | Cualquier rol | `ProfileScreen` | `IMPLEMENTABLE` |
| **Recuperación de Clave** | `/api/v1/auth/forgot-password` | `POST` | Ninguno | `{"email"}` | `{"message": "..."}` | Público | `ForgotPasswordModal` | `IMPLEMENTABLE` |
| **Restablecer Clave** | `/api/v1/auth/reset-password` | `POST` | Ninguno | `{"token", "new_password"}` | `{"message": "..."}` | Público | `ResetPasswordModal` | `IMPLEMENTABLE` |
| **Perfil Propio** | `/api/v1/users/me` | `GET` | Bearer Token | Ninguno | `UserRead` | Cualquier rol | `ProfileScreen` | `IMPLEMENTABLE` |
| **Actualizar Perfil** | `/api/v1/users/me` | `PATCH` | Bearer Token | `{"nombre?", "telefono?"}` | `UserRead` | Cualquier rol | `EditProfileDialog` | `IMPLEMENTABLE` |
| **Listar Comercios Activos** | `/api/v1/comercios` | `GET` | Ninguno | Ninguno | `List<ComercioRead>` | Público / Autenticado | `CustomerHomeScreen` | `IMPLEMENTABLE` |
| **Detalle de Comercio** | `/api/v1/comercios/{id}` | `GET` | `id: UUID` | Ninguno | `ComercioRead` (con productos) | Cualquier rol | `CommerceDetailScreen` | `IMPLEMENTABLE` |
| **Crear Comercio** | `/api/v1/comercios` | `POST` | Bearer Token | `ComercioCreate` | `ComercioRead` (201) | `COMERCIO` | `MerchantSetupScreen` | `IMPLEMENTABLE` |
| **Mis Productos (Comercio)** | `/api/v1/comercios/me/productos` | `GET` | Bearer Token | Ninguno | `List<ProductoRead>` | `COMERCIO` | `MerchantDashboardScreen` | `IMPLEMENTABLE` |
| **Crear Producto** | `/api/v1/comercios/me/productos` | `POST` | Bearer Token | `ProductoCreate` | `ProductoRead` (201) | `COMERCIO` | `AddProductModal` | `IMPLEMENTABLE` |
| **Listar Categorías** | `/api/v1/categorias` | `GET` | Ninguno | Ninguno | `List<CategoriaRead>` | Cualquier rol | `CustomerHomeScreen` | `IMPLEMENTABLE` |
| **Listar Mis Direcciones** | `/api/v1/direcciones` | `GET` | Bearer Token | Ninguno | `List<DireccionRead>` | `CLIENTE` | `AddressSelectorModal` | `IMPLEMENTABLE` |
| **Crear Dirección** | `/api/v1/direcciones` | `POST` | Bearer Token | `DireccionCreate` | `DireccionRead` (201) | `CLIENTE` | `AddAddressModal` | `IMPLEMENTABLE` |
| **Crear Pedido de Comida** | `/api/v1/pedidos` | `POST` | Bearer Token | `PedidoCreate` | `PedidoRead` (201) | `CLIENTE` | `CartScreen` | `IMPLEMENTABLE` |
| **Listar Pedidos** | `/api/v1/pedidos` | `GET` | Bearer Token | Ninguno | `List<PedidoRead>` | Roles filtrados por backend | `OrdersHistoryScreen` / `MerchantDashboard` | `IMPLEMENTABLE` |
| **Detalle de Pedido** | `/api/v1/pedidos/{id}` | `GET` | Bearer Token, `id: UUID` | Ninguno | `PedidoRead` | Autorizado | `OrderDetailScreen` | `IMPLEMENTABLE` |
| **Actualizar Estado Pedido** | `/api/v1/pedidos/{id}/estado` | `PATCH` | Bearer Token, `id: UUID` | `{"estado": EstadoPedido}` | `PedidoRead` | Autorizado | `OrderDetailScreen` / `MerchantDashboard` | `IMPLEMENTABLE` |
| **Entregas Disponibles** | `/api/v1/entregas/disponibles` | `GET` | Bearer Token | Ninguno | `List<PedidoRead>` (con estado LISTO) | `REPARTIDOR` (Aprobado) | `DeliveryDashboardScreen` | `IMPLEMENTABLE` |
| **Aceptar Entrega (Lock)** | `/api/v1/entregas/{pedido_id}/aceptar` | `POST` | Bearer Token, `pedido_id` | Ninguno | `EntregaRead` | `REPARTIDOR` | `DeliveryDashboardScreen` | `IMPLEMENTABLE` |
| **Actualizar Estado Entrega** | `/api/v1/entregas/{id}/estado` | `PATCH` | Bearer Token, `id: UUID` | `{"estado": EstadoEntrega}` | `EntregaRead` | `REPARTIDOR` | `ActiveDeliveryScreen` | `IMPLEMENTABLE` |
| **Actualizar GPS Entrega** | `/api/v1/entregas/{id}/ubicacion` | `PATCH` | Bearer Token, `id: UUID` | `{"lat", "lng"}` | `EntregaRead` | `REPARTIDOR` | Telemetría background | `IMPLEMENTABLE` |
| **Mi Vehículo** | `/api/v1/vehiculos/me` | `GET` | Bearer Token | Ninguno | `VehiculoRead` | `REPARTIDOR` | `DeliveryDashboardScreen` | `IMPLEMENTABLE` |
| **Registrar Vehículo** | `/api/v1/vehiculos` | `POST` | Bearer Token | `VehiculoCreate` | `VehiculoRead` (201) | `REPARTIDOR` | `RegisterVehicleModal` | `IMPLEMENTABLE` |
| **Validar Cupón** | `/api/v1/cupones/validar` | `POST` | Bearer Token | `{"codigo", "subtotal"}` | `CuponRead` | `CLIENTE` | `CartScreen` | `IMPLEMENTABLE` |
| **Procesar Pago** | `/api/v1/pagos` | `POST` | Bearer Token, `Idempotency-Key` opcional | `{"pedido_id", "metodo", "monto"}` | `PagoRead` (201) | `CLIENTE` | `PaymentScreen` | `IMPLEMENTABLE` |
| **Calificar Pedido** | `/api/v1/calificaciones` | `POST` | Bearer Token | `CalificacionCreate` | `CalificacionRead` (201) | `CLIENTE` | `RatingDialog` | `IMPLEMENTABLE` |
| **Notificaciones de Usuario** | `/api/v1/notificaciones` | `GET` | Bearer Token | Ninguno | `List<NotificacionRead>` | Cualquier rol | `NotificationsScreen` | `IMPLEMENTABLE` |
| **Solicitar Viaje (Move)** | `/api/v1/viajes` | `POST` | Bearer Token | `ViajeCreate` | `ViajeResponse` (201) | `CLIENTE` | `RequestRideScreen` | `IMPLEMENTABLE` |
| **Listar Viajes** | `/api/v1/viajes` | `GET` | Bearer Token | Ninguno | `List<ViajeResponse>` | Cliente / Conductor | `RidesHistoryScreen` / `DriverDashboard` | `IMPLEMENTABLE` |
| **Detalle Viaje** | `/api/v1/viajes/{id}` | `GET` | Bearer Token, `id: UUID` | Ninguno | `ViajeResponse` | Involucrado | `RideDetailScreen` | `IMPLEMENTABLE` |
| **Actualizar Viaje / Oferta** | `/api/v1/viajes/{id}` | `PATCH` | Bearer Token, `id: UUID` | `ViajeUpdate` | `ViajeResponse` | Conductor / Cliente | `RideTrackingScreen` | `IMPLEMENTABLE` |
| **Crear Envío (Paquete)** | `/api/v1/envios` | `POST` | Bearer Token | `EnvioCreate` | `EnvioResponse` (201) | `CLIENTE` | `CreateShipmentScreen` | `IMPLEMENTABLE` |
| **Listar Envíos** | `/api/v1/envios` | `GET` | Bearer Token | Ninguno | `List<EnvioResponse>` | Remitente / Repartidor | `ShipmentsHistoryScreen` | `IMPLEMENTABLE` |
| **Detalle Envío** | `/api/v1/envios/{id}` | `GET` | Bearer Token, `id: UUID` | Ninguno | `EnvioResponse` | Involucrado | `ShipmentDetailScreen` | `IMPLEMENTABLE` |
| **Actualizar Envío** | `/api/v1/envios/{id}` | `PATCH` | Bearer Token, `id: UUID` | `EnvioUpdate` | `EnvioResponse` | Repartidor | `ShipmentTrackingScreen` | `IMPLEMENTABLE` |
| **Admin: Listar Usuarios** | `/api/v1/admin/usuarios` | `GET` | Bearer Token | Ninguno | `List<UserRead>` | `ADMIN` | `AdminDashboardScreen` | `IMPLEMENTABLE` |
| **Admin: Aprobar Usuario** | `/api/v1/admin/usuarios/{id}/aprobar` | `PATCH` | Bearer Token, `id: UUID` | Ninguno | `UserRead` | `ADMIN` | `AdminDashboardScreen` | `IMPLEMENTABLE` |
| **Admin: Bloquear Usuario** | `/api/v1/admin/usuarios/{id}/bloquear` | `PATCH` | Bearer Token, `id: UUID` | Ninguno | `UserRead` | `ADMIN` | `AdminDashboardScreen` | `IMPLEMENTABLE` |
| **Admin: Reporte Ventas** | `/api/v1/reportes/ventas` | `GET` | Bearer Token | Ninguno | `{"total_ventas", "pedidos_completados", "periodo"}` | `ADMIN`, `COMERCIO` | `AdminDashboardScreen` | `IMPLEMENTABLE` |
| **WebSocket Pedidos** | `/api/v1/ws/pedidos/{id}` | `WS` | `token: QueryParam` | Escucha eventos JSON | `{"estado": "..."}` | Cliente / Comercio / Repartidor | `OrderDetailScreen` | `IMPLEMENTABLE` |
| **WebSocket Telemetría GPS**| `/api/v1/ws/tracking/{id}` | `WS` | `token: QueryParam` | Repartidor envía `{lat, lng}` | Reenvío a clientes `{lat, lng}` | Repartidor / Cliente / Admin | `LiveMapTrackingScreen` | `IMPLEMENTABLE` |
