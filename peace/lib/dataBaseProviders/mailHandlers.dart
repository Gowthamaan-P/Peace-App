import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SendSuccessEmail {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyKb7BZNj3fjtJ7_CYI0l3No_QyvFKD_lB515tt/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void sendMail(AccountCreated itemForm, void Function(String) callback) async {
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
}

class AccountCreated {
  String email;

  AccountCreated(this.email);

  factory AccountCreated.fromJson(dynamic json) {
    return AccountCreated("${json['mailId'].toString()}");
  }

  Map toJson() => {"mailId": email};
}

class SendScheduleEmail {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbxAemmews3pad5A0-zqhTm0ds4oe_fiKnFuL6X-/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void sendMail(ScheduleData itemForm, void Function(String) callback) async {
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
}

class ScheduleData {
  String email;
  String date;
  String name;

  ScheduleData(this.email, this.date, this.name);

  factory ScheduleData.fromJson(dynamic json) {
    return ScheduleData("${json['mailId']}", "${json['scheduleTime']}", "${json['name']}");
  }

  Map toJson() => {"mailId": email, 'scheduleTime':date, 'name':name};
}

class SendResetEmail {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyKb7BZNj3fjtJ7_CYI0l3No_QyvFKD_lB515tt/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void sendMail(AccountCreated itemForm, void Function(String) callback) async {
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
}

/*
class PasswordReset {
  String email;
  String registerNumber;
  String password;
  String stageFlag;
  String verificationCode;

  PasswordReset(this.email);

  factory PasswordReset.fromJson(dynamic json) {
    return PasswordReset("${json['mailId'].toString()}");
  }

  Map toJson() => {"mailId": email};
}*/
