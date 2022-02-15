import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class FaqController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxBsRENSsOKUktiKyQ2s310cn4YDovLB9zQc4uMt2EUVCRz48k/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addFaq(
      FaqModel account, void Function(String) callback) async {
    try {
      await http.post(Uri.parse(URL), body: account.toJson()).then((response) async {
        if (response.statusCode == 302) {
          String url = response.headers['location'] ?? " ";
          await http.get(Uri.parse(url)).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });}
        else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print("Error $e");
    }
  }

  Future<List<FaqModel>> getFaqList() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FaqModel.fromJson(json)).toList();
    });
  }
}


class FaqModel {
  String question;
  String answer;

  FaqModel(this.question, this.answer);

  factory FaqModel.fromJson(dynamic json) {
    return FaqModel(
      "${json['question']}",
      "${json['answer']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
    'question': question,
    'answer': answer
  };
}

