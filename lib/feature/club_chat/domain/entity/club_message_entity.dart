import 'package:equatable/equatable.dart';

/// Club message entity for chat messages
class ClubMessageEntity extends Equatable {
  const ClubMessageEntity({
    required this.id,
    required this.clubId,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  final String id;
  final String clubId;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;

  @override
  List<Object?> get props => <Object?>[
    id,
    clubId,
    senderId,
    senderName,
    message,
    timestamp,
  ];
}
