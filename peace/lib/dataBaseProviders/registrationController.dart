import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class StudentRegisterController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyzxxPO3l5EWPvq-B-fleaKnmdfmUjQqP2WK42LpY32uNYPgj2O/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addStudent(
      RegisterStudent itemForm, void Function(String) callback) async {
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

  Future<List<RegisterStudent>> getStudentList() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => RegisterStudent.fromJson(json)).toList();
    });
  }
}

class RegisterStudent {
  String email;
  String name;
  String registerNumber;
  String gender;
  String sslc;
  String hsc;
  String income;
  String hobbies;

  RegisterStudent(
      this.email,
      this.name,
      this.registerNumber,
      this.gender,
      this.sslc,
      this.hsc,
      this.income,
      this.hobbies);

  factory RegisterStudent.fromJson(dynamic json) {
    return RegisterStudent(
        "${json['email'].toString()}",
        "${json['name'].toString()}",
        "${json['registerNumber'].toString()}",
        "${json['gender'].toString()}",
        "${json['sslc'].toString()}",
        "${json['hsc'].toString()}",
        "${json['income'].toString()}",
        "${json['hobbies'].toString()}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        "email": email,
        "name": name,
        "registerNumber": registerNumber,
        "gender": gender,
        "sslc": sslc,
        "hsc": hsc,
        "income": income,
        "hobbies": hobbies
      };
}