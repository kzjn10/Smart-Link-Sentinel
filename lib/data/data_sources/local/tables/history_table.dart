import 'package:drift/drift.dart';

@DataClassName('HistoryEntry')
class Historys extends Table {
  TextColumn get id => text()();
  TextColumn get link => text().unique()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
