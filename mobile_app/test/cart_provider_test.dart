import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';
import 'package:mobile_app/shared/models/models.dart';

void main() {
  group('CartNotifier State Management', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    final testProductA = ProductoRead(
      id: 'p-1',
      comercioId: 'comercio-1',
      categoriaId: 'cat-1',
      nombre: 'Hamburguesa Artesanal',
      descripcion: 'Carne angus',
      precio: 18000.0,
      disponible: true,
    );

    final testProductB = ProductoRead(
      id: 'p-2',
      comercioId: 'comercio-1',
      categoriaId: 'cat-1',
      nombre: 'Papas Rústicas',
      descripcion: 'Con salsa especial',
      precio: 6000.0,
      disponible: true,
    );

    final testProductOtherComercio = ProductoRead(
      id: 'p-3',
      comercioId: 'comercio-2',
      categoriaId: 'cat-2',
      nombre: 'Pizza Personal',
      descripcion: 'Pepperoni',
      precio: 15000.0,
      disponible: true,
    );

    test('Inicia vacío', () {
      final cart = container.read(cartProvider);
      expect(cart.items.isEmpty, true);
      expect(cart.total, 0.0);
      expect(cart.comercioId, null);
    });

    test('Añadir producto calcula total y fija comercio', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProducto(testProductA, 'comercio-1');

      final state = container.read(cartProvider);
      expect(state.items.length, 1);
      expect(state.items.first.cantidad, 1);
      expect(state.total, 18000.0);
      expect(state.comercioId, 'comercio-1');
    });

    test('Incrementar cantidad suma total correctamente', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProducto(testProductA, 'comercio-1');
      notifier.addProducto(testProductA, 'comercio-1');
      notifier.addProducto(testProductB, 'comercio-1');

      final state = container.read(cartProvider);
      expect(state.items.length, 2);
      expect(state.items.first.cantidad, 2);
      expect(state.items.last.cantidad, 1);
      expect(state.total, (18000.0 * 2) + 6000.0);
    });

    test('Actualizar delta con updateQuantity', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProducto(testProductA, 'comercio-1');
      notifier.updateQuantity('p-1', 1);

      expect(container.read(cartProvider).items.first.cantidad, 2);

      notifier.updateQuantity('p-1', -1);
      expect(container.read(cartProvider).items.first.cantidad, 1);
    });

    test('Añadir de otro comercio reemplaza el carrito para preservar invariante de comercio único', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProducto(testProductA, 'comercio-1');

      // Si se añade de otro comercio, el carrito reinicia con el nuevo producto
      notifier.addProducto(testProductOtherComercio, 'comercio-2');

      final state = container.read(cartProvider);
      expect(state.comercioId, 'comercio-2');
      expect(state.items.length, 1);
      expect(state.items.first.producto.id, 'p-3');
    });

    test('Limpiar carrito restablece estado a vacío', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.addProducto(testProductA, 'comercio-1');
      expect(container.read(cartProvider).items.isNotEmpty, true);

      notifier.clear();
      expect(container.read(cartProvider).items.isEmpty, true);
      expect(container.read(cartProvider).comercioId, null);
    });
  });
}
