import 'package:flutter/material.dart';
import 'package:izstock/features/estoque/data/estoque_mock.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/views/widgets/estoque_details.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() {
    return _EstoquePageState();
  }
}

class _EstoquePageState extends State<EstoquePage> {
  final _estoques = kEstoquesMockados;

  void _onEstoqueTap(Estoque estoque) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EstoqueDetailsPage(estoque: estoque)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: ListView.builder(
          itemCount: _estoques.length,
          itemBuilder: (ctx, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: () {
                _onEstoqueTap(_estoques[index]);
              },
              child: EstoqueItem(estoque: _estoques[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class EstoqueItem extends StatelessWidget {
  const EstoqueItem({super.key, required this.estoque});

  final Estoque estoque;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estoque.titulo,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                const SizedBox(height: 6),
                Text('Itens: ${estoque.mercadorias.length}'),
              ],
            ),
            IconButton.outlined(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                size: 20,
                color: Color.fromARGB(255, 150, 24, 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
