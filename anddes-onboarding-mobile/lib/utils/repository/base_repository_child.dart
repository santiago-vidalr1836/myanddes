import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants.dart';

abstract class BaseRepository<T extends MapeableEntityWithParentId> {
  abstract String tableName;

  T mapQueryToEntity(List<Map<String, Object?>> map);
  List<T> mapQueryToEntities(List<Map<String, Object?>> map);

  Future<void> addWithParentId(int parentId, T entity) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.insert(
      tableName,
      entity.toTableMap(parentId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addAllWithParentId(int parentId, List<T> entities) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var entity in entities) {
      await db.insert(
        tableName,
        entity.toTableMap(parentId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    // Remove the Dog from the database.
    await db.delete(
      tableName,
      where: '1 = 1',
    );
  }

  Future<List<T>> findAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(tableName);

    return mapQueryToEntities(maps);
  }

  Future<T> findFirst() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(tableName);

    return mapQueryToEntity(maps);
  }
}
