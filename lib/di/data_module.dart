import 'package:injectable/injectable.dart';

import '../data/data_sources/local/app_database.dart';
import '../data/data_sources/local/daos/history_dao.dart';

@module
abstract class DataModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @singleton
  HistoryDao historyDao(AppDatabase db) => db.historyDao;
}
