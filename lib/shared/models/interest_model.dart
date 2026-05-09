class InterestModel {
  final String id;
  final String fromUser;
  final String toUser;
  final String status; // 'sent', 'accepted', 'declined'
  final String? message;
  final DateTime createdAt;

  InterestModel({
    required this.id,
    required this.fromUser,
    required this.toUser,
    required this.status,
    this.message,
    required this.createdAt,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: json['id'],
      fromUser: json['from_user'],
      toUser: json['to_user'],
      status: json['status'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
