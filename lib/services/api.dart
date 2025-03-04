import 'dart:io';

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/responsive_table/filter.dart';
import 'store.dart';

class Endpoints<T> {
  final String path;

  Endpoints({required this.path});

  Future<List<T>> list(ListingSettings listingSettings) async => await Store.dio
      .get("$path/all", queryParameters: listingSettings.toQueryParameters())
      .then((resp) => resp.data);

  Future<T> retrieve(int id) async =>
      Store.dio.get("/$path/$id").then((resp) => resp.data);

  Future<T> create(T data) =>
      Store.dio.post("$path/create/", data: data).then((resp) => resp.data);

  Future<T> update(int id, T data) =>
      Store.dio.put("$path/$id", data: data).then((resp) => resp.data);

  export(ListingSettings listingSettings) async {
    final exportUrl = Uri.parse("${Store.dio.options.baseUrl}$path/export/");
    if (!await launchUrl(exportUrl)) {
      throw Exception('Could not export file');
    }
  }

  import(MultipartFile file, {bool finalize = false}) {
    final formData = FormData();
    formData.files.add(MapEntry("file", file));
    return Store.dio
        .post("$path/import/${finalize ? 'final' : 'dry_run'}/",
            data: formData,
            options: Options(contentType: "multipart/form-data"))
        .then((resp) => resp.data);
  }

  Future<Stats> get stats =>
      Store.dio.get("$path/stats/").then((resp) => Stats.fromJson(resp.data));
}

class Stats {
  final int total;
  final int pendingApproval;

  Stats({required this.total, required this.pendingApproval});

  static Stats fromJson(Map<String, dynamic> data) {
    return Stats(
        total: data["total"], pendingApproval: data["pending_approval"]);
  }
}

class PaginatedResponse<T> {
  final List<T> results;
  final int currentPage;
  final int totalPages;
  final int totalRecords;

  PaginatedResponse(
      {required this.results,
      required this.currentPage,
      required this.totalPages,
      required this.totalRecords});
}
