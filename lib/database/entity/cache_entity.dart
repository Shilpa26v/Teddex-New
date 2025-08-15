import 'package:floor/floor.dart';

@Entity(tableName: CacheEntity.tableName)
class CacheEntity {
  @PrimaryKey(autoGenerate: false)
  final String key;
  final int date;
  final String content;
  final String url;

  static const tableName = "cache_data";

  CacheEntity({
    required this.key,
    int? date,
    required this.url,
    required this.content,
  }) : date = date ?? DateTime.now().millisecondsSinceEpoch;
}
