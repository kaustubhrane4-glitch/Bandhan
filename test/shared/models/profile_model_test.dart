import 'package:flutter_test/flutter_test.dart';
import 'package:bandhan/shared/models/profile_model.dart';

void main() {
  group('ProfileModel Tests', () {
    test('fromJson should return a valid ProfileModel', () {
      final json = {
        'id': '123',
        'full_name': 'John Doe',
        'gender': 'male',
        'date_of_birth': '1995-01-01',
        'religion': 'Hindu',
        'mother_tongue': 'Hindi',
        'city': 'Mumbai',
        'profession': 'Engineer',
        'is_verified': true,
        'plan': 'premium',
      };

      final profile = ProfileModel.fromJson(json);

      expect(profile.fullName, 'John Doe');
      expect(profile.isVerified, true);
      expect(profile.dateOfBirth.year, 1995);
    });

    test('toJson should return a valid Map', () {
      final profile = ProfileModel(
        id: '123',
        fullName: 'John Doe',
        gender: 'male',
        dateOfBirth: DateTime(1995, 1, 1),
        religion: 'Hindu',
        motherTongue: 'Hindi',
        city: 'Mumbai',
        profession: 'Engineer',
        isVerified: true,
      );

      final json = profile.toJson();

      expect(json['full_name'], 'John Doe');
      expect(json['is_verified'], true);
      expect(json['date_of_birth'], '1995-01-01');
    });
  });
}
