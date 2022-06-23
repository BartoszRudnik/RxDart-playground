import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

typedef AsyncSnapshotBuilderCallback<T> = Widget Function(
  BuildContext context,
  T? value,
);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  const AsyncSnapshotBuilder({
    Key? key,
    required this.stream,
    this.onActive,
    this.onDone,
    this.onNone,
    this.onWaiting,
  }) : super(key: key);

  final Stream<T> stream;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;
  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onActive;
  final AsyncSnapshotBuilderCallback<T>? onDone;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            final callback = onNone ?? (_, __) => const SizedBox();

            return callback(
              context,
              snapshot.data,
            );
          case ConnectionState.waiting:
            final callback = onWaiting ?? (_, __) => const SizedBox();

            return callback(
              context,
              snapshot.data,
            );
          case ConnectionState.active:
            final callback = onActive ?? (_, __) => const SizedBox();

            return callback(
              context,
              snapshot.data,
            );
          case ConnectionState.done:
            final callback = onDone ?? (_, __) => const SizedBox();

            return callback(
              context,
              snapshot.data,
            );
        }
      },
    );
  }
}

@immutable
class Bloc {
  final Sink<String?> setFirstName;
  final Sink<String?> setLastName;
  final Stream<String> fullName;

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  void dispose() {
    setFirstName.close();
    setLastName.close();
  }

  factory Bloc() {
    final setFirstNameSubject = BehaviorSubject<String?>();
    final setLastNameSubject = BehaviorSubject<String?>();

    final Stream<String> fullname = Rx.combineLatest2(
      setFirstNameSubject.startWith(null),
      setLastNameSubject.startWith(null),
      (String? firstName, String? lastName) {
        if (firstName != null && firstName.isNotEmpty && lastName != null && lastName.isNotEmpty) {
          return '$firstName $lastName';
        } else {
          return "first name and last name must be provided";
        }
      },
    );

    return Bloc._(
      setFirstName: setFirstNameSubject.sink,
      setLastName: setLastNameSubject.sink,
      fullName: fullname,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Bloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = Bloc();
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Combine latest",
        ),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter your first name",
            ),
            onChanged: bloc.setFirstName.add,
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter your last name",
            ),
            onChanged: bloc.setLastName.add,
          ),
          AsyncSnapshotBuilder<String>(
            stream: bloc.fullName,
            onActive: (context, value) => Text(
              value ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
