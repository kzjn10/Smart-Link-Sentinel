import 'package:injectable/injectable.dart';

import '../data/datasources/local/app_database.dart';
import '../data/datasources/local/daos/history_dao.dart';

@module
abstract class DataModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @singleton
  HistoryDao historyDao(AppDatabase db) => db.historyDao;
}
