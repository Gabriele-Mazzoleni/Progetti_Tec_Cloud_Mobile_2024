import 'package:mongo_dart/mongo_dart.dart';

class TopicItem {
  final String tag;

  TopicItem({required this.tag});
}
class Database {
  static late Db _db;

  static Future<void> init() async {
    _db = Db('mongodb+srv://gmasinari:-PNDMDB-@mycluster.fvvxa1s.mongodb.net/unibg_tedx_2024');
    await _db.open();
  }

  static Future<List<TopicItem>> getTopics() async {
    final collection = _db.collection('TedTok_tag');
    final cursor = await collection.find().toList();
    return cursor
        .map((doc) => TopicItem(
              tag: doc['_id'],
              
            ))
        .toList();
  }
}
