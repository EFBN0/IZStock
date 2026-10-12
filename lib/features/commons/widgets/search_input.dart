import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    required this.placeholder,
    required this.onChanged,
    this.autofocus = false,
  });

  final String placeholder;
  final void Function(String) onChanged;
  final bool autofocus;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      onChanged: _onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: widget.placeholder,
        prefixIcon: const Icon(Icons.search_rounded),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  _controller.clear();
                  _onChanged('');
                },
              ),
      ),
    );
  }
}
