import 'package:flutter/widgets.dart';
import '/components/responsive_table/headers.dart';

class ResponsiveRow extends StatelessWidget {
  const ResponsiveRow({super.key, required this.data, required this.headers});

  final Map<String, dynamic> data;
  final List<HeaderField> headers;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: headers
            .map((header) => Align(
                alignment: header.alignment,
                child: (header.formatter ??
                    (x) => Text(x.toString()))(data[header.dataKey] ?? "")))
            .toList());
  }
}
