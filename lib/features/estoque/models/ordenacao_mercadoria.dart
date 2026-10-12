import 'package:izstock/features/estoque/models/mercadoria.dart';

enum OrdenacaoMercadoria {
  dataCriacaoDesc('Data criação (mais recentes)'),
  dataCriacaoAsc('Data criação (mais antigas)'),
  tituloAsc('A-Z'),
  tituloDesc('Z-A');

  const OrdenacaoMercadoria(this.label);

  final String label;

  int compare(Mercadoria a, Mercadoria b) {
    switch (this) {
      case OrdenacaoMercadoria.dataCriacaoDesc:
        return _compareCreatedAt(b, a);
      case OrdenacaoMercadoria.dataCriacaoAsc:
        return _compareCreatedAt(a, b);
      case OrdenacaoMercadoria.tituloAsc:
        return _compareTitulo(a, b);
      case OrdenacaoMercadoria.tituloDesc:
        return _compareTitulo(b, a);
    }
  }

  static int _compareTitulo(Mercadoria a, Mercadoria b) {
    return a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
  }

  static int _compareCreatedAt(Mercadoria a, Mercadoria b) {
    if (a.createdAt == null && b.createdAt == null) return 0;
    if (a.createdAt == null) return 1;
    if (b.createdAt == null) return -1;
    return a.createdAt!.compareTo(b.createdAt!);
  }
}
