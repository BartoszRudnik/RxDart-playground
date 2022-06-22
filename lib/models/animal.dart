import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/models/thing.dart';

enum AnimalType {
  dog,
  cat,
  rabbit,
  unknown,
}

@immutable
class Animal extends Thing {
  final AnimalType animalType;

  const Animal({
    required String name,
    required this.animalType,
  }) : super(name: name);

  factory Animal.fromJson(Map<String, dynamic> json) {
    final AnimalType animalType;

    switch ((json['type'] as String).toLowerCase().trim()) {
      case 'rabbit':
        animalType = AnimalType.rabbit;
        break;
      case 'cat':
        animalType = AnimalType.cat;
        break;
      case 'dog':
        animalType = AnimalType.dog;
        break;
      default:
        animalType = AnimalType.unknown;
        break;
    }

    return Animal(
      name: json['name'],
      animalType: animalType,
    );
  }
}
