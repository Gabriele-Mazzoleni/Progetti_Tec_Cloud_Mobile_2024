class UserData{
  final String mail;
  final String username;
  final String password;
  final String status;

 UserData({
    required this.mail,
    required this.username,
    required this.password,
    required this.status,
  });

  UserData.fromJSON(Map<String, dynamic> jsonMap) :
    status= jsonMap['Message'],
    mail = jsonMap['Mail'],
    username = (jsonMap['Username'] ?? ""),
    password = (jsonMap['Password'] ?? "");

}

