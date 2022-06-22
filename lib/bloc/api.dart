import 'dart:convert';
import 'dart:io';

import 'package:rx_dart/models/animal.dart';
import 'package:rx_dart/models/person.dart';
import 'package:rx_dart/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    final cachedResults = _extractThingsUsingSearchTerm(term);

    if (cachedResults != null) {
      return cachedResults;
    } else {
      final animals = await _getJson(
        "http://127.0.0.1:5500/apis/animals.json",
      ).then(
        (json) => json.map(
          (value) => Animal.fromJson(
            value,
          ),
        ),
      );

      final persons = await _getJson(
        "http://127.0.0.1:5500/apis/persons.json",
      ).then(
        (json) => json.map(
          (personJson) => Person.fromJson(
            personJson,
          ),
        ),
      );

      _persons = persons.toList();
      _animals = animals.toList();

      return _extractThingsUsingSearchTerm(term) ?? [];
    }
  }

  List<Thing>? _extractThingsUsingSearchTerm(SearchTerm term) {
    final _cachedAnimals = _animals;
    final _cachedPersons = _persons;

    if (_cachedAnimals != null && _cachedPersons != null) {
      List<Thing> result = [];

      for (final animal in _cachedAnimals) {
        if (animal.name.trimmedContains(term) || animal.animalType.name.trimmedContains(term)) {
          result.add(animal);
        }
      }

      for (final person in _cachedPersons) {
        if (person.name.trimmedContains(term) || person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }

      return result;
    }
    return null;
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(
        Uri.parse(
          url,
        ),
      )
      .then(
        (req) => req.close(),
      )
      .then(
        (response) => response
            .transform(
              utf8.decoder,
            )
            .join(),
      )
      .then(
        (jsonString) => json.decode(
          jsonString,
        ),
      );
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
