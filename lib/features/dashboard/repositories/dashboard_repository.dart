import 'package:izstock/core/repositories/base_repository.dart';
import 'package:izstock/features/dashboard/models/combo_regra.dart';
import 'package:izstock/features/dashboard/models/hotspot_venda.dart';
import 'package:izstock/features/dashboard/models/resumo_financeiro.dart';

class DashboardRepository extends BaseRepository {
  DashboardRepository({super.firestore, super.auth});

  Stream<ResumoFinanceiro> getResumoDiarioStream(DateTime date) {
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return firestore
        .collection('users')
        .doc(userId)
        .collection('resumos')
        .doc(formattedDate)
        .snapshots()
        .map((doc) {
          final dados = doc.data() ?? {};
          return ResumoFinanceiro.fromMap(dados);
        });
  }

  Stream<List<ResumoFinanceiro>> getResumosStream() {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('resumos')
        .orderBy('data', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ResumoFinanceiro.fromMap(doc.data()))
              .where((resumo) => resumo.data != null)
              .toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> getHistoricoVendasStream() {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('resumos')
        .orderBy('data', descending: true)
        .limit(7)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<List<HotspotVenda>> getGeoInsights() async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('insights')
        .doc('geo_analise')
        .get();

    if (!doc.exists) return [];

    final listaPontos = doc.data()?['pontos'] as List<dynamic>?;

    if (listaPontos == null) return [];

    return listaPontos
        .map((ponto) => HotspotVenda.fromMap(Map<String, dynamic>.from(ponto)))
        .toList();
  }

  Future<List<ComboRegra>> getCombosInsights() async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('insights')
        .doc('combos_analise')
        .get();

    if (!doc.exists) return [];

    final dados = doc.data()?['regras'] as List<dynamic>?;

    if (dados == null) return [];

    return dados
        .map((e) => ComboRegra.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}
