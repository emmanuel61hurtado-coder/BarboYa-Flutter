# Guía de Configuración Local — BarboYa Frontend

## 1. Requisitos Previos
- **Flutter SDK:** 3.24.x o superior con Dart 3.8+.
- **Navegador Web / Emulador:** Google Chrome (para pruebas web rápidas) o Emulador Android (API 30+).
- **Backend FastAPI:** Ejecutándose en local en el puerto `8010` (según `run.py` del repositorio backend).

---

## 2. Instalación de Dependencias

1. Abre una terminal en el directorio del proyecto Flutter:
```bash
cd mobile_app
flutter pub get
```

2. Verifica la integridad estática del código:
```bash
flutter analyze
```

3. Ejecuta la suite de pruebas unitarias y de estado:
```bash
flutter test
```

---

## 3. Ejecución Local según Plataforma

### 3.1 Flutter Web (Recomendado para pruebas integrales)
Dado que el backend por defecto corre en `http://localhost:8010/api/v1`, simplemente ejecuta:
```bash
flutter run -d chrome --web-port=3000
```

Si deseas apuntar a una IP o URL específica:
```bash
flutter run -d chrome --web-port=3000 --dart-define=API_URL=http://localhost:8010/api/v1 --dart-define=WS_URL=ws://localhost:8010/api/v1/ws
```

### 3.2 Emulador Android
En el emulador oficial de Android, la máquina host corresponde a `10.0.2.2`. Por tanto, debes iniciar la app con:
```bash
flutter run -d emulator-id --dart-define=API_URL=http://10.0.2.2:8010/api/v1 --dart-define=WS_URL=ws://10.0.2.2:8010/api/v1/ws
```

### 3.3 Dispositivo Físico Android (WiFi)
Si pruebas en tu teléfono físico conectado a la misma red local:
```bash
flutter run -d <device_id> --dart-define=API_URL=http://192.168.1.X:8010/api/v1 --dart-define=WS_URL=ws://192.168.1.X:8010/api/v1/ws
```
*(Reemplaza `192.168.1.X` por la IP local de tu computadora en la red).*

---

## 4. Usuarios y Roles de Prueba en Backend
El backend FastAPI cuenta con endpoints públicos de registro (`/api/v1/auth/register`) con los siguientes roles admitidos:
- `CLIENTE`: Acceso directo e inmediato tras registro.
- `REPARTIDOR`: Requiere aprobación administrativa para poder tomar entregas.
- `COMERCIO`: Requiere aprobación administrativa para operar restaurante.
- `ADMIN`: Rol administrativo con acceso a `/admin` para gestionar usuarios y reportes.
