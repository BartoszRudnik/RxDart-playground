import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();

    subject = BehaviorSubject<DateTime>();
    streamOfStrings = subject.switchMap(
      (dateTime) => Stream.periodic(
        const Duration(
          seconds: 1,
        ),
        (value) => 'Count $value, datetime $dateTime',
      ),
    );
  }

  @override
  void dispose() {
    subject.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<String>(
            stream: streamOfStrings,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.requireData,
                );
              } else {
                return const Text(
                  'Waiting for data',
                );
              }
            },
          ),
          TextButton(
            onPressed: () {
              subject.add(
                DateTime.now(),
              );
            },
            child: const Text(
              'Start stream',
            ),
          ),
        ],
      ),
    );
  }
}
