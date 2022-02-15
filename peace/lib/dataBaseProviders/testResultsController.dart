import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class TestResultsControllerModel {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyN7vZM0qZD2iNUFJ7--j5P9SfMByHLcSPQVJ1S/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addTestResult(
      TestResultModel itemForm, void Function(String) callback) async {
    try {
      await http
          .post(Uri.parse(URL), body: itemForm.toJson())
          .then((response) async {
        if (response.statusCode == 302) {
          String url = response.headers['location'] ?? " ";
          await http.get(Uri.parse(url)).then((response) {
            print("${response.body}");
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

  Future<List<TestResultModel>> getTestResult() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback
          .map((json) => TestResultModel.fromJson(json))
          .toList();
    });
  }
}

class TestResultModel {
  String date;
  String registerNumber;

  String phqFifteen;
  String gadSeven;
  String phqNine;
  String dass;

  String phqFifteenScore;
  String gadSevenScore;
  String phqNineScore;
  String depressionDass;
  String anxietyDass;
  String stressDass;

  TestResultModel(
      this.date,
      this.registerNumber,
      this.phqFifteen,
      this.gadSeven,
      this.phqNine,
      this.dass,
      this.phqFifteenScore,
      this.gadSevenScore,
      this.phqNineScore,
      this.depressionDass,
      this.anxietyDass,
      this.stressDass);

  factory TestResultModel.fromJson(dynamic json) {
    return TestResultModel(
        "${json['date']}",
        "${json['registerNumber']}",
        "${json['phqFifteen']}",
        "${json['gadSeven']}",
        "${json['phqNine']}",
        "${json['dass']}",
        "${json['phqFifteenScore']}",
        "${json['gadSevenScore']}",
        "${json['phqNineScore']}",
        "${json['depressionDass']}",
        "${json['anxietyDass']}",
        "${json['stressDass']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'date': date,
        'registerNumber': registerNumber,
        'phqFifteen': phqFifteen,
        'gadSeven': gadSeven,
        'phqNine': phqNine,
        'dass': dass,
        'phqFifteenScore': phqFifteenScore,
        'gadSevenScore': gadSevenScore,
        'phqNineScore': phqNineScore,
        'depressionDass': depressionDass,
        'anxietyDass': anxietyDass,
        'stressDass': stressDass
      };
}
