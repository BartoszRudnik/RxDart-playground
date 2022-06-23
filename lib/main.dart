import 'package:flutter/material.dart';
import 'package:rx_dart/home_page.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

void testIt() async {
  final stream1 = Stream.periodic(
    const Duration(
      seconds: 1,
    ),
    (count) => 'Stream 1: $count',
  );

  final stream2 = Stream.periodic(
    const Duration(
      seconds: 3,
    ),
    (count) => 'Stream 2: $count',
  );

  final result = Rx.zip2(
    stream1,
    stream2,
    (a, b) => 'A is $a, B is $b',
  );

  await for (final value in result) {
    print(value);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
