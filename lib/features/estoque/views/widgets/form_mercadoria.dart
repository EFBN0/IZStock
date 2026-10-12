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

    final controller = ref.read(mercadoriaControllerProvider.notifier);
    final titulo = _tituloController.text;
    final descricao = _descricaoController.text;
    final valorVenda = toCurrencyDouble(_valorVendaController.text);
    final valorCusto = toCurrencyDouble(_valorCustoController.text);
    final quantidade = int.parse(_quantidadeController.text);

    if (widget.mercadoria != null) {
      controller.updateMercadoria(
        mercadoria: widget.mercadoria!,
        titulo: titulo,
        descricao: descricao,
        valorVenda: valorVenda,
        valorCusto: valorCusto,
        quantidade: quantidade,
      );
    } else {
      controller.addMercadoria(
        estoqueId: widget.estoque.id!,
        titulo: titulo,
        descricao: descricao,
        valorVenda: valorVenda,
        valorCusto: valorCusto,
        quantidade: quantidade,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final editMode = widget.mercadoria != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                editMode ? 'Editar mercadoria' : 'Nova mercadoria',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.estoque.titulo,
                style: textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome da mercadoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _valorCustoController,
                      decoration: const InputDecoration(labelText: 'Custo'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [_currencyFormatter],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _valorVendaController,
                      decoration: const InputDecoration(
                        labelText: 'Preço de venda',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [_currencyFormatter],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em estoque',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quantidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saveMercadoria,
                child: Text(editMode ? 'Salvar alterações' : 'Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
