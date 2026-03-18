import 'package:drift/drift.dart';
import '../../domain/models/history_entity.dart';
import '../data_sources/local/app_database.dart';

extension HistoryEntryMapper on HistoryEntry {
  HistoryEntity toDomain() => HistoryEntity(
        id: id,
        link: link,
        updatedAt: updatedAt,
        isFavorite: isFavorite,
      );
}

extension HistoryEntityMapper on HistoryEntity {
  HistoryEntry toData() => HistoryEntry(
        id: id,
        link: link,
        updatedAt: updatedAt,
        isFavorite: isFavorite,
      );

  HistorysCompanion toCompanion() => HistorysCompanion.insert(
        id: id,
        link: link,
        updatedAt: updatedAt,
        isFavorite: Value(isFavorite),
      );
}
