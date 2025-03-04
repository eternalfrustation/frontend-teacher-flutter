import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'responsive_table/filter.dart';

class ServerDropdown<T> extends StatefulWidget {
  final String label;

  final bool multiple;
  final String searchKey;
  final Future<List<DropdownMenuEntry<T?>>> Function(ListingSettings) fetch;
  final Function(T?) onSelected;

  const ServerDropdown(
      {super.key,
      required this.label,
      this.multiple = false,
      required this.fetch,
      required this.searchKey,
      required this.onSelected});

  @override
  State<StatefulWidget> createState() => ServerDropdownState();
}

class ServerDropdownState<T> extends State<ServerDropdown<T>> {
  List<DropdownMenuEntry<T?>> data = [];
  ListingSettings listingSettings = ListingSettings();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T?>(
      dropdownMenuEntries: data +
          [
            DropdownMenuEntry(
                label: /* Should not be displayed*/ "Loading",
                enabled: false,
                value: null,
                labelWidget: VisibilityDetector(
                  key: const Key("dropdown-visibility"),
                  onVisibilityChanged: (info) {
                    if (info.visibleFraction > 0.6 && !loading) {
                      widget.fetch(listingSettings).then((value) {
                        setState(() {
                          loading = false;
                          listingSettings.nextPage();
                          data = value;
                        });
                      });
                      loading = true;
                    }
                  },
                  child: const Text("Loading"),
                ))
          ],
      label: Text(widget.label),
      onSelected: widget.onSelected,
    );
  }
}
