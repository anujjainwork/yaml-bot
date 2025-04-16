import 'package:yaml_bot/core/models/conflict_type_enum.dart';

class Conflict {
  final ConflictType type;
  final String package;
  final String message;
  final String suggestion;

  Conflict({
    required this.type,
    required this.package,
    required this.message,
    required this.suggestion,
  });

  @override
  String toString() {
    return '''
⚠️ Conflict Detected:
- Type: $type
- Package: $package
- Issue: $message
- Suggestion: $suggestion
''';
  }
}