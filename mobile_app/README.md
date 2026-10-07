# BarboYa Mobile App (Flutter)

Aplicación móvil y multiplataforma de BarboYa construida con Flutter y Dart, integrada con el backend FastAPI.

## 🚀 Requisitos
- Flutter SDK (versión 3.47.6 o superior)
- Dart SDK (versión 3.13.5 o superior)

## 📦 Instalación y Ejecución

1. Clona el repositorio y navega a la carpeta de la aplicación móvil:
   ```bash
   cd mobile_app
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación (web, emulador o escritorio):
   ```bash
   flutter run -d chrome
   ```

## 🏗 Arquitectura
- **Clean Architecture Modular** basada en funcionalidades (`auth`, `home`, `commerces`, `cart`, `orders`, `delivery`, `merchant`, `admin`, `profile`).
- **Estado**: Flutter Riverpod.
- **Ruteo**: GoRouter.
- **Red**: Dio con interceptores y manejo robusto de errores de API.
- **Seguridad**: Flutter Secure Storage para tokens y credenciales.
