import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:peace/dataBaseProviders/testResultsController.dart';

class TestHistoryGetController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwcrtG2fiqdKWcl1twFmdumZVd41KDAdF6ZJEBh5_JYDVsQG9g/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void getHistory(
      TestHistory account, void Function(String, TestResultModel) callback) async {
    try {
      await http.post(Uri.parse(URL), body: account.toJson()).then((response) async {
        if (response.statusCode == 302) {
          String url = response.headers['location'] ?? " ";
          await http.get(Uri.parse(url)).then((response) {
            callback(convert.jsonDecode(response.body)['status'], TestResultModel.fromJson(convert.jsonDecode(response.body)));
          });}
        else {
          callback(convert.jsonDecode(response.body)['status'],
              TestResultModel.fromJson(convert.jsonDecode(response.body)));
        }
      });
    } catch (e) {
      print("Error $e");
    }
  }
}


class TestHistory {
  String registerNumber;

  TestHistory(this.registerNumber);

  factory TestHistory.fromJson(dynamic json) {
    return TestHistory("${json['registerNumber']}");
  }

  // Method to make GET parameters.
  Map toJson() => {'registerNumber': registerNumber};
}

