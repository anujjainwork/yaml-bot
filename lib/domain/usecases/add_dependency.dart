import 'package:yaml_bot/core/api/pubdev_client.dart';

import '../../data/services/pubspec_service.dart';

class AddDependencyUseCase {
  final PubspecService service;
  final PubDevClient pubDevClient;

  AddDependencyUseCase(this.service, this.pubDevClient);

  Future<void> execute(String package, {String? version, bool isDev = false}) async {
    final resolvedVersion = version ?? await pubDevClient.getLatestVersion(package);
    if (resolvedVersion == null) {
      print('Could not find $package on pub.dev.');
      return;
    }

    final pubspec = await service.readPubspec();

    final targetSection = isDev ? 'dev_dependencies' : 'dependencies';
    final section = Map<String, dynamic>.from(pubspec[targetSection] ?? {});
    
    if (section.containsKey(package)) {
      print('"$package" already exists in $targetSection.');
      return;
    }

    section[package] = '^$resolvedVersion';
    pubspec[targetSection] = section;

    await service.writePubspec(pubspec);
    print('Added $package:^$resolvedVersion to $targetSection.');
  }
}