import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izstock/core/repositories/base_repository.dart';
import 'package:izstock/features/vendas/models/venda.dart';

class VendaRepository extends BaseRepository {
  VendaRepository({super.firestore, super.auth});

  CollectionReference<Venda> get _vendasRef {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('vendas')
        .withConverter<Venda>(
          fromFirestore: (snapshot, _) => Venda.fromFirestore(snapshot),
          toFirestore: (venda, _) => venda.toFirestore(),
        );
  }

  Stream<List<Venda>> getVendasStreamByDateRange(Timestamp startDate, Timestamp endDate) {
    return _vendasRef
        .where('data', isGreaterThanOrEqualTo: startDate)
        .where('data', isLessThanOrEqualTo: endDate)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  Future<void> registrarVenda(Venda venda) async {
    final userRef = firestore.collection('users').doc(userId);
    final vendaRef = userRef.collection('vendas').doc(venda.id);

    final String dateId =
        "${venda.data.year}-${venda.data.month.toString().padLeft(2, '0')}-${venda.data.day.toString().padLeft(2, '0')}";
    final resumoRef = userRef.collection('resumos').doc(dateId);

    await firestore.runTransaction((transaction) async {
      final mercadoriaRefs = [
        for (final item in venda.itens)
          userRef
              .collection('estoques')
              .doc(item.estoqueId)
              .collection('mercadorias')
              .doc(item.mercadoriaId),
      ];

      final snapshots = [
        for (final ref in mercadoriaRefs) await transaction.get(ref),
      ];

      for (var i = 0; i < venda.itens.length; i++) {
        final item = venda.itens[i];
        final disponivel =
            (snapshots[i].data()?['quantidade'] as num?)?.toInt() ?? 0;

        if (!snapshots[i].exists || disponivel < item.quantidade) {
          throw EstoqueInsuficienteException(
            titulo: item.titulo,
            disponivel: disponivel,
            solicitado: item.quantidade,
          );
        }
      }

      transaction.set(vendaRef, venda.copyWith(userId: userId).toFirestore());

      final baixaPorEstoque = <String, int>{};

      for (var i = 0; i < venda.itens.length; i++) {
        final item = venda.itens[i];

        transaction.update(mercadoriaRefs[i], {
          'quantidade': FieldValue.increment(-item.quantidade),
        });

        baixaPorEstoque[item.estoqueId] =
            (baixaPorEstoque[item.estoqueId] ?? 0) + item.quantidade;
      }

      baixaPorEstoque.forEach((estoqueId, quantidade) {
        transaction.update(userRef.collection('estoques').doc(estoqueId), {
          'quantidadeItens': FieldValue.increment(-quantidade),
        });
      });

      transaction.set(resumoRef, {
        'data': dateId,
        'faturamento': FieldValue.increment(venda.valorVendaTotal),
        'lucro': FieldValue.increment(venda.lucroTotal),
        'capitalGiro': FieldValue.increment(venda.valorVendaTotal - venda.lucroTotal),
        'qtdVendas': FieldValue.increment(1),
      }, SetOptions(merge: true));
    });
  }
}

class EstoqueInsuficienteException implements Exception {
  const EstoqueInsuficienteException({
    required this.titulo,
    required this.disponivel,
    required this.solicitado,
  });

  final String titulo;
  final int disponivel;
  final int solicitado;

  @override
  String toString() {
    if (disponivel <= 0) {
      return '"$titulo" está esgotado. Remova-o do carrinho para continuar.';
    }
    return 'Estoque insuficiente de "$titulo": $disponivel disponíveis, $solicitado no carrinho.';
  }
}
