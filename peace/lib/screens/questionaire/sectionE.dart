import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:peace/screens/questionaire/phqSuccessScreen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';


class PHQSectionEQuestions extends FormBloc<String, String> {

  final question = SelectFieldBloc(
    name: 'lastQuestion',
    validators: [FieldBlocValidators.required],
    items: ['Not difficult at all', 'Somewhat difficult', 'Very difficult', 'Extremely difficult'],
  );

  PHQSectionEQuestions() {
    addFieldBlocs(fieldBlocs: [question],
    );
  }

  @override
  void onSubmitting() {
    emitSuccess();
  }
}

class PHQSectionE extends StatelessWidget {
  const PHQSectionE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => PHQSectionEQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionEQuestions>();

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
              body: FormBlocListener<PHQSectionEQuestions, String, String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) =>
                          PhqSuccessScreen(),
                    ),
                  );
                },
                onFailure: (context, state) {},
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Peace",
                                  style: TextStyle(
                                      fontFamily: "Cookie",
                                      fontSize: (MediaQuery.of(context).size.height) * 0.08,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      "assets/images/logo.png",
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TouchableOpacity(
                                  onTap: (){
                                    Navigator.of(context, rootNavigator: false).push(
                                      new CupertinoPageRoute<bool>(
                                        fullscreenDialog: false,
                                        builder: (BuildContext context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.home, size: height*0.05, color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "If you checked off any problems on this questionnaire, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?",
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: height*0.035, height: 0.9, color: Colors.green.shade900),
                              ),
                              RadioButtonGroupFieldBlocBuilder(
                                selectFieldBloc: formBloc.question,
                                buttonTextStyle: TextStyle(height: 0.6),
                                itemBuilder: (context, dynamic value) => value,
                                decoration: InputDecoration(
                                  prefixIcon: SizedBox(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width*0.04, vertical: 10),
                          child: MaterialButton(
                            onPressed: (){
                              formBloc.submit();
                            },
                            color: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                            child: Text("Next",
                              style: TextStyle(color: Colors.white, fontSize: height*0.034, height: 1.0 ,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Puducherry Technological University',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
