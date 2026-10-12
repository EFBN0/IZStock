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
    return _getMercadoriaRef(estoqueId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<List<Mercadoria>> findAllMercadorias() {
    return firestore
        .collectionGroup('mercadorias')
        .where('userId', isEqualTo: userId)
        .orderBy('titulo')
        .withConverter<Mercadoria>(
          fromFirestore: (snapshot, _) => Mercadoria.fromFirestore(snapshot),
          toFirestore: (mercadoria, _) => mercadoria.toFirestore(),
        )
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  Future<void> addMercadoria(String estoqueId, Mercadoria mercadoria) async {
    final mercadoriaRef = _getMercadoriaRef(estoqueId).doc();
    final batch = firestore.batch();
    final novaMercadoria = mercadoria.copyWith(userId: userId);
    batch.set(mercadoriaRef, novaMercadoria);
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

  Future<void> updateMercadoria(
    Mercadoria mercadoria, {
    required int quantidadeAnterior,
  }) async {
    final batch = firestore.batch();

    batch.update(_getMercadoriaRef(mercadoria.estoqueId).doc(mercadoria.id), {
      'titulo': mercadoria.titulo,
      'descricao': mercadoria.descricao,
      'valorVenda': mercadoria.valorVenda,
      'valorCusto': mercadoria.valorCusto,
      'quantidade': mercadoria.quantidade,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final diferencaQuantidade = mercadoria.quantidade - quantidadeAnterior;
    if (diferencaQuantidade != 0) {
      batch.update(
        firestore
            .collection('users')
            .doc(userId)
            .collection('estoques')
            .doc(mercadoria.estoqueId),
        {'quantidadeItens': FieldValue.increment(diferencaQuantidade)},
      );
    }

    await batch.commit();
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
