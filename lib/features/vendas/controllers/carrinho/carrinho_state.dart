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

  const CarrinhoState({
    this.mercadoriaList = const [],
    this.status = CarrinhoStatus.ocioso,
    this.mensagemErro,
  });

  CarrinhoState copyWith({
    List<MercadoriaVenda>? mercadoriaList,
    CarrinhoStatus? status,
    String? mensagemErro,
  }) {
    return CarrinhoState(
      mercadoriaList: mercadoriaList ?? this.mercadoriaList,
      status: status ?? CarrinhoStatus.ocioso, 
      mensagemErro: mensagemErro,
    );
  }
}