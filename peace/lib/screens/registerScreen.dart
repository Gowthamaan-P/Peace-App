import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peace/dataBaseProviders/loginController.dart';
import 'package:peace/dataBaseProviders/mailHandlers.dart';
import 'package:peace/dataBaseProviders/registrationController.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/screens/loginScreen.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class RegistrationForm extends FormBloc<String, String> {
  final name = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final registerNumber =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
      validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final confirmPassword =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final gender = SelectFieldBloc(
      items: ['Male', 'Female', 'Transgender', 'Other', 'Prefer not to say']);
  final sslc = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final hsc = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final income = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final hobbies = TextFieldBloc(validators: [FieldBlocValidators.required]);

  Validator<String> _confirmPassword(
    TextFieldBloc passwordTextFieldBloc,
  ) {
    return (String? confirmPassword) {
      if (confirmPassword == passwordTextFieldBloc.value) {
        return null;
      }
      return 'Must be equal to password';
    };
  }

  RegistrationForm() {
    addFieldBlocs(step: 0, fieldBlocs: [
      name,
      registerNumber,
      email,
      password,
      confirmPassword,
      gender,
      sslc,
      hsc,
      income,
      hobbies
    ]);

    confirmPassword
      ..addValidators([_confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);
  }

  @override
  void onSubmitting() async {
    RegisterStudent student = RegisterStudent(
        email.value!,
        name.value!,
        registerNumber.value!,
        gender.value!,
        sslc.value!,
        hsc.value!,
        income.value!,
        hobbies.value!);
    LoginRegister loginCredentials = LoginRegister(registerNumber.value!, password.value!);
    StudentRegisterController register = StudentRegisterController();
    StudentLoginRegisterController login = StudentLoginRegisterController();
    register.addStudent(student, (String response) {
      if(response == StudentRegisterController.STATUS_SUCCESS){
        login.addStudent(loginCredentials, (String response) {
          if(response == StudentLoginRegisterController.STATUS_SUCCESS) {
            SendSuccessEmail().sendMail(AccountCreated(student.email), (String response) { });
            emitSuccess();
          }
          else
            emitFailure();
        });
      }
    });
  }

  @override
  void onLoading() async {}
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => RegistrationForm(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<RegistrationForm>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.blue.shade50,
              body: Stack(
                children: [
                  FormBlocListener<RegistrationForm, String, String>(
                    onSubmitting: (context, state) {
                      OverlayLoader.show(context);
                    },
                    onSuccess: (context, state) {
                      showSnackBar("Registration Successful", context);
                      OverlayLoader.hide(context);
                      Navigator.of(context, rootNavigator: true).push(
                        new CupertinoPageRoute<bool>(
                          fullscreenDialog: false,
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                    onFailure: (context, state) {
                      showSnackBar("Unexpected error occurred. Please try again later.", context);
                      OverlayLoader.hide(context);
                    },
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: height * 0.25),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize:
                                        (MediaQuery.of(context).size.height) *
                                            0.055,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.name,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon:
                                      Icon(Icons.account_circle_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.registerNumber,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Register Number',
                                  prefixIcon:
                                      Icon(Icons.confirmation_number_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.email,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Institutional Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              DropdownFieldBlocBuilder<String>(
                                  selectFieldBloc: formBloc.gender,
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    labelStyle:
                                        TextStyle(fontSize: height * 0.035),
                                    prefixIcon: Icon(Icons.accessibility),
                                  ),
                                  itemBuilder: (context, value) => value),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.sslc,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'SSLC School Name',
                                  prefixIcon: Icon(Icons.school_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.hsc,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'HSC School Name',
                                  prefixIcon: Icon(Icons.school_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.income,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Annual Family Income',
                                  prefixIcon: Icon(Icons.money),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.hobbies,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Hobbies',
                                  prefixIcon: Icon(Icons.play_for_work_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.password,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.confirmPassword,
                                style: TextStyle(fontSize: height * 0.035),
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 25.0),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    onPressed: () => formBloc.submit(),
                                    padding: EdgeInsets.all(5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.lightBlue.shade900,
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: (MediaQuery.of(context)
                                                .size
                                                .height) *
                                            0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Puducherry Technological University',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      (MediaQuery.of(context).size.height) *
                                          0.025,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                                        (MediaQuery.of(context).size.height) *
                                            0.1,
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
                            fontSize: height*0.03,
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
        },
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
        color: Colors.white,
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
