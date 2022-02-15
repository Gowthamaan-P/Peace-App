import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:peace/dataBaseProviders/appointmentController.dart';

void showSnackBar(String message, BuildContext context){

  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;

  final snackBar = SnackBar(
    duration: Duration(seconds: 2),
    padding: EdgeInsets.zero,
    content: SizedBox(
      height: height * 0.03,
      width: width * 0.6,
      child: AutoSizeText(message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            height: 0.7,
            fontFamily: 'Dongle',
            color: Colors.white,
          ),
          maxLines: 2),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    backgroundColor: Colors.black54,
    width: width*0.7,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void bookAppointment(BuildContext context)async{
  bool confirmBooking = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.all(10.0),
          titlePadding: const EdgeInsets.all(20.0),
          actionsPadding: const EdgeInsets.all(10.0),
          title:Center(
            child: Text(
              "Talk with us 😊",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: (MediaQuery.of(context).size.height) * 0.045,
                  color: Colors.indigo.shade900),
            ),
          ),
          content: SizedBox(
            height: (MediaQuery.of(context).size.height) * 0.35,
            width: (MediaQuery.of(context).size.width) * 0.75,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AutoSizeText(
                '''1. Everything you say is completely anonymous, safe, secure and well-guarded.
                         
2. You can talk freely without any hesitation. We are here to help you.

Confirm here to book an appointment and our councellor will contact you''',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 30,color: Colors.black, height: 0.8),
                maxLines: 20,
              ),
            ),
          ),
          actions: <Widget>[
            MaterialButton(
                child: Text('Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                      fontSize: 35

                  ),),
                onPressed: (){
                  Navigator.of(context).pop(true);
                }),
            MaterialButton(
                child: Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.green.shade900,
                      fontSize: 35
                  ),),
                onPressed: () => Navigator.of(context).pop(false)),
          ]));

  if(confirmBooking)
    addAppointment(context);
}