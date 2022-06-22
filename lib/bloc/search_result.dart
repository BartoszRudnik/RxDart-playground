import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/models/thing.dart';

@immutable
abstract class SearchResult {
  const SearchResult();
}

@immutable
class SearchResultLoading implements SearchResult {
  const SearchResultLoading();
}

@immutable
class SearchResultNoResult implements SearchResult {
  const SearchResultNoResult();
}

@immutable
class SearchResultHasError implements SearchResult {
  final Object error;

  const SearchResultHasError({
    required this.error,
  });
}

@immutable
class SearchResultWithResults implements SearchResult {
  final List<Thing> results;

  const SearchResultWithResults({
    required this.results,
  });
}
