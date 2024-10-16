import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final List<String> suggestions;
  final Function(String) onTextChanged;
  final String hintText;

  CustomSearchBar({required this.suggestions, required this.onTextChanged, required this.hintText});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        // filteredEnterprisesList = enterprisesList;
      } else {
        // filteredEnterprisesList = enterprisesList.where((enterprise) {
        //   return enterprise.name!.toLowerCase().contains(query.toLowerCase()) ||
        //       enterprise.licenseNum!
        //           .toLowerCase()
        //           .contains(query.toLowerCase());
        // }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return widget.suggestions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        widget.onTextChanged(selection);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.addListener(() {
          widget.onTextChanged(textEditingController.text);
        });
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
      },
    );
  }
}
