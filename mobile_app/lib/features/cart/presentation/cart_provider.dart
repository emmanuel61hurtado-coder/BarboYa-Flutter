import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/shared/models/models.dart';

class CartItem {
  final ProductoRead producto;
  int cantidad;

  CartItem({required this.producto, required this.cantidad});

  double get subtotal => producto.precio * cantidad;
}

class CartState {
  final String? comercioId;
  final List<CartItem> items;
  final String? direccionId;
  final String metodoPago;

  CartState({
    this.comercioId,
    this.items = const [],
    this.direccionId,
    this.metodoPago = 'TARJETA',
  });

  double get total => items.fold(0, (sum, item) => sum + item.subtotal);

  CartState copyWith({
    String? comercioId,
    List<CartItem>? items,
    String? direccionId,
    String? metodoPago,
  }) {
    return CartState(
      comercioId: comercioId ?? this.comercioId,
      items: items ?? this.items,
      direccionId: direccionId ?? this.direccionId,
      metodoPago: metodoPago ?? this.metodoPago,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addProducto(ProductoRead producto, String comercioId) {
    if (state.comercioId != null && state.comercioId != comercioId) {
      // Clear cart if adding from a different commerce
      state = CartState(comercioId: comercioId, items: [CartItem(producto: producto, cantidad: 1)]);
      return;
    }

    final existingIndex = state.items.indexWhere((i) => i.producto.id == producto.id);
    List<CartItem> updatedItems = List.from(state.items);

    if (existingIndex >= 0) {
      updatedItems[existingIndex].cantidad += 1;
    } else {
      updatedItems.add(CartItem(producto: producto, cantidad: 1));
    }

    state = state.copyWith(comercioId: comercioId, items: updatedItems);
  }

  void removeProducto(String productoId) {
    final updatedItems = state.items.where((i) => i.producto.id != productoId).toList();
    if (updatedItems.isEmpty) {
      state = CartState();
    } else {
      state = state.copyWith(items: updatedItems);
    }
  }

  void updateQuantity(String productoId, int delta) {
    final updatedItems = state.items.map((item) {
      if (item.producto.id == productoId) {
        final newQty = item.cantidad + delta;
        return CartItem(producto: item.producto, cantidad: newQty > 0 ? newQty : 1);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void setDireccion(String direccionId) {
    state = state.copyWith(direccionId: direccionId);
  }

  void setMetodoPago(String metodo) {
    state = state.copyWith(metodoPago: metodo);
  }

  void clear() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
