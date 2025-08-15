import 'package:floor/floor.dart';
import 'package:teddex/database/entity/cache_entity.dart';

@dao
abstract class CacheDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addCache(CacheEntity entity);

  @Query('SELECT * from ${CacheEntity.tableName} WHERE key = :key')
  Future<CacheEntity?> getCacheResponse(String key);

  @Query('DELETE from ${CacheEntity.tableName}')
  Future<CacheEntity?> clearAll();
}
