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
    return _getMercadoriaRef(estoqueId)
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  Future<List<Mercadoria>> buscarMercadorias(String termoBusca) async {
    if (termoBusca.isEmpty) return [];
    
    final query = firestore.collectionGroup('mercadorias')
        .where('titulo', isGreaterThanOrEqualTo: termoBusca)
        .where('titulo', isLessThan: '$termoBusca\uf8ff')
        .withConverter<Mercadoria>(
          fromFirestore: (snapshot, _) => Mercadoria.fromFirestore(snapshot),
          toFirestore: (mercadoria, _) => mercadoria.toFirestore(),
        );

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addMercadoria(String estoqueId, Mercadoria mercadoria) async {
    await _getMercadoriaRef(estoqueId).add(mercadoria);
    await _atualizarContadorEstoque(mercadoria.estoqueId, incrementar: true);
  }

  Future<void> atualizarMercadoria(Mercadoria mercadoria) async {
    await _getMercadoriaRef(mercadoria.estoqueId)
        .doc(mercadoria.id)
        .set(mercadoria);
  }

  Future<void> atualizarQuantidadeMercadoria(String estoqueId, String mercadoriaId, int novaQtd) async {
    await _getMercadoriaRef(estoqueId).doc(mercadoriaId).update({
      'quantidade': novaQtd
    });
  }

  Future<void> deletarMercadoria(String estoqueId, String mercadoriaId) async {
    await _getMercadoriaRef(estoqueId).doc(mercadoriaId).delete();
    await _atualizarContadorEstoque(estoqueId, incrementar: false);
  }

  Future<void> _atualizarContadorEstoque(String estoqueId, {required bool incrementar}) async {
    final estoqueRef = firestore.collection('users').doc(userId).collection('estoques').doc(estoqueId);
    
    await estoqueRef.update({
      'quantidadeItens': FieldValue.increment(incrementar ? 1 : -1)
    });
  }
}