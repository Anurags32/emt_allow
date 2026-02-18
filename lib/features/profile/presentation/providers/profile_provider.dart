import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/profile_model.dart';
import '../../../../data/repositories/profile_repository.dart';

final profileProvider = FutureProvider.autoDispose<ProfileModel>((ref) async {
  final repository = ref.read(profileRepositoryProvider);
  return await repository.getProfileInfo();
});
