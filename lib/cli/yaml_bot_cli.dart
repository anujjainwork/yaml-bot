import 'package:yaml_bot/domain/usecases/add_dependency.dart';
import 'package:yaml_bot/domain/usecases/detect_conflicts.dart';
import 'package:yaml_bot/domain/usecases/removedependency.dart';

class YamlBotCli {
  final AddDependencyUseCase addUseCase;
  final RemoveDependencyUseCase removeUseCase;
  final DetectConflictsUseCase detectConflictsUseCase;

  YamlBotCli({
    required this.addUseCase,
    required this.removeUseCase,
    required this.detectConflictsUseCase
  });

  Future<void> run(List<String> args) async {
    if (args.isEmpty) {
      print('No command provided.\nTry: `add` or `remove`');
      return;
    }

    final command = args[0];

    switch (command) {
      case 'add':
        if (args.length < 2) {
          print('Usage: add <package> [version] [--dev]');
          return;
        }

        final package = args[1];
        final version = args.length >= 3 && !args[2].startsWith('--') ? args[2] : null;
        final isDev = args.contains('--dev');

        await addUseCase.execute(package, version: version, isDev: isDev);
        break;

      case 'remove':
        if (args.length < 2) {
          print('Usage: remove <package>');
          return;
        }
        final package = args[1];
        await removeUseCase.execute(package);
        break;
      
      case 'conflicts':
        await detectConflictsUseCase.execute();
        break;

      default:
        print('Unknown command: $command');
    }
  }
}