import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

/// Responsible for reading and writing pubspec.yaml
class PubspecService {
  final String _pubspecPath;

  PubspecService([String? basePath])
      : _pubspecPath = p.join(basePath ?? Directory.current.path, 'pubspec.yaml');

  /// Reads the entire pubspec.yaml content as a Map
  Future<Map<String, dynamic>> readPubspec() async {
    final file = File(_pubspecPath);
    if (!file.existsSync()) {
      throw Exception('pubspec.yaml not found at $_pubspecPath');
    }

    final content = await file.readAsString();
    final doc = loadYaml(content);
    return Map<String, dynamic>.from(doc);
  }

  /// Writes back to pubspec.yaml
  Future<void> writePubspec(Map<String, dynamic> updatedContent) async {
    final buffer = StringBuffer();

    // Preserving formatting for top-level keys only (minimalistic approach for now)
    for (var entry in updatedContent.entries) {
      buffer.writeln('${entry.key}:');
      if (entry.value is Map) {
        (entry.value as Map).forEach((key, value) {
          buffer.writeln('  $key: $value');
        });
      } else {
        buffer.writeln('  ${entry.value}');
      }
    }

    await File(_pubspecPath).writeAsString(buffer.toString());
  }
}