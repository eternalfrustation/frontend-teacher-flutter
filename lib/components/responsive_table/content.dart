import 'package:flutter/widgets.dart';
import '/components/responsive_table/headers.dart';
import '/components/responsive_table/row.dart';

class RowList extends StatelessWidget {
  const RowList({
    super.key,
    required this.headers,
    required this.data,
  });

  final List<Map<String, dynamic>> data;
  final List<HeaderField> headers;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: data
            .map((item) => ResponsiveRow(data: item, headers: headers))
            .toList());
  }
}

