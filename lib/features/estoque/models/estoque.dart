import 'package:izstock/features/estoque/models/mercadoria.dart';

class Estoque {
  const Estoque({
    required this.id,
    required this.titulo,
    required this.mercadorias,
  });

  final int id;
  final String titulo;
  final List<Mercadoria> mercadorias;
}
