import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:izstock/core/repositories/base_repository.dart';
import 'package:izstock/features/estoque/models/estoque.dart';

class EstoqueRepository extends BaseRepository {
  EstoqueRepository({super.firestore, super.auth});

  CollectionReference<Estoque> get _estoqueRef {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('estoques')
        .withConverter<Estoque>(
          fromFirestore: (snapshot, _) => Estoque.fromFirestore(snapshot),
          toFirestore: (estoque, _) => estoque.toFirestore(),
        );
  }

  Stream<List<Estoque>> getEstoquesStream() {
    return _estoqueRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> saveEstoque(String titulo) async {
    final novoEstoque = Estoque(titulo: titulo, quantidadeItens: 0);
    await _estoqueRef.add(novoEstoque);
  }

  Future<void> updateEstoque(String estoqueId, Map<String, dynamic> data) async {
    await _estoqueRef.doc(estoqueId).update(data);
  }

  Future<void> removeEstoque(String estoqueId) async {
    await _estoqueRef.doc(estoqueId).delete();
  }
}
