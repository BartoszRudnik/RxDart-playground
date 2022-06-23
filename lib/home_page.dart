import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypeOfThing {
  animal,
  person,
}

@immutable
class Thing {
  final TypeOfThing typeOfThing;
  final String name;

  const Thing({
    required this.typeOfThing,
    required this.name,
  });
}

const things = [
  Thing(
    typeOfThing: TypeOfThing.person,
    name: "Foo",
  ),
  Thing(
    typeOfThing: TypeOfThing.person,
    name: 'Bar',
  ),
  Thing(
    typeOfThing: TypeOfThing.animal,
    name: 'Bunz',
  ),
];

@immutable
class Bloc {
  final Sink<TypeOfThing?> setTypeOfThing;
  final Stream<TypeOfThing?> currentTypeOfThing;
  final Stream<Iterable<Thing>> things;

  void dispose() {
    setTypeOfThing.close();
  }

  const Bloc._({
    required this.currentTypeOfThing,
    required this.setTypeOfThing,
    required this.things,
  });

  factory Bloc({
    required Iterable<Thing> things,
  }) {
    final typeOfThingSubject = BehaviorSubject<TypeOfThing?>();
    final filteredThings = typeOfThingSubject
        .debounceTime(
      const Duration(
        milliseconds: 300,
      ),
    )
        .map(
      (typeOfThing) {
        if (typeOfThing != null) {
          return things.where(
            (thing) => thing.typeOfThing == typeOfThing,
          );
        } else {
          return things;
        }
      },
    ).startWith(
      things,
    );

    return Bloc._(
      currentTypeOfThing: typeOfThingSubject.stream,
      setTypeOfThing: typeOfThingSubject.sink,
      things: filteredThings,
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

    bloc = Bloc(
      things: things,
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          StreamBuilder<TypeOfThing?>(
            stream: bloc.currentTypeOfThing,
            builder: (ctx, snapshot) {
              final selectedTypeOfThing = snapshot.data;

              return Wrap(
                children: TypeOfThing.values.map(
                  (typeOfThing) {
                    return FilterChip(
                      selectedColor: Colors.blueAccent,
                      label: Text(typeOfThing.name),
                      selected: selectedTypeOfThing == typeOfThing,
                      onSelected: (selected) {
                        final type = selected ? typeOfThing : null;

                        bloc.setTypeOfThing.add(type);
                      },
                    );
                  },
                ).toList(),
              );
            },
          ),
          Expanded(
            child: StreamBuilder<Iterable<Thing>>(
              stream: bloc.things,
              builder: (context, snapshot) {
                final things = snapshot.data ?? [];

                return ListView.builder(
                  itemCount: things.length,
                  itemBuilder: (ctx, index) {
                    return Text(
                      things.elementAt(index).name + " " + things.elementAt(index).typeOfThing.name,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
