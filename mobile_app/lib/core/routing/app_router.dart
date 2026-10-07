import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/security/secure_storage.dart';

// Placeholder screens for routing setup
import 'package:mobile_app/features/auth/presentation/login_screen.dart';
import 'package:mobile_app/features/auth/presentation/register_screen.dart';
import 'package:mobile_app/features/auth/presentation/splash_screen.dart';
import 'package:mobile_app/features/home/presentation/customer_home_screen.dart';
import 'package:mobile_app/features/commerces/presentation/commerce_detail_screen.dart';
import 'package:mobile_app/features/cart/presentation/cart_screen.dart';
import 'package:mobile_app/features/orders/presentation/order_detail_screen.dart';
import 'package:mobile_app/features/orders/presentation/orders_history_screen.dart';
import 'package:mobile_app/features/delivery/presentation/delivery_dashboard_screen.dart';
import 'package:mobile_app/features/merchant/presentation/merchant_dashboard_screen.dart';
import 'package:mobile_app/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:mobile_app/features/profile/presentation/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/commerce/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CommerceDetailScreen(commerceId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersHistoryScreen(),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/delivery',
        builder: (context, state) => const DeliveryDashboardScreen(),
      ),
      GoRoute(
        path: '/merchant',
        builder: (context, state) => const MerchantDashboardScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
