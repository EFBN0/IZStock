import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/estoque/repositories/mercadoria_repository.dart';

final mercadoriaRepositoryProvider = Provider<MercadoriaRepository>((ref) {
  return MercadoriaRepository();
});

final mercadoriaListProvider = StreamProvider.autoDispose.family<List<Mercadoria>, String>((ref, estoqueId) {
  final repository = ref.watch(mercadoriaRepositoryProvider);
  return repository.findMercadoriasByEstoque(estoqueId);
});

final mercadoriaControllerProvider = AsyncNotifierProvider<MercadoriaController, void>(() {
  return MercadoriaController();
});

class MercadoriaController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> addMercadoria({
    required String estoqueId,
    required String titulo,
    required double valorVenda,
    required double valorCusto,
    required int quantidade,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(mercadoriaRepositoryProvider);

    final novaMercadoria = Mercadoria(
      id: '',
      estoqueId: estoqueId,
      titulo: titulo,
      descricao: '',
      valorVenda: valorVenda,
      valorCusto: valorCusto,
      quantidade: quantidade,
    );

    state = await AsyncValue.guard(() => repository.addMercadoria(estoqueId, novaMercadoria));
  }

  Future<void> excluirMercadoria(String estoqueId, String mercadoriaId) async {
    final repository = ref.read(mercadoriaRepositoryProvider);
    await repository.deletarMercadoria(estoqueId, mercadoriaId);
  }
}