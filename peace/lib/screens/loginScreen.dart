import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:peace/dataBaseProviders/loginAuthProvider.dart';
import 'package:peace/dataBaseProviders/registrationController.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/fragments/components/passwordSecurityScreen.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:peace/screens/noInternetConnection.dart';
import 'package:peace/screens/registerScreen.dart';
import 'package:peace/screens/splashScreen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class AppStateManager extends StatelessWidget {
  const AppStateManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (BuildContext context, snapshot) {
          if(snapshot.data==null) {
            return SplashScreen();
          }
          else if(snapshot.data == InternetConnectionStatus.connected) {
            return LoginScreen();
          }
          return NoInternetConnection();
        });
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextStyle kLabelStyle(context) {
    return TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.bold,
        fontSize: (MediaQuery.of(context).size.height) * 0.03);
  }

  TextStyle kHintTextStyle(context) {
    return TextStyle(
        color: Colors.white,
        fontSize: (MediaQuery.of(context).size.height) * 0.03);
  }

  final kBoxDecorationStyle = const BoxDecoration(
    color: const Color.fromRGBO(197, 198, 208, 0.5),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
    boxShadow: [
      BoxShadow(
        color: Colors.white,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  final TextEditingController registerNumber = TextEditingController();
  final TextEditingController password = TextEditingController();

  Widget _buildRegisterNumberTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Register Number', style: kLabelStyle(context)),
        const SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: registerNumber,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.black,
                fontSize: (MediaQuery.of(context).size.height) * 0.03),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              hintText: 'Enter your Register Number',
              hintStyle: kHintTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle(context),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: password,
            obscureText: true,
            style: TextStyle(
                color: Colors.black,
                fontSize: (MediaQuery.of(context).size.height) * 0.03),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            new CupertinoPageRoute<bool>(
              fullscreenDialog: false,
              builder: (BuildContext context) => ForgotPasswordForm(),
            ),
          );
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle(context),
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      width: double.infinity,
      child: MaterialButton(
        elevation: 5.0,
        onPressed: () {
          OverlayLoader.show(context);
          LoginAccount loginDetails = LoginAccount(
              registerNumber.text.trim().toUpperCase(), password.text.trim());
          AuthenticationController authProvider = AuthenticationController();
          authProvider.verifyUser(loginDetails,
              (String response, RegisterStudent student) {
            OverlayLoader.hide(context);
            if (response == AuthenticationController.STATUS_SUCCESS) {
              setUpUser(student);
              showSnackBar("Login Successful", context);
              Navigator.of(context, rootNavigator: true).push(
                new CupertinoPageRoute<bool>(
                  fullscreenDialog: false,
                  builder: (BuildContext context) => HomeScreen(),
                ),
              );
            }
            else {
              if (student.name == 'Wrong')
                showSnackBar("Login Error. Please check the login credentials and try again.", context);
              else
                showSnackBar("Login Error. Account not found. Try Signing In", context);
            }
          });
        },
        padding: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.lightBlue.shade900,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: (MediaQuery.of(context).size.height) * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Column(
      children: [
        Text(
          '-- OR --',
          style: TextStyle(
            color: Colors.black,
            fontSize: (MediaQuery.of(context).size.height) * 0.03,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            children: [
              Text('Don\'t have an Account? ',
                style: TextStyle(
                  fontFamily: "Dongle",
                  color: Colors.black,
                  fontSize: (MediaQuery.of(context).size.height) * 0.04,
                  fontWeight: FontWeight.w100,
                ),
              ),
              TouchableOpacity(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text('Sign Up',
                  style: TextStyle(
                    fontFamily: "Dongle",
                    color: Colors.black,
                    fontSize: (MediaQuery.of(context).size.height) * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: height * 0.24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: height * 0.055,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: _buildRegisterNumberTF(),
                          ),
                          SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: _buildPasswordTF(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: _buildForgotPasswordBtn(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: _buildLoginBtn(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: _buildSignupBtn(),
                          ),
                          SizedBox(height: 30.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40.0,
                            ),
                            child: Text(
                              'Puducherry Technological University',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: height * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            WavyHeader(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Peace",
                          style: TextStyle(
                              fontFamily: "Cookie",
                              fontSize:
                                  (MediaQuery.of(context).size.height) * 0.1,
                              color: Colors.lightBlue.shade900,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              "assets/images/logo.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    '(Mental Health Tracker)',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopWaveClipper(),
      child: Container(
        color: Colors.blue.shade50,
        height: MediaQuery.of(context).size.height / 2.5,
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

    var firstControlPoint = new Offset(size.width / 35, size.height / 1.2);
    var firstEndPoint = new Offset(size.width / 8, size.height / 1.4);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 4, size.height / 1.8);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 2.5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
        Offset(size.width - (size.width / 30), size.height / 3.7);
    var thirdEndPoint = Offset(size.width, size.height * 0.1);
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
