import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izstock/core/repositories/base_repository.dart';
import 'package:izstock/features/vendas/models/venda.dart';

class VendaRepository extends BaseRepository {
  VendaRepository({super.firestore, super.auth});

  Future<void> registrarVenda(Venda venda) async {
    final batch = firestore.batch();
    final vendaRef = firestore
        .collection('users')
        .doc(userId)
        .collection('vendas')
        .doc(venda.id);

    batch.set(vendaRef, venda.copyWith(userId: userId).toFirestore());

    for (final item in venda.itens) {
      final mercadoriaRef = firestore
          .collection('users')
          .doc(userId)
          .collection('estoques')
          .doc(item.estoqueId)
          .collection('mercadorias')
          .doc(item.mercadoriaId);

      final estoqueRef = firestore
          .collection('users')
          .doc(userId)
          .collection('estoques')
          .doc(item.estoqueId);

      batch.update(mercadoriaRef, {
        'quantidade': FieldValue.increment(-item.quantidade),
      });

      batch.update(estoqueRef, {
        'quantidadeItens': FieldValue.increment(-item.quantidade),
      });
    }

    final String dateId = "${venda.data.year}-${venda.data.month.toString().padLeft(2, '0')}-${venda.data.day.toString().padLeft(2, '0')}";

    final resumoRef = firestore
        .collection('users')
        .doc(userId)
        .collection('resumos')
        .doc(dateId);

    batch.set(resumoRef, {
      'data': dateId,
      'faturamento': FieldValue.increment(venda.valorVendaTotal),
      'lucro': FieldValue.increment(venda.lucroTotal),
      'qtdVendas': FieldValue.increment(1),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}
