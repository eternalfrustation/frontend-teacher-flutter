import 'package:flutter/material.dart';

class PaginationFooter extends StatefulWidget {
  const PaginationFooter({
    super.key,
    required this.listingSettings,
  });

  final ListingSettings listingSettings;

  @override
  State<PaginationFooter> createState() => PaginationFooterState();
}

class PaginationFooterState extends State<PaginationFooter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.listingSettings.prevPage();
          },
        ),
        Text("Page ${widget.listingSettings.page}"),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            widget.listingSettings.nextPage();
          },
        ),
      ],
    );
  }
}
