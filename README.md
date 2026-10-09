# BarboYa — Superapp Frontend (Flutter & Dart)

Frontend oficial y completo para **BarboYa**, una superapp de movilidad, marketplace gastronómico y mensajería urbana diseñada para Barbosa y su área metropolitana. Conectada e integrada al backend FastAPI existente.

---

## 🚀 Características Principales

- **🎨 Identidad Visual Exclusiva:** Paleta moderna *Electric Lime* (`#CCFF00`) y *Dark Charcoal* (`#121212`), con tipografía legible, micro-interacciones, badges de estado y diseño adaptativo.
- **🛵 BarboYa Move (Transporte de Pasajeros):** Solicitud de viajes en Carro y Moto, cotización con modelo de negociación de tarifas (estilo inDrive) y código de verificación de 4 dígitos.
- **🍔 Food Marketplace (Restaurantes y Comida):** Exploración por categorías, menú de productos por comercio, carrito con validación de comercio único, cupones de descuento y seguimiento de preparación.
- **📦 BarboYa Envíos (Mensajería Urbana):** Cotización según tipo de paquete (documento, pequeño, mediano, grande) y código de entrega seguro.
- **🧑‍💼 Multi-Rol Real (RBAC):**
  - **Cliente:** Viajes, comida, envíos, direcciones guardadas, pagos y calificaciones de 1 a 5 estrellas.
  - **Repartidor / Conductor:** Dashboard de entregas con aceptación atómica (`SKIP LOCKED`), registro de vehículo y telemetría de ubicación.
  - **Comercio:** Control de pedidos en cocina (`PREPARANDO` -> `LISTO`) y catálogo.
  - **Administrador:** Aprobación de cuentas pendientes, bloqueo y métricas de ventas.
- **⚡ Tiempo Real:** Canales WebSocket para seguimiento de estados y tracking GPS.
- **🔒 Seguridad:** Almacenamiento seguro de JWT mediante `flutter_secure_storage`, interceptor Dio con manejo uniforme de códigos HTTP (`401`, `403`, `422`, etc.).

---

## 📁 Estructura del Repositorio

```
BarboYa-Flutter/
├── docs/                           # Documentación técnica completa
│   ├── ANALISIS_BACKEND.md         # Diagnóstico de FastAPI y contratos Pydantic
│   ├── MATRIZ_INTEGRACION_API.md   # Matriz detallada de endpoints y clasificación
│   ├── ESTADO_FUNCIONALIDADES.md   # Estado de cobertura real
│   ├── ARQUITECTURA_FRONTEND.md    # Diseño modular y diagramas
│   ├── CONFIGURACION_LOCAL.md      # Guía de ejecución en web y emuladores
│   ├── CONFIGURACION_ENTORNOS.md   # Parámetros y perfiles de entorno
│   └── DEPLOY_COOLIFY.md           # Despliegue en contenedor Docker en Coolify
├── mobile_app/                     # Código fuente de la aplicación Flutter
│   ├── lib/
│   │   ├── core/                   # Config, red (Dio), router (GoRouter), storage, theme
│   │   ├── features/               # Módulos: auth, home, rides, commerces, cart, etc.
│   │   └── shared/                 # Modelos, proveedores Riverpod y servicios de API
│   └── test/                       # Suite de pruebas unitarias, de estado y widgets
├── Dockerfile                      # Imagen multi-stage para producción web
├── nginx.conf                      # Servidor estático con fallback SPA y health check
├── .env.example                    # Plantilla de variables de entorno
└── README.md                       # Documento principal
```

---

## 🛠️ Requisitos e Instalación

### Requisitos
- Flutter SDK `>= 3.24.0`
- Dart SDK `>= 3.8.0`
- Backend FastAPI corriendo en `http://localhost:8010/api/v1`

### Instalación
```bash
cd mobile_app
flutter pub get
```

### Análisis Estático y Pruebas
```bash
# Análisis estático de Dart
flutter analyze

# Pruebas automatizadas (Modelos, Carrito, Widgets)
flutter test
```

### Ejecución Local
```bash
# En el navegador (Google Chrome)
flutter run -d chrome --web-port=3000

# En emulador Android
flutter run -d emulator-id --dart-define=API_URL=http://10.0.2.2:8010/api/v1
```

---

## 🌐 Compilación y Despliegue

### Compilar para Web
```bash
flutter build web --release \
  --dart-define=API_URL=https://api.barboya.com/api/v1 \
  --dart-define=WS_URL=wss://api.barboya.com/api/v1/ws \
  --dart-define=ENVIRONMENT=production
```

### Despliegue en Coolify
Sigue la guía detallada en [docs/DEPLOY_COOLIFY.md](docs/DEPLOY_COOLIFY.md). La aplicación incluye un `Dockerfile` optimizado y `nginx.conf` con soporte para rutas HTML5 de GoRouter y endpoint de salud `/healthz`.
