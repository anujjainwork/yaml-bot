import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_bot/core/models/conflict.dart';
import 'package:yaml_bot/core/models/conflict_type_enum.dart';

class ConflictDetectorService {
  Future<List<Conflict>> detectConflicts() async {
    final file = File('pubspec.yaml');
    final yaml = loadYaml(await file.readAsString());

    final dependencies = Map<String, dynamic>.from(yaml['dependencies'] ?? {});
    final devDependencies = Map<String, dynamic>.from(yaml['dev_dependencies'] ?? {});
    final environment = Map<String, dynamic>.from(yaml['environment'] ?? {});

    List<Conflict> conflicts = [];

    // 1. Detect same package in both dependencies and dev_dependencies
    for (final key in devDependencies.keys) {
      if (dependencies.containsKey(key)) {
        conflicts.add(
          Conflict(
            type: ConflictType.DEV_VS_RUNTIME,
            package: key,
            message: 'Exists in both dependencies and dev_dependencies.',
            suggestion: 'Keep only one entry based on actual usage.',
          ),
        );
      }
    }

    // 2. Detect over-pinned versions (e.g. exact versions)
    for (final entry in [...dependencies.entries, ...devDependencies.entries]) {
      final key = entry.key;
      final value = entry.value;
      if (value is String && RegExp(r'^\d+\.\d+\.\d+$').hasMatch(value)) {
        conflicts.add(
          Conflict(
            type: ConflictType.SRTICT_VERSION_PINNING,
            package: key,
            message: 'Version "$value" is too strict (no updates allowed).',
            suggestion: 'Use ^$value to allow bugfix updates.',
          ),
        );
      }
    }

    // 3. Check SDK constraint conflicts
    if (environment.containsKey('sdk')) {
      final sdk = environment['sdk'];
      if (sdk.toString().contains('<') && !sdk.toString().contains('>=3.0.0')) {
        conflicts.add(
          Conflict(
            type: ConflictType.SDK_CONSTRAINT,
            package: 'dart SDK',
            message: 'Minimum version constraint is below 3.0.0',
            suggestion: 'Update SDK to ">=3.0.0 <4.0.0" if your packages support it.',
          ),
        );
      }
    }

    // (Advanced): pubspec.lock inspection can be added here later

    return conflicts;
  }
}