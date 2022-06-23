import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

Stream<String> getNames(String filePath) {
  final names = rootBundle.loadString(filePath);

  return Stream.fromFuture(names).transform(const LineSplitter());
}

Stream<String> getAllNames() {
  return getNames('assets/text/cats.txt').concatWith(
    [
      getNames(
        'assets/text/dogs.txt',
      ),
    ],
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: getAllNames().toList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              final names = snapshot.requireData;

              return ListView.separated(
                itemCount: names.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => Text(
                  names[index],
                ),
              );
          }
        },
      ),
    );
  }
}
