import 'package:flutter_riverpod/legacy.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';

class MercadoriasNotifier extends StateNotifier<List<MercadoriaVenda>> {
  MercadoriasNotifier() : super([]);

  void addMercadoriaToCarrinho(Mercadoria mercadoria) {
    final mercadoriaAlreadyAdded = state
        .where((m) => m.mercadoriaId == mercadoria.id)
        .isNotEmpty;

    if (mercadoriaAlreadyAdded) {
      final index = state.indexWhere((m) => m.mercadoriaId == mercadoria.id);
      state[index] = state[index].copyWith(
        quantidade: state[index].quantidade + 1,
      );
    } else {
      var newMercadoriaVenda = MercadoriaVenda.fromMercadoria(mercadoria);
      state = [...state, newMercadoriaVenda];
    }
  }

  void incrementMercadoria(MercadoriaVenda mercadoria) {
    final index = state.indexWhere(
      (m) => m.mercadoriaId == mercadoria.mercadoriaId,
    );
    if (index < 0) {
      return;
    }

    final novaMercadoria = mercadoria.copyWith(
      quantidade: state[index].quantidade + 1,
    );

    state = [
      for (final m in state)
        if (m.mercadoriaId == mercadoria.mercadoriaId) novaMercadoria else m,
    ];
  }

  void decrementMercadoria(MercadoriaVenda mercadoria) {
    final index = state.indexWhere(
      (m) => m.mercadoriaId == mercadoria.mercadoriaId,
    );
    if (index < 0) {
      return;
    }

    if (state[index].quantidade == 1) {
      removeMercadoria(mercadoria);
      return;
    }

    final novaMercadoria = mercadoria.copyWith(
      quantidade: state[index].quantidade - 1,
    );

    state = [
      for (final m in state)
        if (m.mercadoriaId == mercadoria.mercadoriaId) novaMercadoria else m,
    ];
  }

  void removeMercadoria(MercadoriaVenda mercadoria) {
    state = state
          .where((m) => m.mercadoriaId != mercadoria.mercadoriaId)
          .toList();
  }

  double getValorTotal() {
    if (state.isEmpty) {
      return 0.0;
    }

    double valorTotal = 0.0;
    for (final mercadoria in state) {
      valorTotal += mercadoria.valor * mercadoria.quantidade;
    }

    return valorTotal;
  }
}

final carrinhoProvider =
    StateNotifierProvider<MercadoriasNotifier, List<MercadoriaVenda>>((ref) {
      return MercadoriasNotifier();
    });
