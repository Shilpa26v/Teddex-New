import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:teddex/database/dao/dao.dart';
import 'package:teddex/database/entity/entity.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [CacheEntity])
abstract class AppDatabase extends FloorDatabase {
  static Future<AppDatabase> getInstance(String databaseName) async {
    var instance = await $FloorAppDatabase.databaseBuilder(databaseName).addCallback(_databaseCallBack).build();
    return instance;
  }

  static final _databaseCallBack = Callback(
    onOpen: (database) async {
      await database.delete(
        CacheEntity.tableName,
        where: "date <= ?",
        whereArgs: [DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch],
      );
    },
  );

  CacheDao get cacheDao;
}
