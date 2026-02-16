import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/ambulance_model.dart';
import '../../../../data/repositories/ambulance_repository.dart';

final availableAmbulancesProvider = FutureProvider<List<AmbulanceModel>>((
  ref,
) async {
  final repository = ref.read(ambulanceRepositoryProvider);
  return await repository.getAvailableAmbulances();
});
