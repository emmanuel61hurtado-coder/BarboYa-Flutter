import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/widgets/app_widgets.dart';
import 'package:mobile_app/shared/providers/app_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'cliente@barboya.com');
  final _passwordController = TextEditingController(text: 'Password123*');
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (user.rol == 'COMERCIO') {
        context.go('/merchant');
      } else if (user.rol == 'REPARTIDOR') {
        context.go('/delivery');
      } else if (user.rol == 'ADMIN') {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('ApiException: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailForgotController = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ingresa tu correo para recibir las instrucciones de restablecimiento.',
              style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailForgotController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailForgotController.text.trim();
              if (email.isNotEmpty && email.contains('@')) {
                Navigator.pop(ctx);
                try {
                  await ref.read(authServiceProvider).forgotPassword(email);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Correo de recuperación enviado con éxito.')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLime,
              foregroundColor: AppTheme.darkCharcoal,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppTheme.darkCharcoal,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.bolt,
                        size: 40,
                        color: AppTheme.primaryLime,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Hola de nuevo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.darkCharcoal,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Inicia sesión para continuar en BarboYa Superapp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppTheme.errorRed, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined, color: AppTheme.darkCharcoal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock_outline, color: AppTheme.darkCharcoal),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: AppTheme.darkCharcoal, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Iniciar Sesión',
                    isLoading: _isLoading,
                    onPressed: _login,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes cuenta? ',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text(
                          'Regístrate aquí',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkCharcoal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
