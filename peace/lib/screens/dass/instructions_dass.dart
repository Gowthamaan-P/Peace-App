import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/screens/dass/questions.dart';

class DassInstructionScreen extends StatelessWidget {
  const DassInstructionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Spacer(),
          Center(
            child: Container(
              height: height*0.85,
              width: width*0.9,
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: height * 0.09,
                    width: width * 0.75,
                    child: AutoSizeText(
                      "Instructions",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold,color: Colors.orange.shade600,),
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.76,
                    width: width * 0.75,
                    child: AutoSizeText(
                      '''Please read each statement and rate as 0, 1, 2 or 3 which indicates how much the statement applied to you over the past week. There are no right or wrong answers. Do not spend too much time on any statement.

The rating scale is as follows:
0   Did not apply to me at all

1   Applied to me to some degree, or some of the time

2   Applied to me to a considerable degree, or a good part of time

3   Applied to me very much, or most of the time''',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 30,color: Colors.blue.shade900, height: 0.85),
                      maxLines: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          MaterialButton(
            onPressed: (){
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute<bool>(
                  fullscreenDialog: false,
                  builder: (BuildContext context) =>
                      DassSection(),
                ),
              );
            },
            color: Colors.blue.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
            child: Text("Start",
              style: TextStyle(color: Colors.white, fontSize: height*0.05,  fontWeight: FontWeight.bold, height: 1),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
