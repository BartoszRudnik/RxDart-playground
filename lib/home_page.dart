import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );

    useEffect(
      () => subject.close,
      [subject],
    );

    final name = StreamController<String>();

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: subject.stream.distinct().debounceTime(
                const Duration(
                  seconds: 1,
                ),
              ),
          initialData: "Plese start typing...",
          builder: (context, snapshot) {
            return Text(
              snapshot.requireData,
            );
          },
        ),
      ),
      body: TextField(
        onChanged: (value) {
          subject.sink.add(value);
        },
      ),
    );
  }
}
