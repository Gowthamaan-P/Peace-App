import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class CouncellorContactProvider {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbwSnN8RTSRP581fpmxaaa_G2jsOqyBJbzNfuz-JBBP0hhUpmayg/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addCouncellor(
      CouncellorContact itemForm, void Function(String) callback) async {
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

  Future<List<CouncellorContact>> getCouncellor() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => CouncellorContact.fromJson(json)).toList();
    });
  }
}

class CouncellorContact {
  String professorName;
  String department;
  String email;
  String phoneNumber;
  String pictureUrl;
  String profileUrl;


  CouncellorContact(
      this.professorName,
      this.department,
      this.email,
      this.phoneNumber,
      this.pictureUrl,
      this.profileUrl);

  factory CouncellorContact.fromJson(dynamic json) {
    return CouncellorContact(
        "${json['name']}",
        "${json['department']}",
        "${json['email']}",
        "${json['phoneNumber']}",
        "${json['pictureurl']}",
        "${json['profileurl']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    "name": professorName,
    "department": department,
    "email": email,
    "phoneNumber": phoneNumber,
    "pictureurl": pictureUrl,
    "profileurl": profileUrl
  };
}

List<CouncellorContact> councellor = [];

void getCouncellorContacts()async{
  councellor = await CouncellorContactProvider().getCouncellor();
  councellor.removeLast();
}