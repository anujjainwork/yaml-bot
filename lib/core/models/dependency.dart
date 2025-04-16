// lib/core/models/dependency.dart
class Dependency {
  final String name;
  final String version;
  final bool isDev;

  Dependency({
    required this.name,
    required this.version,
    this.isDev = false,
  });

  Map<String, dynamic> toMap() => {name: version};

  @override
  String toString() => '$name: $version';
}