import 'package:izstock/features/estoque/models/mercadoria.dart';
import 'package:izstock/features/vendas/models/mercadoria_venda.dart';

enum CarrinhoStatus {
  ocioso,
  itemAdicionado,
  itemRemovido,
  vendaFinalizada,
  erro,
}

class CarrinhoState {
  final List<MercadoriaVenda> mercadoriaList;
  final CarrinhoStatus status;
  final String? mensagemErro;
  final List<Mercadoria> cacheMercadoriaList;

  const CarrinhoState({
    this.mercadoriaList = const [],
    this.status = CarrinhoStatus.ocioso,
    this.mensagemErro,
    this.cacheMercadoriaList = const [],
  });

  CarrinhoState copyWith({
    List<MercadoriaVenda>? mercadoriaList,
    CarrinhoStatus? status,
    String? mensagemErro,
    List<Mercadoria>? cacheMercadoriaList,
  }) {
    return CarrinhoState(
      mercadoriaList: mercadoriaList ?? this.mercadoriaList,
      status: status ?? CarrinhoStatus.ocioso, 
      mensagemErro: mensagemErro,
      cacheMercadoriaList: cacheMercadoriaList ?? this.cacheMercadoriaList,
    );
  }
}