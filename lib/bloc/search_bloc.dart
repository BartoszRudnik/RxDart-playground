import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/bloc/api.dart';
import 'package:rx_dart/bloc/search_result.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class SearchBloc {
  final Sink<String> search;
  final Stream<SearchResult?> results;

  void dispose() {
    search.close();
  }

  factory SearchBloc({
    required Api api,
  }) {
    final textChanges = BehaviorSubject<String>();

    final Stream<SearchResult?> results = textChanges
        .distinct()
        .debounceTime(
          const Duration(
            milliseconds: 300,
          ),
        )
        .switchMap<SearchResult?>(
      (String searchTerm) {
        if (searchTerm.isEmpty) {
          return Stream<SearchResult?>.value(null);
        } else {
          return Rx.fromCallable(
            () => api.search(
              searchTerm,
            ),
          )
              .delay(
                const Duration(
                  milliseconds: 300,
                ),
              )
              .map(
                (event) => event.isEmpty
                    ? const SearchResultNoResult()
                    : SearchResultWithResults(
                        results: event,
                      ),
              )
              .startWith(
                const SearchResultLoading(),
              )
              .onErrorReturnWith(
                (error, _) => SearchResultHasError(
                  error: error,
                ),
              );
        }
      },
    );

    return SearchBloc._(
      results: results,
      search: textChanges.sink,
    );
  }

  const SearchBloc._({
    required this.results,
    required this.search,
  });
}
