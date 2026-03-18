import 'package:drift/drift.dart';

@DataClassName('HistoryEntry')
class Historys extends Table {
  TextColumn get id => text()();
  TextColumn get link => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
