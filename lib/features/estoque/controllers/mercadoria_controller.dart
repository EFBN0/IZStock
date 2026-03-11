import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';
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

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredMercadoriaListProvider = Provider.autoDispose.family<AsyncValue<List<Mercadoria>>, String>((ref, estoqueId) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final mercadoriasAsync = ref.watch(mercadoriaListProvider(estoqueId));

  return mercadoriasAsync.whenData((mercadorias) {
    var filtered = mercadorias;

    if (query.isNotEmpty) {
      filtered = mercadorias.where((m) => m.titulo.toLowerCase().contains(query)).toList();
    }

    final sortedList = List<Mercadoria>.from(filtered);
    sortedList.sort((a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()));
    
    return sortedList;
  });
});

final mercadoriaControllerProvider = AsyncNotifierProvider<MercadoriaController, void>(() {
  return MercadoriaController();
});

class MercadoriaController extends AsyncNotifier<void> {
  final _uuid = const Uuid();

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
      userId: '',
      codigo:  _uuid.v4(),
      titulo: titulo,
      descricao: '',
      valorVenda: valorVenda,
      valorCusto: valorCusto,
      quantidade: quantidade,
    );

    state = await AsyncValue.guard(() => repository.addMercadoria(estoqueId, novaMercadoria));
  }

  Future<void> removeMercadoria(String estoqueId, Mercadoria mercadoria) async {
    state = const AsyncLoading();
    final repository = ref.read(mercadoriaRepositoryProvider);
    state = await AsyncValue.guard(() => repository.removeMercadoria(estoqueId, mercadoria));
  }
}