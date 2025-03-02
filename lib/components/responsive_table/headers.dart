import 'package:flutter/widgets.dart';

class ResponsiveHeaders extends StatelessWidget {
  const ResponsiveHeaders({super.key, required this.headers});

  final List<HeaderField> headers;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: headers
            .map((header) => Text(header.label ?? ""))
            .toList(growable: false));
  }
}

class HeaderField<T> {
  const HeaderField(
      {this.label,
      required this.dataKey,
      // TODO: Implement sortable on backend and then here
      //bool sortable = true,
      this.alignment = Alignment.center,
      this.formatter});

  final String? label;
  final String dataKey;
  final Alignment alignment;
  final Widget Function(T)? formatter;
}
