import 'package:equatable/equatable.dart';

class ClubEntity extends Equatable {
  const ClubEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.createdAt,
    required this.memberIds,
    required this.pendingRequestIds,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String creatorId;
  final DateTime createdAt;
  final List<String> memberIds;
  final List<String> pendingRequestIds;
  final String? imageUrl;

  bool isCreator(final String userId) => creatorId == userId;

  bool isMember(final String userId) => memberIds.contains(userId);

  bool hasPendingRequest(final String userId) =>
      pendingRequestIds.contains(userId);

  ClubEntity copyWith({
    final String? id,
    final String? name,
    final String? description,
    final String? creatorId,
    final DateTime? createdAt,
    final List<String>? memberIds,
    final List<String>? pendingRequestIds,
    final String? imageUrl,
  }) {
    return ClubEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      pendingRequestIds: pendingRequestIds ?? this.pendingRequestIds,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => <Object?>[
    id,
    name,
    description,
    creatorId,
    createdAt,
    memberIds,
    pendingRequestIds,
    imageUrl,
  ];
}
