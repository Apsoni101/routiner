import 'package:routiner/feature/home/domain/entity/club_entity.dart';

/// Club model for data layer
class ClubModel extends ClubEntity {
  const ClubModel({
    required super.id,
    required super.name,
    required super.description,
    required super.creatorId,
    required super.createdAt,
    required super.memberIds,
    required super.pendingRequestIds,
    super.imageUrl,
  });

  factory ClubModel.fromFirestore({required final Map<String, dynamic> data}) {
    return ClubModel(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      creatorId: data['creatorId']?.toString() ?? '',
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'].toString())
          : DateTime.now(),
      memberIds:
          (data['memberIds'] as List<dynamic>?)
              ?.map((final e) => e.toString())
              .toList() ??
          <String>[],
      pendingRequestIds:
          (data['pendingRequestIds'] as List<dynamic>?)
              ?.map((final e) => e.toString())
              .toList() ??
          <String>[],
      imageUrl: data['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'creatorId': creatorId,
    'createdAt': createdAt.toIso8601String(),
    'memberIds': memberIds,
    'pendingRequestIds': pendingRequestIds,
    'imageUrl': imageUrl,
  };
}
