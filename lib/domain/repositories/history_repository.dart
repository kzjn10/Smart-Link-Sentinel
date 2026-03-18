import '../models/history_entity.dart';

abstract class HistoryRepository {
  Stream<List<HistoryEntity>> watchHistory();

  Future<void> addHistory(String link);

  Future<void> clearHistory();

  Future<void> deleteHistory(String id);

  Future<void> toggleFavorite(HistoryEntity entry);
}
