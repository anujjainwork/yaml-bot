import '../../data/services/pubspec_service.dart';

class RemoveDependencyUseCase {
  final PubspecService service;

  RemoveDependencyUseCase(this.service);

  Future<void> execute(String package) async {
    final pubspec = await service.readPubspec();

    final dependencies = Map<String, dynamic>.from(pubspec['dependencies'] ?? {});
    final devDependencies = Map<String, dynamic>.from(pubspec['dev_dependencies'] ?? {});

    final wasInDependencies = dependencies.remove(package) != null;
    final wasInDevDependencies = devDependencies.remove(package) != null;

    if (!wasInDependencies && !wasInDevDependencies) {
      print('⚠️  Package "$package" not found in dependencies.');
      return;
    }

    pubspec['dependencies'] = dependencies;
    pubspec['dev_dependencies'] = devDependencies;

    await service.writePubspec(pubspec);

    print('Removed "$package" from pubspec.yaml.');
  }
}