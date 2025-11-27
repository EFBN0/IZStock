import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izstock/core/repositories/base_repository.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class MercadoriaRepository extends BaseRepository {
  MercadoriaRepository({super.firestore, super.auth});

  CollectionReference<Mercadoria> _getMercadoriaRef(String estoqueId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('estoques')
        .doc(estoqueId)
        .collection('mercadorias')
        .withConverter<Mercadoria>(
          fromFirestore: (snapshot, _) => Mercadoria.fromFirestore(snapshot),
          toFirestore: (mercadoria, _) => mercadoria.toFirestore(),
        );
  }

  Stream<List<Mercadoria>> findMercadoriasByEstoque(String estoqueId) {
    return _getMercadoriaRef(estoqueId).orderBy('titulo').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<List<Mercadoria>> findMercadoriasByText(String text) async {
    if (text.isEmpty) return [];

    final query = firestore
        .collectionGroup('mercadorias')
        .where('titulo', isGreaterThanOrEqualTo: text)
        .where('titulo', isLessThan: '$text\uf8ff')
        .withConverter<Mercadoria>(
          fromFirestore: (snapshot, _) => Mercadoria.fromFirestore(snapshot),
          toFirestore: (mercadoria, _) => mercadoria.toFirestore(),
        );

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addMercadoria(String estoqueId, Mercadoria mercadoria) async {
    final mercadoriaRef = _getMercadoriaRef(estoqueId).doc();
    final batch = firestore.batch();
    batch.set(mercadoriaRef, mercadoria);
    batch.update(
      firestore
          .collection('users')
          .doc(userId)
          .collection('estoques')
          .doc(estoqueId),
      {'quantidadeItens': FieldValue.increment(mercadoria.quantidade)},
    );

    await batch.commit();
  }

  Future<void> updateMercadoria(Mercadoria mercadoria) async {
    await _getMercadoriaRef(
      mercadoria.estoqueId,
    ).doc(mercadoria.id).set(mercadoria);
  }

  Future<void> updateQuantidadeMercadoria(
    String estoqueId,
    String mercadoriaId,
    int novaQtd,
  ) async {
    await _getMercadoriaRef(
      estoqueId,
    ).doc(mercadoriaId).update({'quantidade': novaQtd});
  }

  Future<void> removeMercadoria(String estoqueId, Mercadoria mercadoria) async {
    final mercadoriaRef = _getMercadoriaRef(estoqueId).doc(mercadoria.id);
    final estoqueRef = firestore
        .collection('users')
        .doc(userId)
        .collection('estoques')
        .doc(estoqueId);

    final batch = firestore.batch();
    batch.delete(mercadoriaRef);
    batch.update(estoqueRef, {
      'quantidadeItens': FieldValue.increment(-mercadoria.quantidade),
    });

    await batch.commit();
  }
}
