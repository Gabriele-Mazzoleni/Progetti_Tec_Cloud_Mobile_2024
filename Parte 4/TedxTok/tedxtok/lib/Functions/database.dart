
import 'package:mongo_dart/mongo_dart.dart';

class Database {
  static late Db _db;

  static Future<void> init() async {
    _db = await Db.create(
        'mongodb+srv://gmasinari:-PNDMDB-@mycluster.fvvxa1s.mongodb.net/unibg_tedx_2024');
    await _db.open();
  }

  static Future<List<String>> getTopics() async {
    await init();
    var collection = _db.collection('TedTok_tag');
    var topics = await collection.find().toList();
    return topics.map<String>((doc) => doc['_id'] as String).toList();
  }
}
