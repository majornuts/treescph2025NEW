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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RawAutocomplete<String>(
        focusNode: widget.searchFocusNode,
        textEditingController: widget.searchController,
        optionsBuilder: (TextEditingValue textEditingValue) {
          return widget.filteredData.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          widget.searchController.text = selection;
          widget.onSearchChanged(selection);
        },
        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onChanged: (value) {
              widget.onSearchChanged(value);
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Search tree',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              suffixIcon: widget.searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.searchController.clear();
                  widget.onSearchChanged("");
                },
              )
                  : null,
            ),
          );
        },
        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: Container(
                width: 300,
                color: Colors.white,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}