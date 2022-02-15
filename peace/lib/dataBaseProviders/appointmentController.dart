import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/user.dart';



class StudentAppointmentController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyBoLisVdY2xPLsD_DoyFZusiMH4jWkz1TxsfTN8cyPgPQ9x44O/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  void addAppointment(
      AppointmentDetails itemForm, void Function(String) callback) async {
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

  Future<List<AppointmentDetails>> getAppointmentList() async {
    return await http.get(Uri.parse(URL)).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback
          .map((json) => AppointmentDetails.fromJson(json))
          .toList();
    });
  }
}

class AppointmentDetails {
  String email;
  String name;
  String registerNumber;
  String date;
  String department;

  AppointmentDetails(
      this.email, this.name, this.registerNumber, this.date, this.department);

  factory AppointmentDetails.fromJson(dynamic json) {
    return AppointmentDetails(
        "${json['email'].toString()}",
        "${json['name'].toString()}",
        "${json['registerNumber'].toString()}",
        "${json['date'].toString()}",
        "${json['department'].toString()}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        "email": email,
        "name": name,
        "registerNumber": registerNumber,
        "date": date,
        "department": department
      };
}

void addAppointment(context) {
  AppointmentDetails appointmentDetails = AppointmentDetails(
      user.email, user.name, user.registerNumber, DateTime.now().toIso8601String().substring(0, 10), user.department);

  StudentAppointmentController controller = StudentAppointmentController();
  controller.addAppointment(appointmentDetails, (String response) {
    if(response==StudentAppointmentController.STATUS_SUCCESS)
      showSnackBar("Appointment booked successfully. Our councellor will contact you.", context);
    else
      showSnackBar("Error in booking appointment. Please try again later", context);
  });
}
