import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../model/service.dart';

class ServiceRepository {
  String tableName = 'services';
  String tableDetailName = 'services_detail';

  Future<void> addAll(List<Service> services) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var service in services) {
      await db.insert(
        tableName,
        service.toTableMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (service.details != null && service.details!.isNotEmpty) {
        addDetailAll(service, service.details!);
      }
    }
  }

  Future<void> addDetailAll(
      Service service, List<ServiceDetail> servicesDetail) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var detail in servicesDetail) {
      await db.insert(
        tableDetailName,
        detail.toTableMap(service.id),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    await db.delete(
      tableDetailName,
      where: '1 = 1',
    );
    await db.delete(
      tableName,
      where: '1 = 1',
    );
  }

  Future<List<Service>> findAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> serviceMaps =
        await db.query(tableName, orderBy: 'position');

    List<Map<String, Object?>> detailMaps;
    List<Service> list = [];
    for (final {
          'id': id as int,
          'name': name as String?,
          'description': description as String?,
          'icon': icon as String?,
          'position':position as int?
        } in serviceMaps) {
      detailMaps = await db
          .query(tableDetailName, where: ' service_id = ? and hidden= ?', whereArgs: [id,0],orderBy: 'id');

      var details = [
        for (final {
              'id': id as int,
              'description': description as String?,
              'title': title as String?,
              'icon': icon as String?,
              'hidden': hidden as int
            } in detailMaps)
          ServiceDetail(id: id, description: description, title: title,icon: icon,hidden:hidden==1),
      ];

      list.add(Service(
          id: id,
          name: name,
          description: description,
          icon: icon,
          details: details));
    }
    return list;
  }
  /*@override
  List<Service>? mapQueryToEntities(List<Map<String, Object?>> map) {
    return [
      for (final {
      'id': id as int,
      'name': name as String,
      'description': description as String,
      'fontIcon': fontIcon as String
      } in map)
        Service(id: id, name: name, description: description, fontIcon : fontIcon),
    ];
  }

  @override
  Service? mapQueryToEntity(List<Map<String, Object?>> map) {
    Service? service;
    for (final {
    'id': id as int,
    'name': name as String,
    'description': description as String,
    'fontIcon': fontIcon as String
    } in map) {
      service=Service(id: id, name: name, description: description, fontIcon: fontIcon)
    }
    return service;
  }*/
}
