import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/dataBaseProviders/testResultsController.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/testResults.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/dass/instructions_dass.dart';
import 'package:rive/rive.dart';

import '../homeScreen.dart';
import 'instructionScreen.dart';

class PhqSuccessScreen extends StatelessWidget {
  const PhqSuccessScreen({Key? key}) : super(key: key);

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
            Center(
              child: SizedBox(
                height: height * 0.6,
                width: width * 0.9,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: height * 0.15,
                        color: Colors.green.shade700,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "SHQ-Test Completed",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: height * 0.05,
                              color: Colors.green.shade700,
                              height: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.035, horizontal: 10.0),
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "You can proceed to DASS Test if you want to analyse more about your current mental state.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: height * 0.04,
                              color: Colors.lightBlue.shade900,
                              height: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                    fontSize: 35),
                              ),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  new CupertinoPageRoute<bool>(
                                    fullscreenDialog: false,
                                    builder: (BuildContext context) =>
                                        DassInstructionScreen(),
                                  ),
                                );
                              }),
                          MaterialButton(
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade900,
                                    fontSize: 35),
                              ),
                              onPressed: () {
                                OverlayLoader.show(context);
                                TestResultModel testResultModel =
                                    TestResultModel(
                                        DateTime.now()
                                            .toIso8601String()
                                            .substring(0, 10),
                                        user.registerNumber,
                                        studentTestResults.phqFifteen,
                                        studentTestResults.gadSeven,
                                        studentTestResults.phqNine,
                                        'Not Opted',
                                        studentTestResults
                                            .phqFifteenScore
                                            .toString(),
                                        studentTestResults
                                            .gadSevenScore
                                            .toString(),
                                        studentTestResults.phqNineScore
                                            .toString(),
                                        'Not Opted',
                                        'Not Opted',
                                        'Not Opted');

                                TestResultsControllerModel().addTestResult(
                                    testResultModel, (String response) {
                                      resetTestResults();
                                  OverlayLoader.hide(context);
                                  if (response ==
                                      TestResultsControllerModel
                                          .STATUS_SUCCESS) {

                                    Navigator.of(context, rootNavigator: false)
                                        .push(
                                      new CupertinoPageRoute<bool>(
                                        fullscreenDialog: false,
                                        builder: (BuildContext context) =>
                                            HomeScreen(),
                                      ),
                                    );
                                  } else {
                                    showSnackBar(
                                        'Unexpected error occurred. Kindly do the test again.',
                                        context);
                                    Navigator.of(context, rootNavigator: false)
                                        .push(
                                      new CupertinoPageRoute<bool>(
                                        fullscreenDialog: false,
                                        builder: (BuildContext context) =>
                                            InstructionScreen(),
                                      ),
                                    );
                                  }
                                });
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

