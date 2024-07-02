import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/talk.dart';
import 'models/relatedTalk.dart';

Future<List<Talk>> initEmptyList() async {

  Iterable list = json.decode("[]");
  var talks = list.map((model) => Talk.fromJSON(model)).toList();
  return talks;

}

Future<List<Talk>> getTalksByTag(String tag, int page) async {
  var url = Uri.parse('https://st9ypsnnt5.execute-api.us-east-1.amazonaws.com/default/Get_talks_by_tag');

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'tag': tag,
      'page': page,
      'doc_per_page': 6
    }),
  );
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    var talks = list.map((model) => Talk.fromJSON(model)).toList();
    return talks;
  } else {
    throw Exception('Failed to load talks');
  }
      
} 

Future<List<RelatedTalk>> getWatchNextByIDx(String id, int page) async {
  var url = Uri.parse('https://aoypr8ws59.execute-api.us-east-1.amazonaws.com/default/Get_Watch_Next_by_Idx');

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'id': id,
      'page': page,
      'doc_per_page': 6
    }),
  );
  if (response.statusCode == 200) {
    Iterable list = json.decode(response.body);
    var relTalks = list.map((model) => RelatedTalk.fromJSON(model)).toList();
    return relTalks;
  } else {
    throw Exception('Failed to load talks');
  }
      
} 