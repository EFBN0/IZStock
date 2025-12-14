import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/commons/services/location_service.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/controllers/carrinho/carrinho_state.dart';
import 'package:izstock/features/vendas/models/meio_pagamento_enum.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';
import 'package:izstock/features/vendas/models/venda.dart';
import 'package:izstock/features/vendas/repositories/venda_repository.dart';
import 'package:uuid/uuid.dart';

final vendaRepositoryProvider = Provider((ref) => VendaRepository());

final carrinhoControllerProvider =
    AsyncNotifierProvider<CarrinhoController, CarrinhoState>(() {
      return CarrinhoController();
    });

class CarrinhoController extends AsyncNotifier<CarrinhoState> {
  @override
  CarrinhoState build() => const CarrinhoState();

  void addMercadoriaToCarrinho(Mercadoria mercadoria) {
    final currentList = state.value!.mercadoriaList;

    final mercadoriaAlreadyAdded = currentList
        .where((m) => m.mercadoriaId == mercadoria.id)
        .isNotEmpty;

    if (mercadoriaAlreadyAdded) {
      final index = currentList.indexWhere(
        (m) => m.mercadoriaId == mercadoria.id,
      );

      final newList = List<MercadoriaVenda>.from(currentList);

      newList[index] = newList[index].copyWith(
        quantidade: newList[index].quantidade + 1,
      );

      state = AsyncData(
        state.value!.copyWith(
          mercadoriaList: newList,
          status: CarrinhoStatus.itemAdicionado,
        ),
      );
    } else {
      final newMercadoriaVenda = MercadoriaVenda.fromMercadoria(mercadoria);

      state = AsyncData(
        state.value!.copyWith(
          mercadoriaList: [...currentList, newMercadoriaVenda],
          status: CarrinhoStatus.itemAdicionado,
        ),
      );
    }
  }

  void incrementMercadoria(MercadoriaVenda item) {
    final currentList = state.value!.mercadoriaList;
    final newList = [
      for (final m in currentList)
        if (m.mercadoriaId == item.mercadoriaId)
          m.copyWith(quantidade: m.quantidade + 1)
        else
          m,
    ];

    state = AsyncData(
      state.value!.copyWith(
        mercadoriaList: newList,
        status: CarrinhoStatus.ocioso,
      ),
    );
  }

  void decrementMercadoria(MercadoriaVenda item) {
    final currentList = state.value!.mercadoriaList;
    final index = currentList.indexWhere(
      (m) => m.mercadoriaId == item.mercadoriaId,
    );

    if (index < 0) return;

    if (currentList[index].quantidade == 1) {
      removeMercadoria(item);
      return;
    }

    final newList = [
      for (final m in currentList)
        if (m.mercadoriaId == item.mercadoriaId)
          m.copyWith(quantidade: m.quantidade - 1)
        else
          m,
    ];

    state = AsyncData(
      state.value!.copyWith(
        mercadoriaList: newList,
        status: CarrinhoStatus.ocioso,
      ),
    );
  }

  void removeMercadoria(MercadoriaVenda item) {
    final currentList = state.value!.mercadoriaList;

    final newList = currentList
        .where((m) => m.mercadoriaId != item.mercadoriaId)
        .toList();

    state = AsyncData(
      state.value!.copyWith(
        mercadoriaList: newList,
        status: CarrinhoStatus.itemRemovido,
      ),
    );
  }

  double get valorTotal {
    final currentList = state.value!.mercadoriaList;
    if (currentList.isEmpty) return 0.0;

    return currentList.fold(
      0.0,
      (total, item) => total + (item.valorVenda * item.quantidade),
    );
  }

  Future<void> finalizarVenda({
    required MeioPagamento meioPagamento
  }) async {
    state = const AsyncLoading();

    double? lat;
    double? long;
    
    try {
      final position = await LocationService.getLocalizacaoAtual();
      lat = position.latitude;
      long = position.longitude;
    } catch (e) {
      print('Erro ao obter localização: $e');
    }

    final currentList = state.value!.mercadoriaList;
    if (currentList.isEmpty) return;

    final vendaRepository = ref.read(vendaRepositoryProvider);

    double valorTotal = 0;
    double custoTotal = 0;

    for (var item in currentList) {
      valorTotal += item.valorVenda * item.quantidade;
      custoTotal += item.valorCusto * item.quantidade;
    }

    final lucroTotal = valorTotal - custoTotal;

    final novaVenda = Venda(
      id: const Uuid().v4(),
      userId: '',
      data: DateTime.now(),
      valorVendaTotal: valorTotal,
      valorCustoTotal: custoTotal,
      lucroTotal: lucroTotal,
      meioPagamento: meioPagamento,
      itens: currentList,
      latitude: lat,
      longitude: long,
    );

    state = await AsyncValue.guard(() async {
      await vendaRepository.registrarVenda(novaVenda);
      return state.value!.copyWith(
        mercadoriaList: [],
        status: CarrinhoStatus.vendaFinalizada,
      );
    });
  }
}
