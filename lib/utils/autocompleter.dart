import 'package:flutter/material.dart';

class AutocompleteWidget extends StatefulWidget {
  const AutocompleteWidget({
    Key? key,
    required this.fullData,
    required this.searchController,
    required this.onSearchChanged,
    required this.searchFocusNode,
    required this.filteredData
  }) : super(key: key);

  final List<String> fullData;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final FocusNode searchFocusNode;
  final List<String> filteredData;
  @override
  State<AutocompleteWidget> createState() => _AutocompleteWidgetState();
}

class _AutocompleteWidgetState extends State<AutocompleteWidget> {
  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          return widget.fullData.where((String option) {
            return option.toLowerCase().contains(
              textEditingValue.text.toLowerCase(),
            );
          });
        }
      },
      onSelected: (String selection) {
        widget.onSearchChanged(selection);
        widget.searchController.text = selection;
      },
      fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
          ) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (focusNode.hasFocus) {
            textEditingController.selection = TextSelection(
              baseOffset: textEditingController.text.length,
              extentOffset: textEditingController.text.length,
            );
          }
        });
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: 'Search... for a tree',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                textEditingController.clear();
                widget.filteredData.clear();
                widget.onSearchChanged('');
              },
            ),
          ),
          onChanged: widget.onSearchChanged,
        );
      },
    );
  }
}