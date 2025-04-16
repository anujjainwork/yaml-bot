import 'package:yaml_bot/core/api/pubdev_client.dart';
import 'package:yaml_bot/data/services/conflict_detector_service.dart';
import 'package:yaml_bot/data/services/pubspec_service.dart';
import 'package:yaml_bot/cli/yaml_bot_cli.dart';
import 'package:yaml_bot/domain/usecases/add_dependency.dart';
import 'package:yaml_bot/domain/usecases/detect_conflicts.dart';
import 'package:yaml_bot/domain/usecases/removedependency.dart';

void main(List<String> arguments) async {
  final pubspecService = PubspecService();
  final pubDevClient = PubDevClient();
  final detectConflictService = ConflictDetectorService();

  final addUseCase = AddDependencyUseCase(pubspecService, pubDevClient);
  final removeUseCase = RemoveDependencyUseCase(pubspecService);
  final detectConflictUseCase = DetectConflictsUseCase(detectConflictService);

  final cli = YamlBotCli(
    addUseCase: addUseCase,
    removeUseCase: removeUseCase,
    detectConflictsUseCase: detectConflictUseCase
  );

  await cli.run(arguments);
}