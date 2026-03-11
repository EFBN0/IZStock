import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/estoque/repositories/mercadoria_repository.dart';

final termoBuscaProvider = StateProvider<String>((ref) => '');

final mercadoriaRepositoryProvider = Provider((ref) => MercadoriaRepository());

final mercadoriasProvider = StreamProvider<List<Mercadoria>>((ref) {
  final repository = ref.watch(mercadoriaRepositoryProvider);
  return repository.findAllMercadorias();
});

final mercadoriasFiltradasProvider = Provider<AsyncValue<List<Mercadoria>>>((ref) {
  final termo = ref.watch(termoBuscaProvider).toLowerCase();
  final allMercadorias = ref.watch(mercadoriasProvider);

  return allMercadorias.whenData((mercadorias) {
    if (termo.isEmpty) {
      return mercadorias.where((m) => m.quantidade > 0).toList();
    }

    return mercadorias
        .where((mercadoria) {
          final titulo = mercadoria.titulo.toLowerCase();
          return titulo.contains(termo);
        })
        .where((m) => m.quantidade > 0)
        .toList();
  });
});
