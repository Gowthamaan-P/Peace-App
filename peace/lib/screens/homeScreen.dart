import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math' as math;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:peace/dataBaseProviders/councellorContactProvider.dart';
import 'package:peace/helpers/scheduleTestHelper.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/quote.dart';
import 'package:peace/screens/fragments/analytics.dart';
import 'package:peace/screens/fragments/profile.dart';
import 'package:peace/screens/fragments/settings.dart';
import 'package:peace/screens/questionaire/instructionScreen.dart';
import 'package:rive/rive.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fragments/components/testHistoryPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Quote quote = Quote("Getting Today's Quote...", "");

  @override
  void initState() {
    super.initState();
    getQuote();
    getCouncellorContacts();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return WillPopScope(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: height * 0.35,
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  color: Colors.blue.shade50,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Hi, friend",
                                  style: TextStyle(
                                      fontFamily: "Cookie",
                                      fontSize:
                                      (MediaQuery.of(context).size.height) * 0.06,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                circleAvatar(height, Icons.account_circle_rounded, (){
                                  Navigator.of(context, rootNavigator: false).push(
                                    new CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          ProfilePage(),
                                    ),
                                  );
                                }),
                                circleAvatar(height, Icons.settings, (){
                                  Navigator.of(context, rootNavigator: false).push(
                                    new CupertinoPageRoute<bool>(
                                      fullscreenDialog: false,
                                      builder: (BuildContext context) =>
                                          SettingsPage(),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TouchableOpacity(
                        onTap: (){
                          scheduleTestFunction(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: height * 0.07,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    "Schedule a Test",
                                    style: TextStyle(
                                        fontSize:
                                        (MediaQuery.of(context).size.height) * 0.035,
                                        color: Colors.black38),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: CircleAvatar(
                                    radius: height * 0.02,
                                    backgroundColor: Colors.black26,
                                    child: Icon(Icons.chevron_right_rounded,
                                        size: height * 0.04, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(height: height*0.23,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                                child: Text(
                                  "How do you feel today?",
                                  style: TextStyle(
                                      fontSize: (MediaQuery.of(context).size.height) * 0.035,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    emojiButton("😔", "Badly", () {
                                      showSnackBar("Everything will be alright! Let's take up a test",context);
                                      Navigator.of(context, rootNavigator: false).push(
                                        new CupertinoPageRoute<bool>(
                                          fullscreenDialog: false,
                                          builder: (BuildContext context) =>
                                              InstructionScreen(),
                                        ),
                                      );
                                    }),
                                    emojiButton("😊", "Fine", () {
                                      showSnackBar("  You're doing great.Keep up the work.  ",context);
                                    }),
                                    emojiButton("😃", "Well", () {
                                      showSnackBar("    Look at you! Dazzling like gold.    ",context);
                                    }),
                                    emojiButton("😁", "Excellent", () {
                                      showSnackBar("  Well! You're an inspiration   ",context);
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
              child: Divider(
                color: Colors.grey.shade400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                color: Colors.blue.shade50,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.05,
                      width: width * 0.87,
                      child: AutoSizeText(
                        'Quote of the day',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.deepOrange.shade300,
                            fontFamily: "BadScript"),
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.197,
                      width: width * 0.87,
                      child: AutoSizeText(
                        quote.quote,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "BadScript",
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue.shade900,
                        ),
                        maxLines: 5,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.06,
                      width: width * 0.87,
                      child: AutoSizeText('- ' + quote.author,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: "BadScript",
                            fontSize: 30,
                            color: Colors.lightBlue.shade900,
                          ),
                          maxLines: 2),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: height*1.07,
                  color: Colors.blue.shade50,
                  child: Column(
                    children: <Widget>[
                      Container(height: height/4),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Health is Wealth",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: (MediaQuery.of(context).size.height) * 0.06,
                                      color: Colors.lightBlue.shade900,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: height*0.2,
                                    width: width*0.35,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.fitHeight,
                                            image: AssetImage(
                                              "assets/images/peace.png",
                                            ))),
                                  ),
                                ),
                                Text(
                                  "Always take time to treat and look after yourself because,",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: (MediaQuery.of(context).size.height) * 0.04,
                                      color: Colors.lightBlue.shade900,
                                      height: 1.1,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "You're amazing!",
                                    style: TextStyle(
                                        fontFamily: 'BadScript',
                                        fontSize: (MediaQuery.of(context).size.height) * 0.055,
                                        color: Colors.amber.shade600,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  "Let's take the first step and finish the test.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: (MediaQuery.of(context).size.height) * 0.04,
                                      color: Colors.lightBlue.shade900,
                                      height: 1.1,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TouchableOpacity(
                                  onTap: (){
                                    Navigator.of(context, rootNavigator: false).push(
                                      new CupertinoPageRoute<bool>(
                                        fullscreenDialog: false,
                                        builder: (BuildContext context) =>
                                            InstructionScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    child: Container(
                                      height: height * 0.065,
                                      width: width/2.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.all(Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Text(
                                          "Take up Test",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                              fontSize: (MediaQuery.of(context).size.height) * 0.04,
                                              color: Colors.blue.shade800),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CenterDesign(Colors.white),
                SizedBox(
                  height: height/4,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: height*0.15,
                            width: width*0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      "assets/images/logo.png",
                                    ))),
                          ),
                        ),
                      ),
                      Spacer(),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: height*0.15,
                              width: width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/images/logo_white.png",
                                      ))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CenterDesign(Colors.blue.shade50),
                ),
                Container(
                  height: height*0.83,
                  color: Colors.transparent,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                          height: height*0.45,
                          width: width,
                          child: RiveAnimation.asset(
                            'assets/images/manBoxes.riv',
                            fit: BoxFit.contain,
                            stateMachines: ['Holding_man'],
                          ),),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Text(
                                    "Ever had an urge to talk? \n Holding up a lot and you need someone to listen to?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: (MediaQuery.of(context).size.height) * 0.045,
                                        color: Colors.indigo.shade900,
                                        height: 1.1,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                                  child: TouchableOpacity(
                                    onTap: (){
                                      bookAppointment(context);
                                    },
                                    child: Container(
                                      height: height * 0.07,
                                      width: width/1.5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade100,
                                          borderRadius: BorderRadius.all(Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Text(
                                          "Talk with us 😊",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: (MediaQuery.of(context).size.height) * 0.04,
                                              color: Colors.indigo.shade900),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
              child: Divider(color: Colors.grey.shade400),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Analytics",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.height) * 0.07,
                    color: Colors.deepOrange.shade400,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0, left: 15.0, right: 15.0),
              child: Text(
                "Keep the track of your progress and Lets grow together.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (MediaQuery.of(context).size.height) * 0.04,
                    color: Colors.lightBlue.shade900,
                    height: 1,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(
              height: height*0.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: AnalyticsWidget(),
              ),
            ),
            TouchableOpacity(
              onTap: (){
                Navigator.of(context, rootNavigator: false).push(
                  new CupertinoPageRoute<bool>(
                    fullscreenDialog: false,
                    builder: (BuildContext context) =>
                        HistoryPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: height * 0.07,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Test History",
                          style: TextStyle(
                              fontSize:
                              (MediaQuery.of(context).size.height) * 0.040,
                              color: Colors.blue.shade900),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CircleAvatar(
                          radius: height * 0.02,
                          backgroundColor: Colors.black26,
                          child: Icon(Icons.chevron_right_rounded,
                              size: height * 0.04, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  height: height*0.4,
                  color: Colors.blue.shade50,
                  child: Column(
                    children: <Widget>[
                      Container(height: height/5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TouchableOpacity(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height*0.12,
                                    width: height*0.12,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          "assets/images/ptu_logo.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.12,
                                    width: width * 0.6,
                                    child: Center(
                                      child: AutoSizeText(
                                        "Puducherry Technological University",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: height*0.045,
                                          height: 0.9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlue.shade900,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: _launchURL,
                            ),
                            SizedBox(height: 16,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '©Copyright-2022\nPuducherry Technological University',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  height: 0.9,
                                  fontSize: (MediaQuery.of(context).size.height)*0.027,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CenterDesign(Colors.white),
                SizedBox(
                  height: height/4,
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: height*0.15,
                            width: width*0.3,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      "assets/images/logo.png",
                                    ))),
                          ),
                        ),
                      ),
                      Spacer(),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: height*0.15,
                              width: width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        "assets/images/logo_white.png",
                                      ))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }

  void getQuote() async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      var url = Uri.parse("https://zenquotes.io/api/random");
      http.Response quoteResponse = await http.get(url);
      var jsonFeedback = convert.jsonDecode(quoteResponse.body);
      setState(() {
        quote = Quote.fromJson(jsonFeedback[0]);
      });
    }

    else {
      quote = Quote("No Internet Connection", "");
      setState(() {});
    }
  }

  _launchURL() async {
    const url = 'https://www.pec.edu/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget circleAvatar(double height, IconData icon, VoidCallback? onTap){
    return TouchableOpacity(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: height * 0.035,
          backgroundColor: Colors.blue.shade100,
          child: Center(
            child: Icon(
              icon,
              size: height * 0.04,
              color: Colors.lightBlue.shade900,
            ),
          ),
        ),
      ),
    );
  }

  Widget emojiButton(String emojiText, String labelText, VoidCallback? onTap){
    return TouchableOpacity(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Text(
              emojiText,
              style: TextStyle(
                  fontSize:
                  (MediaQuery.of(context).size.height) * 0.04,
                  color: Colors.lightBlue.shade900,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            labelText,
            style: TextStyle(
                fontSize:
                (MediaQuery.of(context).size.height) * 0.03,
                color: Colors.indigo,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

class CenterDesign extends StatelessWidget {
  final Color color;
   const CenterDesign(this.color);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        color: color,
        height: MediaQuery.of(context).size.height/3.9,

      ),
    );
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width/35, size.height/1.2);
    var firstEndPoint = new Offset(size.width /8, size.height/1.4);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4, size.height / 1.8);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 2.5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
    Offset(size.width - (size.width / 30), size.height/3.7);
    var thirdEndPoint = Offset(size.width, size.height*0.1);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}