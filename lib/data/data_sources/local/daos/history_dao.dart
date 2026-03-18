import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/history_table.dart';

part 'history_dao.g.dart';

@DriftAccessor(tables: [Historys])
class HistoryDao extends DatabaseAccessor<AppDatabase> with _$HistoryDaoMixin {
  HistoryDao(super.db);

  Future<List<HistoryEntry>> getAllHistory() => select(historys).get();

  Stream<List<HistoryEntry>> watchAllHistory() => 
      (select(historys)..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)])).watch();

  Future<int> insertHistory(HistorysCompanion entry) => into(historys).insert(entry, mode: InsertMode.insertOrReplace);

  Future<int> deleteHistory(String id) => (delete(historys)..where((t) => t.id.equals(id))).go();

  Future<int> clearHistory() => delete(historys).go();

  Future<bool> updateHistory(HistoryEntry entry) => update(historys).replace(entry);
}
