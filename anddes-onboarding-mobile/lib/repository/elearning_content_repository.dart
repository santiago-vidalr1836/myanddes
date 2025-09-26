import 'dart:async';

import 'package:mi_anddes_mobile_app/model/elearning_content.dart';
import 'package:mi_anddes_mobile_app/model/elearning_content_card_option.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../model/elearning_content_card.dart';

class ELearningContentRepository {
  String tableName = 'elearning_content';
  String tableNameCard = 'elearning_content_card';
  String tableNameOption = 'elearning_content_card_option';

  Future<void> addAll(List<ELearningContent> elearnings) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    await deleteAll(tableNameOption);
    await deleteAll(tableNameCard);
    await deleteAll(tableName);

    for (var elearning in elearnings) {
      await db.insert(
        tableName,
        elearning.toTableMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (elearning.cards != null && elearning.cards!.isNotEmpty) {
        addCardAll(elearning, elearning.cards!);
      }
      /*findById(elearning.id).then((previousELearningInserted) async{
        if (previousELearningInserted == null ||
            (!previousELearningInserted.started!)) {
            await db.insert(
              tableName,
              elearning.toTableMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            if (elearning.cards != null && elearning.cards!.isNotEmpty) {
              addCardAll(elearning, elearning.cards!);
            }
        }else{
          await db.update(tableName, {'name':elearning.name,'image':elearning.image},where: 'id=?',whereArgs: [elearning.id]);
        }
      });*/
    }
  }

  Future<ELearningContent?> findById(int id) async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> map =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    ELearningContent? eLearningContent;

    List<ELearningContentCard>cards = [];

    final List<Map<String, Object?>> cardMap = await db.query(tableNameCard, where: ' elearning_content_id = ?', whereArgs: [id],orderBy: 'position');

    for (final {
      'id': id as int,
      'title': title as String?,
      'type' : type as String?,
      'draft': draft as int?,
      'content': content as String?,
      'deleted': deleted as int?,
      'position': position as int,
      'read': read as int?,
      'date_read': dateRead as String?,
      'url_video': urlVideo as String?,
      'url_poster':urlPoster as String?
    } in cardMap) {
      final List<Map<String, Object?>> optionMap = await db.query(tableNameOption,
          where: ' elearning_content_card_id = ?', whereArgs: [id]);
      var options = [
        for (final {
        'id': id as int,
        'description': description as String?,
        'correct': correct as int?,
        'checked':checked as int?
        } in optionMap)
          ELearningContentCardOption(
              id: id, description: description, correct: correct==1,checked: checked==1)
      ];
      cards.add(ELearningContentCard(
          id: id,
          title: title,
          draft: draft == 1,
          content: content,
          position: position,
          deleted: deleted == 1,
          read: read==1,
          type: type,
          dateRead: dateRead!=null?DateTime.tryParse(dateRead):null,
          urlPoster: urlPoster,
          urlVideo: urlVideo,
          options: options));
    }

    for (final {
          'id': id as int,
          'name': name as String?,
          'image': image as String?,
          'started': started as int?,
          'finished': finished as int?,
          'progress': progress as int?,
          'result': result as int?,
          'position':position as int,
          'sent': sent as int?
        } in map) {
      eLearningContent = ELearningContent(
          id: id,
          name: name,
          image: image,
          started: started == 1,
          finished: finished == 1,
          result: result,
          position: position,
          progress:progress,
          sent: sent == 1,
          cards: cards);
    }
    return eLearningContent;
  }

  Future<void> addCardAll(ELearningContent elearningContent,
      List<ELearningContentCard> cards) async {
    // Get a reference to the database.
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var card in cards) {
      await db.insert(
        tableNameCard,
        card.toTableMap(elearningContent.id),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (card.options != null && card.options!.isNotEmpty) {
        addOptionAll(card, card.options!);
      }
    }
  }

  void addOptionAll(ELearningContentCard card,
      List<ELearningContentCardOption> options) async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    for (var option in options) {
      await db.insert(
        tableNameOption,
        option.toTableMap(card.id),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<ELearningContent>> findAll() async {
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;

    final List<Map<String, Object?>> map = await db.query(tableName,orderBy: 'position');
    List<Map<String, Object?>> cardMap;
    List<Map<String, Object?>> optionMap;

    List<ELearningContent> list = [];
    List<ELearningContentCard> cards = [];

    for (final {
          'id': id as int,
          'name': name as String?,
          'image': image as String?,
          'started': started as int?,
          'finished': finished as int?,
          'progress': progress as int?,
          'position':position as int,
          'result': result as int?,
          'sent': sent as int?
        } in map) {
      cards = [];
      cardMap = await db.query(tableNameCard,
          where: ' elearning_content_id = ?', whereArgs: [id],orderBy: 'position');
      for (final {
            'id': id as int,
            'title': title as String?,
            'type' : type as String?,
            'draft': draft as int?,
            'content': content as String?,
            'deleted': deleted as int?,
            'position': position as int,
            'read': read as int?,
            'date_read': dateRead as String?,
            'url_video': urlVideo as String?,
            'url_poster':urlPoster as String?
          } in cardMap) {
        optionMap = await db.query(tableNameOption,
            where: ' elearning_content_card_id = ?', whereArgs: [id]);
        var options = [
          for (final {
                'id': id as int,
                'description': description as String?,
                'correct': correct as int?,
                'checked':checked as int?
              } in optionMap)
            ELearningContentCardOption(
                id: id, description: description, correct: correct==1,checked: checked==1)
        ];
        cards.add(ELearningContentCard(
            id: id,
            title: title,
            draft: draft == 1,
            content: content,
            position: position,
            deleted: deleted == 1,
            read: read==1,
            type: type,
            dateRead: dateRead!=null?DateTime.tryParse(dateRead):null,
            urlVideo: urlVideo,
            urlPoster: urlPoster,
            options: options));
      }
      list.add(ELearningContent(
          id: id,
          name: name,
          image: image,
          started: started == 1,
          finished: finished == 1,
          progress: progress,
          result: result,
          position: position,
          sent: sent==1,
          cards: cards));
    }
    return list;
  }

  Future<void> updateCard(int parentId,ELearningContentCard eLearningContentCard) async{
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.update(tableNameCard, eLearningContentCard.toTableMap(parentId),
        where: "id = ?", whereArgs: [eLearningContentCard.getId()]);
  }
  Future<void> updateContent(ELearningContent eLearningContent) async{
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.update(tableName, eLearningContent.toTableMap(),
        where: "id = ?", whereArgs: [eLearningContent.getId()]);
  }
  Future<void> updateOption(int parentId,ELearningContentCardOption option) async{
    final database = openDatabase(
      join(await getDatabasesPath(), Constants.databaseName),
    );
    final db = await database;
    await db.update(tableNameOption, option.toTableMap(parentId),
        where: "id = ?", whereArgs: [option.getId()]);
  }
  Future<void> deleteAll(String tableName) async {
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
}
