# Auditoría Técnica y Diagnóstico del Backend BarboYa

**Repositorio del Backend:** `https://github.com/emmanuel61hurtado-coder/BarboYa.git`  
**Directorio Local:** `C:\BarboYa\backend`  
**Framework y Lenguaje:** FastAPI (Python 3.13 / SQLAlchemy 2.0 Async / Pydantic v2)  
**Base de Datos:** PostgreSQL con soporte UUID nativo y motor AsyncPG  
**Servidor ASGI:** Uvicorn (`app.main:app`) en puerto `8010` (`API_V1_STR = /api/v1`)  

---

## 1. Estructura de Directorios del Backend
```
C:\BarboYa\backend\app\
├── core\
│   ├── config.py           # Configuración Pydantic BaseSettings, JWT, CORS, URLs
│   ├── exceptions.py       # DomainException y handlers globales JSON {"error": {"code", "message"}}
│   └── security.py         # Passlib Bcrypt hashing y python-jose JWT (HS256)
├── db\
│   ├── base.py             # Declarative Base SQLAlchemy
│   └── session.py          # AsyncEngine y AsyncSession get_db
├── models\
│   ├── user.py             # User (CLIENTE, REPARTIDOR, COMERCIO, ADMIN)
│   ├── comercio.py         # Comercio (asociado a user_id, con lat/lng, calificacion_promedio)
│   ├── producto.py         # Producto (asociado a comercio_id y categoria_id)
│   ├── categoria.py        # Categoria (clasificación de comidas)
│   ├── direccion.py        # Direccion (guardadas por cliente con lat/lng)
│   ├── pedido.py           # Pedido (máquina de estados estricta)
│   ├── detalle_pedido.py   # DetallePedido (líneas de pedido con producto_id)
│   ├── entrega.py          # Entrega (asignación a repartidor, tracking GPS lat/lng)
│   ├── pago.py             # Pago (EFECTIVO, TARJETA, NEQUI)
│   ├── cupon.py            # Cupon (descuentos porcentuales o fijos)
│   ├── calificacion.py     # Calificacion (1-5 estrellas, comentarios para comercio/repartidor)
│   ├── vehiculo.py         # Vehiculo (MOTO, BICI, CARRO para repartidores)
│   ├── notificacion.py     # Notificacion persistente por usuario
│   ├── viaje.py            # ViajePasajero (BarboYa Move: CARRO/MOTO, cotización y negociación)
│   └── envio.py            # EnvioPaquete (BarboYa Envíos: paquetes y mensajería urbana)
├── routes\v1\
│   ├── routers\            # Routers REST: auth, users, comercios, categorias, productos,
│   │                       # direcciones, pedidos, pagos, entregas, calificaciones,
│   │                       # vehiculos, cupones, notificaciones, admin, reportes, viajes, envios
│   └── ws\                 # WebSockets: pedidos_ws.py (/pedidos/{id}), tracking_ws.py (/tracking/{id})
├── schemas\                # Esquemas de entrada y salida Pydantic
└── services\
    └── state_machine.py    # Validación estricta de transiciones de estado de pedidos
```

---

## 2. Autenticación y Autorización (RBAC)
- **Mecanismo:** Bearer Token JWT en cabecera `Authorization: Bearer <token>`.
- **Expiración:** Token de acceso de 15 minutos; refresco configurable.
- **Roles:**
  - `CLIENTE`: Puede registrarse directamente con estado `ACTIVO`. Puede gestionar direcciones, solicitar pedidos, viajes, envíos, pagar y calificar.
  - `REPARTIDOR`: Registro público con estado inicial `PENDIENTE` (requiere aprobación por un `ADMIN` vía `/admin/usuarios/{id}/aprobar`). Registra vehículo, acepta entregas disponibles y transmite ubicación GPS.
  - `COMERCIO`: Registro público con estado inicial `PENDIENTE`. Crea local, publica productos y procesa pedidos en cocina.
  - `ADMIN`: Administra usuarios (aprobar/bloquear), cupones y visualiza reportes globales.
- **Restricción de Seguridad:** Si un `REPARTIDOR` o `COMERCIO` intenta operar antes de ser aprobado, el servidor rechaza con código `PENDING_APPROVAL` (403 Forbidden).

---

## 3. Formato Oficial de Errores
El backend implementa `register_exception_handlers` con el siguiente formato unificado:
```json
{
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Credenciales inválidas"
  }
}
```
En errores de validación estándar de FastAPI (HTTP 422 Unprocessable Entity), la respuesta es:
```json
{
  "detail": [
    {
      "loc": ["body", "email"],
      "msg": "value is not a valid email address",
      "type": "value_error"
    }
  ]
}
```
El cliente HTTP de Flutter (Dio) debe capturar ambos formatos y transformarlos en excepciones legibles de dominio.

---

## 4. Máquinas de Estados del Servidor

### Pedidos de Comida (`EstadoPedido`)
```
CREADO ──────► ACEPTADO ──────► PREPARANDO ──────► LISTO ──────► EN_CAMINO ──────► ENTREGADO
   │              │                │
   └──────────────┴────────────────┴─────────────► CANCELADO
```
*Restricción:* Transiciones validadas en `state_machine.py`. Solo transiciones válidas son aceptadas por `PATCH /api/v1/pedidos/{id}/estado`.

### BarboYa Move — Viajes de Pasajeros (`EstadoViaje`)
- `SOLICITADO` (cliente envía solicitud y precio propuesto).
- `OFERTADO` (conductor contraoferta precio).
- `ACEPTADO` (ambas partes acuerdan).
- `EN_CURSO` (viaje en trayecto).
- `FINALIZADO` (código de confirmación de 4 dígitos validado).
- `CANCELADO`.

### BarboYa Envíos — Paquetería (`EstadoEnvio`)
- `SOLICITADO` -> `RECOGIDO` -> `EN_CAMINO` -> `ENTREGADO` / `CANCELADO`.
- Código de entrega de seguridad generado automáticamente por el servidor.

---

## 5. WebSockets en Tiempo Real
- **Canal de Estado de Pedidos:** `/api/v1/ws/pedidos/{pedido_id}?token=<jwt>`
  Emite `{ "estado": "PREPARANDO" }` en tiempo real a clientes y restaurantes suscritos.
- **Canal de Telemetría GPS:** `/api/v1/ws/tracking/{pedido_id}?token=<jwt>`
  Repartidor conectado transmite `{ "lat": 4.6097, "lng": -74.0817 }` y los clientes suscritos reciben la posición en vivo sin polling continuo.

---

## 6. Diagnóstico del Entorno y Puertos
- **Host Local:** `127.0.0.1:8010` (definido en `C:\BarboYa\run.py`).
- **Android Emulator:** `10.0.2.2:8010`.
- **Producción / Coolify:** Configurable mediante variable de compilación `--dart-define=API_URL=https://api.tudominio.com`.
