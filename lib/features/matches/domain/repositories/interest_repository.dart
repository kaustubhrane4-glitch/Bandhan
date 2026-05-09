import '../../../shared/models/interest_model.dart';

abstract class InterestRepository {
  Future<void> sendInterest(String toUserId, {String? message});
  Future<void> updateInterestStatus(String interestId, String status);
  Stream<List<InterestModel>> watchReceivedInterests();
  Stream<int> watchReceivedCount();
}
