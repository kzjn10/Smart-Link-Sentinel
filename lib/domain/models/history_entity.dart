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
}
