import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/history_dao.dart';
import 'tables/history_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Historys], daos: [HistoryDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // 1. Clean up duplicate links, keeping the most recent one
          await customStatement('''
            DELETE FROM historys 
            WHERE id NOT IN (
              SELECT id FROM (
                SELECT id, ROW_NUMBER() OVER (PARTITION BY link ORDER BY updated_at DESC) as row_num
                FROM historys
              ) WHERE row_num = 1
            )
          ''');
          // 2. Apply the new schema with the unique constraint
          await m.alterTable(TableMigration(historys));
        }
      },
      beforeOpen: (details) async {
        if (details.wasCreated) {
          // Perform any initial setup if needed
        }
      },
    );
  }
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ai_deeplink_db');
  }
}