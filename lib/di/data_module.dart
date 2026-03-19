
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../data/data_sources/local/app_database.dart';
import '../data/data_sources/local/daos/history_dao.dart';

@module
abstract class DataModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @singleton
  HistoryDao historyDao(AppDatabase db) => db.historyDao;

  @preResolve
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

}
