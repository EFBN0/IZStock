import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/features/estoque/controllers/estoque_controller.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/controllers/search_mercadoria_controller.dart';

final mercadoriasAgrupadasProvider =
    Provider<AsyncValue<Map<String, List<Mercadoria>>>>((ref) {
      final estoquesAsync = ref.watch(estoqueListProvider);
      final mercadoriasAsync = ref.watch(mercadoriasFiltradasProvider);

      if (estoquesAsync.isLoading || mercadoriasAsync.isLoading) {
        return const AsyncLoading();
      }

      if (estoquesAsync.hasError) {
        return AsyncError(estoquesAsync.error!, estoquesAsync.stackTrace!);
      }
      if (mercadoriasAsync.hasError) {
        return AsyncError(
          mercadoriasAsync.error!,
          mercadoriasAsync.stackTrace!,
        );
      }

      final estoques = estoquesAsync.value ?? [];
      final mercadorias = mercadoriasAsync.value ?? [];

      if (mercadorias.isEmpty) {
        return const AsyncData({});
      }

      final estoqueMap = {for (var e in estoques) e.id: e.titulo};
      final Map<String, List<Mercadoria>> estoqueMercadoriaListMap = {};

      for (var mercadoria in mercadorias) {
        final nomeEstoque = estoqueMap[mercadoria.estoqueId] ?? 'Outros';

        if (!estoqueMercadoriaListMap.containsKey(nomeEstoque)) {
          estoqueMercadoriaListMap[nomeEstoque] = [];
        }
        estoqueMercadoriaListMap[nomeEstoque]!.add(mercadoria);
      }

      return AsyncData(estoqueMercadoriaListMap);
    });
