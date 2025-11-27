import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:izstock/features/estoque/controllers/mercadoria_controller.dart';
import 'package:izstock/features/estoque/models/estoque.dart';
import 'package:izstock/features/estoque/models/mercadoria.dart';

class FormMercadoria extends ConsumerStatefulWidget {
  const FormMercadoria({super.key, this.mercadoria, required this.estoque});

  final Mercadoria? mercadoria;
  final Estoque estoque;

  @override
  ConsumerState<FormMercadoria> createState() {
    return _FormMercadoriaState();
  }
}

class _FormMercadoriaState extends ConsumerState<FormMercadoria> {
  final _form = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _valorCustoController;
  late TextEditingController _valorVendaController;
  late TextEditingController _quantidadeController;

  @override
  void initState() {
    super.initState();
    final editMode = widget.mercadoria != null;

    _tituloController = TextEditingController(text: editMode ? widget.mercadoria!.titulo : '');
    _descricaoController = TextEditingController(text: editMode ? widget.mercadoria!.descricao : '');
    _valorCustoController = TextEditingController(text: editMode ? _currencyFormatter.formatDouble(widget.mercadoria!.valorCusto) : '');
    _valorVendaController = TextEditingController(text: editMode ? _currencyFormatter.formatDouble(widget.mercadoria!.valorVenda) : '');
    _quantidadeController = TextEditingController(text: editMode ? widget.mercadoria!.quantidade.toString() : '');
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _valorCustoController.dispose();
    _valorVendaController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: 2,
      );

  double toCurrencyDouble(String value) {
    if (value.isEmpty) return 0.0;
    var clean = value.replaceAll('R\$', '').trim();
    clean = clean.replaceAll('.', '');
    clean = clean.replaceAll(',', '.');
    return double.tryParse(clean) ?? 0.0;
  }

  void _saveMercadoria() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    ref
        .read(mercadoriaControllerProvider.notifier)
        .addMercadoria(
          estoqueId: widget.estoque.id!,
          titulo: _tituloController.text,
          valorVenda: toCurrencyDouble(_valorVendaController.text),
          valorCusto: toCurrencyDouble(_valorCustoController.text),
          quantidade: int.parse(_quantidadeController.text),
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          children: [
            Text(
              widget.mercadoria != null
                  ? 'Editar mercadoria'
                  : 'Nova mercadoria',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            const SizedBox(height: 16),
            const Icon(Icons.image),
            const Text('Seletor de imagem aqui'),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tituloController,
              decoration: InputDecoration(label: Text('Título'), filled: false),
              validator: (value) {
                if (value == null) {
                  return 'Campo Título obrigatório';
                }
                return null;
              },
              onSaved: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: InputDecoration(
                label: Text('Descrição'),
                filled: false,
              ),
              onSaved: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorCustoController,
              decoration: InputDecoration(
                label: Text('Preço de custo'),
                filled: false,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [_currencyFormatter],
              onSaved: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorVendaController,
              decoration: InputDecoration(
                label: Text('Preço de venda'),
                filled: false,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [_currencyFormatter],
              onSaved: (value) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantidadeController,
              decoration: InputDecoration(
                label: Text('Quantidade'),
                filled: false,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (value) {},
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _saveMercadoria,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
