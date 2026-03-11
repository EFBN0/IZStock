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
  final double desconto;
  final List<Mercadoria> cacheMercadoriaList;

  const CarrinhoState({
    this.mercadoriaList = const [],
    this.status = CarrinhoStatus.ocioso,
    this.mensagemErro,
    this.desconto = 0.0,
    this.cacheMercadoriaList = const [],
  });

  CarrinhoState copyWith({
    List<MercadoriaVenda>? mercadoriaList,
    CarrinhoStatus? status,
    String? mensagemErro,
    double? desconto,
    List<Mercadoria>? cacheMercadoriaList,
  }) {
    return CarrinhoState(
      mercadoriaList: mercadoriaList ?? this.mercadoriaList,
      status: status ?? CarrinhoStatus.ocioso, 
      mensagemErro: mensagemErro,
      desconto: desconto ?? this.desconto,
      cacheMercadoriaList: cacheMercadoriaList ?? this.cacheMercadoriaList,
    );
  }
}