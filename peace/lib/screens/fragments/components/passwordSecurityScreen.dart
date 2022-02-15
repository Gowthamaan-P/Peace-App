import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/helpers/loadingScreen.dart';

String emailVerificationCode = "";

class ForgetPasswordFormBloc extends FormBloc<String, String> {

  final companyMail = TextFieldBloc(validators: [FieldBlocValidators.required, FieldBlocValidators.email]);

  final verificationCode = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final confirmPassword = TextFieldBloc(validators: [FieldBlocValidators.required]);



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

  Future<String?> _checkVerificationCode(String? enteredCode) async {
    await Future.delayed(Duration(milliseconds: 500));
    if (enteredCode?.toLowerCase() != emailVerificationCode) {
      return 'Please check the verification code!';
    }
    return null;
  }


  Future<String?> _checkEmail(String? email) async {
    await Future.delayed(Duration(milliseconds: 500));
    return null;
  }

  ForgetPasswordFormBloc() {
    addFieldBlocs(step: 0, fieldBlocs: [
      companyMail
    ]);
    companyMail.addAsyncValidators([_checkEmail]);

    addFieldBlocs(step: 1, fieldBlocs: [verificationCode]);
    verificationCode.addAsyncValidators([_checkVerificationCode,]);

    addFieldBlocs(step: 2, fieldBlocs: [password, confirmPassword]);
    confirmPassword
      ..addValidators([_confirmPassword(password)])
      ..subscribeToFieldBlocs([password]);
  }

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      emitSuccess();
    }
    else if (state.currentStep == 1) {
      emitSuccess();
    }
    else if (state.currentStep == 2) {
      emitSuccess();
    }
  }
}

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  var _type = StepperType.vertical;


  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ForgetPasswordFormBloc(),
      child: Builder(
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                toolbarHeight: 70,
                automaticallyImplyLeading: true,
                backgroundColor: Colors.lightBlue.shade900,
                title: Text(
                  'Password Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
              ),
              body: SafeArea(
                child: FormBlocListener<ForgetPasswordFormBloc, String, String>(
                  onSubmitting: (context, state) => OverlayLoader.show(context),
                  onSuccess: (context, state) {
                    OverlayLoader.hide(context);
                    if (state.stepCompleted == state.lastStep) {

                    }
                  },
                  onFailure: (context, state) {
                    OverlayLoader.hide(context);
                  },
                  child: StepperFormBlocBuilder<ForgetPasswordFormBloc>(
                    formBloc: context.read<ForgetPasswordFormBloc>(),
                    type: _type,
                    physics: ClampingScrollPhysics(),

                    stepsBuilder: (formBloc) {
                      return [
                        _accountStep(formBloc!),
                        _emailVerification(formBloc),
                        _passwordValidation(formBloc),
                      ];
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  FormBlocStep _accountStep(ForgetPasswordFormBloc clientFormBloc) {
    final height = MediaQuery.of(context).size.height;
    return FormBlocStep(
      title: Text(
        'Find Account',
        style: TextStyle(
          color: Colors.black,
          fontSize: height*0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldBlocBuilder(
                textFieldBloc: clientFormBloc.companyMail,
                decoration: InputDecoration(
                  labelText: 'Organisation Email',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.email_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FormBlocStep _emailVerification(ForgetPasswordFormBloc clientFormBloc) {

    final height = MediaQuery.of(context).size.height;
    return FormBlocStep(
      title: Text(
        'Verify Account',
        style: TextStyle(
          color: Colors.black,
          fontSize: height*0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.mark_email_unread_rounded,
            size: MediaQuery.of(context).size.height*0.1,
            color: Colors.blue.shade100,
          ),
          Text("Email Verification",
            style: TextStyle(
              fontSize: height*0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text("Please enter the 6 digit code sent to ${clientFormBloc.companyMail.value}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: height*0.03,
                height: 0.9,
                color: Colors.grey.shade400
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFieldBlocBuilder(
              textFieldBloc: clientFormBloc.verificationCode,
              keyboardType: TextInputType.emailAddress,
              enableOnlyWhenFormBlocCanSubmit: true,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 18),
                labelText: 'Enter the verification Code',
                prefixIcon: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _passwordValidation(ForgetPasswordFormBloc clientFormBloc) {
    final height = MediaQuery.of(context).size.height;
    return FormBlocStep(
      title: Text(
        'Reset Password',
        style: TextStyle(
          color: Colors.black,
          fontSize: height*0.03,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldBlocBuilder(
                textFieldBloc: clientFormBloc.password,
                autofillHints: [AutofillHints.password],
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldBlocBuilder(
                textFieldBloc: clientFormBloc.confirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



