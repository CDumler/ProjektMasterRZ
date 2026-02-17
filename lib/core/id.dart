import 'dart:math';

String newId([String prefix = 'id']) {
  final rand = Random.secure();
  final v = List.generate(8, (_) => rand.nextInt(16).toRadixString(16)).join();
  return '$prefix-$v';
}
