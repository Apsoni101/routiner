import 'package:routiner/feature/club_chat/domain/entity/club_message_entity.dart';

/// Club message model for data layer
class ClubMessageModel extends ClubMessageEntity {
  const ClubMessageModel({
    required super.id,
    required super.clubId,
    required super.senderId,
    required super.senderName,
    required super.message,
    required super.timestamp,
  });

  factory ClubMessageModel.fromFirestore({
    required final Map<String, dynamic> data,
  }) {
    return ClubMessageModel(
      id: data['id']?.toString() ?? '',
      clubId: data['clubId']?.toString() ?? '',
      senderId: data['senderId']?.toString() ?? '',
      senderName: data['senderName']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.parse(data['timestamp'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'clubId': clubId,
    'senderId': senderId,
    'senderName': senderName,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };
}
