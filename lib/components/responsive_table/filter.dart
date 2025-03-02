import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({
    super.key,
    required this.listingSettings,
    required this.filterInfo,
  });

  final ListingSettings listingSettings;
  final FilterInfo filterInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: filterInfo.fields
          .map((field) => FilterFieldWidget(
                field: field,
                listingSettings: listingSettings,
              ))
          .toList(),
    );
  }
}

class FilterFieldWidget extends StatelessWidget {
  const FilterFieldWidget({
    super.key,
    required this.field,
    required this.listingSettings,
  });

  final FilterField field;
  final ListingSettings listingSettings;

  @override
  Widget build(BuildContext context) {
    return switch (field.type) {
      FilterType.string => TextField(
          onChanged: (value) {
            listingSettings.set(field.keyName, value);
          },
          decoration: InputDecoration(
            labelText: field.label,
          ),
        ),
      FilterType.integer => TextField(
          onChanged: (value) {
            listingSettings.set(field.keyName, int.parse(value));
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            labelText: field.label,
          ),
        ),
      FilterType.boolean => CheckboxListTile(
          title: Text(field.label),
          value: false,
          onChanged: (value) {
            listingSettings.set(field.keyName, value);
          },
        ),
      // TODO: Handle this case.
      FilterType.array => throw UnimplementedError(),
      FilterType.dropdown => DropdownMenu(
          dropdownMenuEntries: field.dropdownOptions?.call() ?? [],
          label: Text(field.label),
          onSelected: (value) {
            listingSettings.set(field.keyName, value);
          },
        ),
      // TODO: Handle this case.
      FilterType.fromId ||
      FilterType.subject ||
      FilterType.teacher ||
      FilterType.teacher ||
      FilterType.student ||
      FilterType.classroom ||
      FilterType.paymentPurpose =>
        throw UnimplementedError(),
      // TODO: Handle this case.
      FilterType.dates => throw UnimplementedError(),
    };
  }
}

class FilterInfo {
  final List<FilterField> fields;
  final Function(FilterInfo)? exportFunction;

  FilterInfo({required this.fields, this.exportFunction});
}

class FilterField {
  final String label;
  final FilterType type;
  final String keyName;
  final bool? disabled;
  final Function? fetchOptions;
  final List<DropdownMenuEntry<dynamic>> Function()? dropdownOptions;
  final String? searchField;

  FilterField({
    required this.label,
    required this.type,
    required this.keyName,
    this.disabled,
    this.fetchOptions,
    this.dropdownOptions,
    this.searchField,
  });
}

enum FilterType {
  string,
  integer,
  fromId,
  boolean,
  array,
  dropdown,
  classroom,
  subject,
  teacher,
  student,
  paymentPurpose,
  dates,
}

class ListingSettings with ChangeNotifier {
  int _page = 1;
  int _pageSize = 10;
  int get page => _page;
  int get pageSize => _pageSize;

  final Map<String, dynamic> _filter = {};
  Map<String, dynamic> get filter => _filter;

  void nextPage() {
    _page++;
    notifyListeners();
  }

  void prevPage() {
    _page++;
    notifyListeners();
  }

  void setPageSize(int size) {
    _pageSize = size;
    notifyListeners();
  }

  void set(String key, dynamic value) {
    _filter[key] = value;
    notifyListeners();
  }
}
