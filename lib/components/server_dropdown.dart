import 'package:flutter/material.dart';

class ServerDropdown<T> extends StatefulWidget {
  const ServerDropdown(
      {super.key,
      required this.label,
      this.multiple = false,
      required this.fetch,
      required this.onSelected});

  final String label;
  final bool multiple;
  final Future<List<DropdownMenuEntry<T>>> Function(String) fetch;
  final Function(T) onSelected;

  @override
  State<StatefulWidget> createState() => ServerDropdownState();
}

class ServerDropdownState<T> extends State<ServerDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      label: Text(widget.label),
      multiple: widget.multiple,
      fetch: widget.fetch,
      onSelected: widget.onSelected,
    );
  }
}
