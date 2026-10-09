# Configuración por Entornos — BarboYa Superapp

La aplicación móvil y web de BarboYa soporta inyección estática de variables en tiempo de compilación a través de `--dart-define`, garantizando que ningún secreto ni URL fija quede incrustada en el código fuente.

---

## 1. Variables Disponibles en `AppConfig`

| Variable | Tipo | Valor por Defecto | Propósito |
|---|---|---|---|
| `API_URL` | `String` | `http://localhost:8010/api/v1` | URL base para peticiones HTTP vía Dio |
| `WS_URL` | `String` | `ws://localhost:8010/api/v1/ws` | URL base para WebSockets (tracking y pedidos) |
| `ENVIRONMENT` | `String` | `development` | Indicador de entorno (`development`, `staging`, `production`) |

---

## 2. Perfiles de Entorno

### 2.1 Desarrollo (Development)
- **API REST:** `http://localhost:8010/api/v1` (o `http://10.0.2.2:8010/api/v1` en emulador Android)
- **WebSocket:** `ws://localhost:8010/api/v1/ws`
- **Comando de compilación:**
```bash
flutter build web --dart-define=ENVIRONMENT=development --dart-define=API_URL=http://localhost:8010/api/v1 --dart-define=WS_URL=ws://localhost:8010/api/v1/ws
```

### 2.2 Staging / Pruebas
- **API REST:** `https://staging-api.barboya.com/api/v1`
- **WebSocket:** `wss://staging-api.barboya.com/api/v1/ws`
- **Comando de compilación:**
```bash
flutter build web --release --dart-define=ENVIRONMENT=staging --dart-define=API_URL=https://staging-api.barboya.com/api/v1 --dart-define=WS_URL=wss://staging-api.barboya.com/api/v1/ws
```

### 2.3 Producción (Production)
- **API REST:** `https://api.barboya.com/api/v1`
- **WebSocket:** `wss://api.barboya.com/api/v1/ws`
- **Comando de compilación:**
```bash
flutter build web --release --dart-define=ENVIRONMENT=production --dart-define=API_URL=https://api.barboya.com/api/v1 --dart-define=WS_URL=wss://api.barboya.com/api/v1/ws
```

---

## 3. Consideraciones de Seguridad
1. **Sin secretos en el cliente:** Dado que el código cliente (JavaScript / APK / AAB) puede ser desensamblado, nunca se deben pasar claves privadas o contraseñas por `--dart-define`.
2. **Tokens JWT seguros:** Los tokens de acceso se almacenan exclusivamente en `flutter_secure_storage` (en web se utilizan mecanismos cifrados del navegador y en Android Keystore).
3. **Validación HTTPS/WSS:** En entornos de staging y producción es obligatorio el uso de certificados TLS válidos (Let's Encrypt o Cloudflare).
