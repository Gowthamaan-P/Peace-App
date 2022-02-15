import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/dataBaseProviders/testResultsController.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/testResults.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/questionaire/instructionScreen.dart';
import 'package:rive/rive.dart';

import '../homeScreen.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: Color(0xFF1B72DF),
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: height * 0.5,
              width: width * 0.9,
              child: RiveAnimation.asset(
                'assets/images/success_screen.riv',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                color: Color(0xFF1B72DF),
                height: height * 0.5,
                width: width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width * 0.3,
                      height: height * 0.3,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: width * 0.3,
                              height: height * 0.3,
                              child: CircleAvatar(
                                  backgroundColor: Color(0XFF2278DE)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: width * 0.25,
                              height: height * 0.25,
                              child: CircleAvatar(
                                  backgroundColor: Color(0XFF2C7EE2)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.check_circle_rounded,
                                color: Colors.white, size: height * 0.1),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Completed!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: height * 0.05,
                            color: Colors.white,
                            height: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Take care of yourself and be strong and happy.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: height * 0.035,
                            color: Colors.white,
                            height: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: MaterialButton(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1B72DF),
                          fontSize: 35),
                    ),
                    onPressed: () {
                      OverlayLoader.show(context);
                      TestResultModel testResultModel = TestResultModel(
                          DateTime.now().toIso8601String().substring(0, 10),
                          user.registerNumber,
                          studentTestResults.phqFifteen,
                          studentTestResults.gadSeven,
                          studentTestResults.phqNine,
                          studentTestResults.dass,
                          studentTestResults.phqFifteenScore.toString(),
                          studentTestResults.gadSevenScore.toString(),
                          studentTestResults.phqNineScore.toString(),
                          studentTestResults.depressionDass.toString(),
                          studentTestResults.anxietyDass.toString(),
                          studentTestResults.stressDass.toString());

                      TestResultsControllerModel()
                          .addTestResult(testResultModel, (String response) {
                        OverlayLoader.hide(context);
                        resetTestResults();
                        if (response ==
                            TestResultsControllerModel.STATUS_SUCCESS) {

                          Navigator.of(context, rootNavigator: false).push(
                            new CupertinoPageRoute<bool>(
                              fullscreenDialog: false,
                              builder: (BuildContext context) => HomeScreen(),
                            ),
                          );
                        } else {
                          showSnackBar(
                              'Unexpected error occurred. Kindly do the test again.',
                              context);
                          Navigator.of(context, rootNavigator: false).push(
                            new CupertinoPageRoute<bool>(
                              fullscreenDialog: false,
                              builder: (BuildContext context) =>
                                  InstructionScreen(),
                            ),
                          );
                        }
                      });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
