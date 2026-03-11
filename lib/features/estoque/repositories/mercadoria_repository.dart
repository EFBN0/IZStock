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
      final lista = snapshot.docs.map((doc) => doc.data()).toList();
      lista.sort((a, b) {
        final dateA = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      return lista;
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
