import 'package:flutter/material.dart';
import 'package:rx_dart/bloc/search_result.dart';
import 'package:rx_dart/models/animal.dart';
import 'package:rx_dart/models/person.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  final Stream<SearchResult?> searchResults;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchResult?>(
      stream: searchResults,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;

          if (result is SearchResultHasError) {
            return Text(
              result.error.toString(),
            );
          } else if (result is SearchResultLoading) {
            return const CircularProgressIndicator();
          } else if (result is SearchResultNoResult) {
            return const Text(
              "No results found, try again",
            );
          } else if (result is SearchResultWithResults) {
            final results = result.results;

            return Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final item = results[index];

                  if (item is Person) {
                    return Text(
                      item.name + " " + item.age.toString(),
                    );
                  } else if (item is Animal) {
                    return Text(item.name + " " + item.animalType.name);
                  } else {
                    return Text(
                      item.name,
                    );
                  }
                },
                itemCount: results.length,
              ),
            );
          } else {
            return const Text(
              "Unknown state",
            );
          }
        } else {
          return const Text(
            "Waiting...",
          );
        }
      },
    );
  }
}
