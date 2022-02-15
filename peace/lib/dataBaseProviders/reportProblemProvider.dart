import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class ReportProblemController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycby9mBmqcy13tBmX9CkVKQq56Y6B_Lv6xy6bsg0BQqkPkTN6vMs/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addProblem(
      Problem itemForm, void Function(String) callback) async {
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

  Future<List<Problem>> getProblemList() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => Problem.fromJson(json)).toList();
    });
  }
}

class Problem {
  String date;
  String summary;
  String description;
  String status;


  Problem(
      this.date,
      this.summary,
      this.description,
      this.status);

  factory Problem.fromJson(dynamic json) {
    return Problem(
        "${json['date']}",
        "${json['password']}",
        "${json['description']}",
        "${json['status']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    "date": date,
    "summary": summary,
    "description": description,
    "status": status
  };
}