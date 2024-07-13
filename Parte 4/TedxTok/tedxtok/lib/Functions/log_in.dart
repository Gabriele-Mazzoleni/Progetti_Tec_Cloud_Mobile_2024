import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tedxtok/Models/userData.dart';

Future<UserData> userSearcher(String mail, String password) async {
  var url = Uri.parse('https://j962apid8l.execute-api.us-east-1.amazonaws.com/default/get_talk_list_by_tags');

  final http.Response response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'mail': mail,
      'password':password
    }),
  );
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var user = UserData.fromJSON(data);
    return user;
  } else {
    throw Exception('User not found');
  }
      
} 