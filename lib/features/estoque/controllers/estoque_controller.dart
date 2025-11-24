import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/repositories/estoque_repository.dart';

final estoqueRepositoryProvider = Provider<EstoqueRepository>((ref) {
  return EstoqueRepository(); 
});

final estoqueListProvider = StreamProvider<List<Estoque>>((ref) {
  final repository = ref.watch(estoqueRepositoryProvider);
  return repository.getEstoquesStream();
});

final estoqueControllerProvider = AsyncNotifierProvider<EstoqueController, void>(() {
  return EstoqueController();
});

class EstoqueController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> addEstoque(String titulo) async {
    if (titulo.isEmpty) return;
    state = const AsyncLoading();

    final repository = ref.read(estoqueRepositoryProvider);
    state = await AsyncValue.guard(() => repository.saveEstoque(titulo));
  }

  Future<void> updateEstoque() async {
    
  }

  Future<void> removeEstoque(String id) async {
    final repository = ref.read(estoqueRepositoryProvider);
    await repository.removeEstoque(id);
  }
}