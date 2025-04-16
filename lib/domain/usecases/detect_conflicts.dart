import '../../data/services/conflict_detector_service.dart';

class DetectConflictsUseCase {
  final ConflictDetectorService service;

  DetectConflictsUseCase(this.service);

  Future<void> execute() async {
    final conflicts = await service.detectConflicts();

    if (conflicts.isEmpty) {
      print('No conflicts found!');
    } else {
      for (final conflict in conflicts) {
        print(conflict);
      }
    }
  }
}