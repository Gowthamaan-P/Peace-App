import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/screens/questionaire/sectionA.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({Key? key}) : super(key: key);

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
              height: height*0.75,
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
                    height: height * 0.6,
                    width: width * 0.75,
                    child: AutoSizeText(
                      '''1. Read each and every question carefully before answering.
                       
2. The questionnaire has its unique feature to detect the truthfulness of the answers. So, make sure your answers are as honest as possible.

3. There is no time restriction for each question. Don't hurry up. Take your own time to answer the questionnaire.''',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 30,color: Colors.blue.shade900, height: 1.1),
                      maxLines: 15,
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
                      PHQSectionA(),
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
