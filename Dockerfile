# ==========================================
# Etapa 1: Compilación de Flutter Web
# ==========================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Argumentos de compilación para URLs públicas
ARG API_URL=http://localhost:8010/api/v1
ARG WS_URL=ws://localhost:8010/api/v1/ws
ARG ENVIRONMENT=production

# Copiar manifiesto de dependencias y descargar paquetes
COPY mobile_app/pubspec.yaml mobile_app/pubspec.lock ./mobile_app/
WORKDIR /app/mobile_app
RUN flutter pub get

# Copiar código fuente y compilar bundle web de producción
COPY mobile_app/ ./
RUN flutter build web --release \
    --dart-define=API_URL=${API_URL} \
    --dart-define=WS_URL=${WS_URL} \
    --dart-define=ENVIRONMENT=${ENVIRONMENT}

# ==========================================
# Etapa 2: Servidor Web Estático Nginx
# ==========================================
FROM nginx:alpine

# Copiar configuración con soporte SPA HTML5 y health check
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar artefactos web compilados
COPY --from=build /app/mobile_app/build/web /usr/share/nginx/html

# Puerto HTTP estándar
EXPOSE 80

# Health check para Coolify
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/healthz || exit 1

CMD ["nginx", "-g", "daemon off;"]
