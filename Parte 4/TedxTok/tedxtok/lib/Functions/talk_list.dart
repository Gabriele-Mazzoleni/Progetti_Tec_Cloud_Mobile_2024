import 'dart:convert';
import 'package:tedxtok/Models/Talk.dart';
import 'package:http/http.dart' as http;

Future<List<Talk>> initEmptyList() async {

  Iterable list = json.decode("[]");
  var talks = list.map((model) => Talk.fromJSON(model)).toList();
  return talks;

}

Future<List<Talk>> getTalkstByTagList(List tags) async {
  var url = Uri.parse('https://kz0253u01m.execute-api.us-east-1.amazonaws.com/default/Get_Talk_List_By_Tags');

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'tags': tags,
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