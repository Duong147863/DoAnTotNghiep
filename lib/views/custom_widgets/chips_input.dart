import 'package:flutter/material.dart';
import 'package:nloffice_hrm/views/custom_widgets/ui_spacer.dart';

class ChipInput {
  final String label;
  final Function? onDeleted;

  ChipInput({required this.label, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: CircleAvatar() ?? UiSpacer.emptySpace(),
      onDeleted: () {
            onDeleted!();
          } ??
          () {},
    );
  }
}
