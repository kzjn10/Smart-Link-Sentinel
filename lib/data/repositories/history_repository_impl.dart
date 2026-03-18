import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/history_entity.dart';
import '../../domain/repositories/history_repository.dart';
import '../data_sources/local/app_database.dart';
import '../data_sources/local/daos/history_dao.dart';
import '../mapper/history_mapper.dart';

@Injectable(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryDao _historyDao;
  final Uuid _uuid = const Uuid();

  HistoryRepositoryImpl(this._historyDao);

  @override
  Stream<List<HistoryEntity>> watchHistory() {
    return _historyDao.watchAllHistory().map(
          (entries) => entries.map((e) => e.toDomain()).toList(),
        );
  }

  @override
  Future<void> addHistory(String link) async {
    await _historyDao.upsertHistory(
      HistorysCompanion.insert(
        id: _uuid.v4(),
        link: link,
        updatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> clearHistory() {
    return _historyDao.clearHistory();
  }

  @override
  Future<void> deleteHistory(String id) {
    return _historyDao.deleteHistory(id);
  }

  @override
  Future<void> toggleFavorite(HistoryEntity entry) {
    return _historyDao.updateHistory(
      entry.copyWith(isFavorite: !entry.isFavorite, updatedAt: DateTime.now()).toData(),
    );
  }
}
