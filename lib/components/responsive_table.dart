import 'package:flutter/widgets.dart';
import '/components/responsive_table/headers.dart';

class ResponsiveTable<Filter> extends StatefulWidget {
  const ResponsiveTable({
    super.key,
    required List<HeaderField> headers,
    required Map<String, dynamic> Function(Filter, ListingSettings) fetchItems,
  });

  @override
  State<StatefulWidget> createState() => ResponsiveTableState();
}

class ResponsiveTableState extends State<ResponsiveTable> {
  @override
  Widget build(BuildContext context) {
	
  }
}


