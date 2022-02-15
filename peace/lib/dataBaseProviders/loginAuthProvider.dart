import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:peace/dataBaseProviders/registrationController.dart';

class AuthenticationController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbz8aOhguxoaeGhPJBVQNkp8vWRM7SF5v6DQ2huED9EU8RNgDpQ/exec";

  static const STATUS_SUCCESS = "SUCCESS";
  static const STATUS_FAILED = "FAILED";

  void verifyUser(
      LoginAccount account, void Function(String, RegisterStudent) callback) async {
    try {
      await http.post(Uri.parse(URL), body: account.toJson()).then((response) async {
        if (response.statusCode == 302) {
          String url = response.headers['location'] ?? " ";
          await http.get(Uri.parse(url)).then((response) {
            callback(convert.jsonDecode(response.body)['status'], RegisterStudent.fromJson(convert.jsonDecode(response.body)));
          });}
        else {
          callback(convert.jsonDecode(response.body)['status'],
              RegisterStudent.fromJson(convert.jsonDecode(response.body)));
        }
      });
    } catch (e) {
      print("Error $e");
    }
  }
}

///Inward Form model
class LoginAccount {
  String registerNumber;
  String password;

  LoginAccount(this.registerNumber, this.password);

  factory LoginAccount.fromJson(dynamic json) {
    return LoginAccount(
      "${json['registerNumber']}",
      "${json['password']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
    'registerNumber': registerNumber,
    'password': password
  };
}

