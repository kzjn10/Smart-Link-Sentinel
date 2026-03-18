import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/history_dao.dart';
import 'tables/history_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Historys], daos: [HistoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ai_deeplink_db');
  }
}