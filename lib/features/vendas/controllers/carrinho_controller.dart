import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';
import 'package:izstock/features/vendas/models/venda.dart';
import 'package:izstock/features/vendas/repositories/venda_repository.dart';
import 'package:uuid/uuid.dart';

final vendaRepositoryProvider = Provider((ref) => VendaRepository());

final carrinhoControllerProvider = 
    AsyncNotifierProvider<CarrinhoController, List<MercadoriaVenda>>(() {
  return CarrinhoController();
});

class CarrinhoController extends AsyncNotifier<List<MercadoriaVenda>> {

  @override
  List<MercadoriaVenda> build() => [];

  void addMercadoriaToCarrinho(Mercadoria mercadoria) {
    final currentList = state.value ?? [];

    final mercadoriaAlreadyAdded = currentList
        .where((m) => m.mercadoriaId == mercadoria.id)
        .isNotEmpty;

    if (mercadoriaAlreadyAdded) {
      final index = currentList.indexWhere((m) => m.mercadoriaId == mercadoria.id);
      
      final newList = List<MercadoriaVenda>.from(currentList);
      
      newList[index] = newList[index].copyWith(
        quantidade: newList[index].quantidade + 1,
      );
      
      state = AsyncData(newList);
      
    } else {
      final newMercadoriaVenda = MercadoriaVenda.fromMercadoria(mercadoria);

      state = AsyncData([...currentList, newMercadoriaVenda]);
    }
  }

  void incrementMercadoria(MercadoriaVenda item) {
    final currentList = state.value ?? [];
    final newList = [
      for (final m in currentList)
        if (m.mercadoriaId == item.mercadoriaId) 
          m.copyWith(quantidade: m.quantidade + 1)
        else 
          m
    ];

    state = AsyncData(newList);
  }

  void decrementMercadoria(MercadoriaVenda item) {
    final currentList = state.value ?? [];
    final index = currentList.indexWhere((m) => m.mercadoriaId == item.mercadoriaId);
    
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
          m
    ];

    state = AsyncData(newList);
  }

  void removeMercadoria(MercadoriaVenda item) {
    final currentList = state.value ?? [];
    
    final newList = currentList
        .where((m) => m.mercadoriaId != item.mercadoriaId)
        .toList();
        
    state = AsyncData(newList);
  }
  
  double get valorTotal {
    final list = state.value ?? [];
    if (list.isEmpty) return 0.0;
    
    return list.fold(0.0, (total, item) => total + (item.valorVenda * item.quantidade));
  }

  Future<void> finalizarVenda({
    double? latitude,
    double? longitude,
  }) async {
    final currentList = state.value ?? [];
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
      itens: currentList,
      latitude: latitude,
      longitude: longitude,
    );

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await vendaRepository.registrarVenda(novaVenda);
      return [];
    });
  }
}
