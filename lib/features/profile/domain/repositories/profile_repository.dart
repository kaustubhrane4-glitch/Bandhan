import '../../../shared/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> getMyProfile();
  Future<void> updateProfile(ProfileModel profile);
  Future<List<ProfileModel>> getDailyMatches();
  Future<List<ProfileModel>> searchProfiles({
    int? minAge,
    int? maxAge,
    List<String>? religions,
    List<String>? cities,
  });
}
