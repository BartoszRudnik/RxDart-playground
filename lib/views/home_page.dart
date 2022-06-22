import 'package:flutter/material.dart';
import 'package:rx_dart/bloc/api.dart';
import 'package:rx_dart/bloc/search_bloc.dart';
import 'package:rx_dart/views/search_results_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();

    searchBloc = SearchBloc(
      api: Api(),
    );
  }

  @override
  void dispose() {
    searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter your search term",
              ),
              onChanged: searchBloc.search.add,
            ),
            SearchResultView(
              searchResults: searchBloc.results,
            ),
          ],
        ),
      ),
    );
  }
}
