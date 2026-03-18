import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/history_table.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [Historys])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  Future<List<HistoryEntry>> getAllHistory() => (select(historys)
        ..orderBy([
          (t) =>
              OrderingTerm(expression: t.isFavorite, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
        ]))
      .get();

  Stream<List<HistoryEntry>> watchAllHistory() => (select(historys)
        ..orderBy([
          (t) =>
              OrderingTerm(expression: t.isFavorite, mode: OrderingMode.desc),
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
        ]))
      .watch();

  Future<int> insertHistory(HistorysCompanion entry) =>
      into(historys).insert(entry, mode: InsertMode.insertOrReplace);

  Future<void> upsertHistory(HistorysCompanion entry) =>
      into(historys).insert(entry, onConflict: DoUpdate((old) => HistorysCompanion(updatedAt: entry.updatedAt)));

  Future<int> deleteHistory(String id) => (delete(historys)..where((t) => t.id.equals(id))).go();

  Future<int> clearHistory() => delete(historys).go();

  Future<bool> updateHistory(HistoryEntry entry) => update(historys).replace(entry);

  Future<HistoryEntry?> getHistoryByLink(String url) => (select(historys)
        ..where((t) => t.link.equals(url))
        ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();
}
