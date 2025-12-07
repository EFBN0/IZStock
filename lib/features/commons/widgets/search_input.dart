import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String placeholder;
  final String? q;
  final Function()? onTap;
  final Function(BuildContext, String, TextEditingController)? onInputTextChanged;
  final FocusNode? focusNode;

  const SearchInput({
    required this.placeholder,
    this.q,
    this.onTap,
    this.onInputTextChanged,
    this.focusNode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(
      text: q ?? '',
    );

    final textField = TextField(
      controller: controller,
      focusNode: focusNode,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: false,
        prefixIcon: const Icon(Icons.search),
        hintText: placeholder,
      ),
      onTap: onTap ?? () => {},
      onChanged: (value) => onInputTextChanged!(context, value, controller),
    );
    focusNode?.requestFocus();
    return textField;
  }
}
