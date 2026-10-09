# Guía de Despliegue con Coolify — BarboYa Web

Este documento detalla los pasos para desplegar la versión web de la superapp BarboYa en un servidor administrado por **Coolify**.

---

## 1. Arquitectura de Despliegue
- **Contenedor:** Multi-stage Dockerfile (`ghcr.io/cirruslabs/flutter:stable` -> `nginx:alpine`).
- **Servidor Web:** Nginx optimizado para Single Page Application (SPA), compresión gzip y fallback de rutas para GoRouter.
- **Puerto Interno Expuesto:** `80`.
- **Health Check Endpoint:** `http://localhost/healthz`.

---

## 2. Paso a Paso en Coolify

### Paso 1: Crear Nueva Aplicación
1. Ingresa a tu panel de Coolify.
2. Selecciona tu **Project** y **Environment** (por ejemplo, `Production`).
3. Haz clic en **+ New Resource** -> **Public Repository** o **Private GitHub Repository**.
4. Ingresa la URL del repositorio:
   `https://github.com/emmanuel61hurtado-coder/BarboYa-Flutter.git`
5. Selecciona la rama principal (`main`).

### Paso 2: Configuración del Build
1. **Build Pack:** Selecciona **Dockerfile**.
2. **Dockerfile Location:** `/Dockerfile` (el archivo está ubicado en la raíz del repositorio).
3. **Ports Exposes:** `80`.

### Paso 3: Variables de Compilación (Build Arguments)
En la sección **Configuration** -> **Build Arguments**, agrega las siguientes variables para que Flutter compile apuntando a tu backend de producción:

```
API_URL=https://api.barboya.com/api/v1
WS_URL=wss://api.barboya.com/api/v1/ws
ENVIRONMENT=production
```
*(Ajusta `https://api.barboya.com` al dominio real de tu backend FastAPI en Coolify).*

### Paso 4: Configurar Dominio y SSL
1. En el campo **Domains**, introduce el FQDN para la aplicación web (por ejemplo, `https://app.barboya.com`).
2. Coolify aprovisionará automáticamente el certificado SSL mediante Let's Encrypt / Traefik.

### Paso 5: Health Check
Coolify detectará el `HEALTHCHECK` configurado en el `Dockerfile`:
- **Path:** `/healthz`
- **Interval:** 30s
- **Timeout:** 5s
- **Retries:** 3

### Paso 6: Despliegue y Validación
1. Haz clic en **Deploy**.
2. Supervisa los logs de construcción (descarga de Flutter SDK, resolución de dependencias con `flutter pub get`, y compilación release con `flutter build web`).
3. Una vez finalizado, abre tu dominio y comprueba:
   - Pantalla de bienvenida con tema Electric Lime.
   - Navegación fluida por GoRouter.
   - Conexión con los endpoints del backend en Coolify.
