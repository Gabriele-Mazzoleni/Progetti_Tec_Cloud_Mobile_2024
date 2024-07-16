import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tedxtok/Models/userData.dart';

Future<UserData> userSearcher(String mail, String password) async {
  var url = Uri.parse('https://9197m0jcsh.execute-api.us-east-1.amazonaws.com/default/TedTok_Login');

  final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'mail': mail,
      'password': password,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');  
  
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data is Map<String, dynamic>) {
      var user=UserData.fromJSON(data);
      return user;
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('User not found');
  }
}

Future<UserData> userAdder(String mail, String username, String password) async {
  var url = Uri.parse('https://zymt92di2m.execute-api.us-east-1.amazonaws.com/default/TedTok_SignIn');

   final http.Response response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, Object>{
      'mail': mail,
      'username': username,
      'password': password,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');  

  if (response.statusCode == 200) {
    var user= UserData(
      mail: mail,
      username: username,
      password: password,
      status: 'Success'
    );
    return user;
    
  } else {
    throw Exception('Invalid credentials');
  }
}