// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRepositoryHash() => r'ca0c3391d76bf40be6f96ab42e1060bcbf275a38';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$myProfileHash() => r'de334701bd8dab31898f23a1d0ef9b99368019fc';

/// See also [myProfile].
@ProviderFor(myProfile)
final myProfileProvider = AutoDisposeFutureProvider<ProfileModel?>.internal(
  myProfile,
  name: r'myProfileProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myProfileHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyProfileRef = AutoDisposeFutureProviderRef<ProfileModel?>;
String _$dailyMatchesHash() => r'a0547c01301189caba975ed5d43e9e03e2bcf41c';

/// See also [dailyMatches].
@ProviderFor(dailyMatches)
final dailyMatchesProvider =
    AutoDisposeFutureProvider<List<ProfileModel>>.internal(
  dailyMatches,
  name: r'dailyMatchesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dailyMatchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DailyMatchesRef = AutoDisposeFutureProviderRef<List<ProfileModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
