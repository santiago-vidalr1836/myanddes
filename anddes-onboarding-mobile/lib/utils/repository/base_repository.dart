import 'package:mi_anddes_mobile_app/utils/mapeable_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../constants.dart';

abstract class BaseRepository<T extends MapeableEntity> {
  abstract String tableName;
  String defaultOrderBy="id";

  T? mapQueryToEntity(List<Map<String, Object?>> map);
  List<T>? mapQueryToEntities(List<Map<String, Object?>> map);

  Future<void> add(T entity) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.insert(
      tableName,
      entity.toTableMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> addAll(List<T> entities) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var entity in entities) {
      await db.insert(
        tableName,
        entity.toTableMap(),
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

  Future<List<T>?> findAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> maps;
    if(defaultOrderBy.isNotEmpty) {
      maps =await db.query(tableName, orderBy: defaultOrderBy);
    }else{
      maps =await db.query(tableName);
    }
    return mapQueryToEntities(maps);
  }

  Future<T?> findFirst() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> maps = await db.query(tableName);

    return mapQueryToEntity(maps);
  }

  Future<void> updateById(T entity) async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.update(tableName, entity.toTableMap(),
        where: "id = ?", whereArgs: [entity.getId()]);
  }

  Future<List<T>?> findByFilters(
      String? where, List<Object?>? whereArgs) async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    final List<Map<String, Object?>> maps =
        await db.query(tableName, where: where, whereArgs: whereArgs);
    return mapQueryToEntities(maps);
  }
}
