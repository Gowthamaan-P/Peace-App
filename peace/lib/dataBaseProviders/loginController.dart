import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class StudentLoginRegisterController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxmHc2QlKqfKD6zkw4WDB5LdQB6Eca_m6izSPm7zHwhvLKFkrI/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addStudent(
      LoginRegister itemForm, void Function(String) callback) async {
    try {
      await http
          .post(Uri.parse(URL), body: itemForm.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          String url = response.headers['location'] ?? " ";
          await http.get(Uri.parse(url)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print("Error $e");
    }
  }

  Future<List<LoginRegister>> getStudentList() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => LoginRegister.fromJson(json)).toList();
    });
  }
}

class LoginRegister {
  String registerNumber;
  String password;


  LoginRegister(
      this.registerNumber,
      this.password);

  factory LoginRegister.fromJson(dynamic json) {
    return LoginRegister(
        "${json['registerNumber']}",
        "${json['password']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    "registerNumber": registerNumber,
    "password": password
  };
}