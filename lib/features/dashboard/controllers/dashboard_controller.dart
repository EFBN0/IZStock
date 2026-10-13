import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izstock/features/dashboard/models/combo_regra.dart';
import 'package:izstock/features/dashboard/models/hotspot_venda.dart';
import 'package:izstock/features/dashboard/models/resumo_financeiro.dart';
import '../repositories/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

final dataResumoSelectedProvider = StateProvider<DateTime?>((ref) => null);

final resumoFinanceiroController = StreamProvider.autoDispose<ResumoFinanceiro>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  final dataSelected = ref.watch(dataResumoSelectedProvider);
  return repository.getResumoDiarioStream(dataSelected ?? DateTime.now());
});

final availableResumosController = StreamProvider.autoDispose<List<ResumoFinanceiro>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getResumosStream();
});

  final historicoVendasController = StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.getHistoricoVendasStream();
  });

final geoInsightsController = FutureProvider.autoDispose<List<HotspotVenda>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getGeoInsights();
});

final combosInsightsController = FutureProvider.autoDispose<List<ComboRegra>>((ref) async {
  final repository = ref.watch(dashboardRepositoryProvider);
  return repository.getCombosInsights();
});