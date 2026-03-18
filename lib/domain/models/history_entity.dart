class HistoryEntity {
  final String id;
  final String link;
  final DateTime updatedAt;
  final bool isFavorite;

  HistoryEntity({
    required this.id,
    required this.link,
    required this.updatedAt,
    required this.isFavorite,
  });

  HistoryEntity copyWith({
    String? id,
    String? link,
    DateTime? updatedAt,
    bool? isFavorite,
  }) {
    return HistoryEntity(
      id: id ?? this.id,
      link: link ?? this.link,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
